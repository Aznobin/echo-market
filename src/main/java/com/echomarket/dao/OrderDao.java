package com.echomarket.dao;

import com.echomarket.entity.Order;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;

public class OrderDao {

    public Order createOrder(int productId, int buyerId, String deliveryType,
                             String payMethod, String receiverName, String phone,
                             String address, String remark) throws SQLException {
        String selectProductSql = "SELECT seller_id, price, status FROM product WHERE id = ? FOR UPDATE";
        String updateProductSql = "UPDATE product SET status = 1 WHERE id = ? AND status = 0";
        String insertOrderSql = "INSERT INTO orders " +
                "(order_no, product_id, buyer_id, seller_id, amount, delivery_type, pay_method, receiver_name, phone, address, remark, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBUtilDao.getDataSource().getConnection();
            conn.setAutoCommit(false);

            int sellerId;
            BigDecimal amount;
            int productStatus;

            try (PreparedStatement ps = conn.prepareStatement(selectProductSql)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        throw new IllegalStateException("商品不存在");
                    }
                    sellerId = rs.getInt("seller_id");
                    amount = rs.getBigDecimal("price");
                    productStatus = rs.getInt("status");
                }
            }

            if (productStatus != 0) {
                conn.rollback();
                throw new IllegalStateException("商品当前不可购买");
            }
            if (sellerId == buyerId) {
                conn.rollback();
                throw new IllegalStateException("不能购买自己发布的商品");
            }

            try (PreparedStatement ps = conn.prepareStatement(updateProductSql)) {
                ps.setInt(1, productId);
                int updated = ps.executeUpdate();
                if (updated != 1) {
                    conn.rollback();
                    throw new IllegalStateException("商品状态更新失败，可能已被抢购");
                }
            }

            String orderNo = generateOrderNo();
            int initialStatus = 0; // 0: 待付款

            Order order = new Order();
            order.setOrderNo(orderNo);
            order.setProductId(productId);
            order.setBuyerId(buyerId);
            order.setSellerId(sellerId);
            order.setAmount(amount);
            order.setDeliveryType(deliveryType);
            order.setPayMethod(payMethod);
            order.setReceiverName(receiverName);
            order.setPhone(phone);
            order.setAddress(address);
            order.setRemark(remark);
            order.setStatus(initialStatus);

            try (PreparedStatement ps = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, orderNo);
                ps.setInt(2, productId);
                ps.setInt(3, buyerId);
                ps.setInt(4, sellerId);
                ps.setBigDecimal(5, amount);
                ps.setString(6, deliveryType);
                ps.setString(7, payMethod);
                ps.setString(8, receiverName);
                ps.setString(9, phone);
                ps.setString(10, address);
                ps.setString(11, remark);
                ps.setInt(12, initialStatus);

                int rows = ps.executeUpdate();
                if (rows != 1) {
                    conn.rollback();
                    throw new SQLException("插入订单失败");
                }
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        order.setId(keys.getInt(1));
                    }
                }
            }

            conn.commit();
            return order;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }
            if (e instanceof SQLException) {
                throw (SQLException) e;
            }
            if (e instanceof IllegalStateException) {
                throw (IllegalStateException) e;
            }
            throw new SQLException("下单事务执行异常", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private String generateOrderNo() {
        String timePart = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int randPart = ThreadLocalRandom.current().nextInt(1000, 10000);
        return "EM" + timePart + randPart;
    }
}