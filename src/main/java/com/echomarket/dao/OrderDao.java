package com.echomarket.dao;

import com.echomarket.entity.Order;

import com.echomarket.dao.DBUtilDao;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
// 订单数据操作类
public class OrderDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    // 创建订单并锁定商品
    public Order createOrder(int productId, int buyerId, String deliveryType,
                             String payMethod, String receiverName, String phone,
                             String address, String remark) throws SQLException {
        String selectProductSql = "select seller_id, price, status from product where id = ? FOR update";
        String updateProductSql = "update product set status = 1 where id = ? and status = 0";
        String insertOrderSql = "insert into orders " +
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
            int initialStatus = 0;

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

    // 查询订单详情
    public Order findById(int id) throws SQLException {
        String sql = "select o.id, o.order_no as orderNo, o.product_id as productId, o.buyer_id as buyerId, " +
                "o.seller_id as sellerId, o.amount, o.delivery_type as deliveryType, o.pay_method as payMethod, " +
                "o.receiver_name as receiverName, o.phone, o.address, o.remark, o.status, " +
                "o.update_time as updateTime, p.title as productTitle, p.image as productImage, " +
                "bu.username as buyerName, su.username as sellerName " +
                "from orders o " +
                "left join product p on o.product_id = p.id " +
                "left join `user` bu on o.buyer_id = bu.id " +
                "left join `user` su on o.seller_id = su.id " +
                "where o.id = ?";
        return qr.query(sql, new BeanHandler<>(Order.class), id);
    }

    // 查询买家订单
    public List<Order> listByBuyer(int buyerId, int status) throws SQLException {
        String sql = "select o.id, o.order_no as orderNo, o.product_id as productId, o.buyer_id as buyerId, " +
                "o.seller_id as sellerId, o.amount, o.delivery_type as deliveryType, o.pay_method as payMethod, " +
                "o.receiver_name as receiverName, o.phone, o.address, o.remark, o.status, " +
                "o.update_time as updateTime, p.title as productTitle, p.image as productImage, " +
                "bu.username as buyerName, su.username as sellerName " +
                "from orders o " +
                "left join product p on o.product_id = p.id " +
                "left join `user` bu on o.buyer_id = bu.id " +
                "left join `user` su on o.seller_id = su.id " +
                "where o.buyer_id = ?";
        List<Object> params = new ArrayList<>();
        params.add(buyerId);
        if (status >= 0) {
            sql = sql + " AND o.status = ?";
            params.add(status);
        }
        sql = sql + " ORDER BY o.id DESC";
        return qr.query(sql, new BeanListHandler<>(Order.class), params.toArray());
    }

    // 查询卖家订单
    public List<Order> listBySeller(int sellerId, int status) throws SQLException {
        String sql = "select o.id, o.order_no as orderNo, o.product_id as productId, o.buyer_id as buyerId, " +
                "o.seller_id as sellerId, o.amount, o.delivery_type as deliveryType, o.pay_method as payMethod, " +
                "o.receiver_name as receiverName, o.phone, o.address, o.remark, o.status, " +
                "o.update_time as updateTime, p.title as productTitle, p.image as productImage, " +
                "bu.username as buyerName, su.username as sellerName " +
                "from orders o " +
                "left join product p on o.product_id = p.id " +
                "left join `user` bu on o.buyer_id = bu.id " +
                "left join `user` su on o.seller_id = su.id " +
                "where o.seller_id = ?";
        List<Object> params = new ArrayList<>();
        params.add(sellerId);
        if (status >= 0) {
            sql = sql + " AND o.status = ?";
            params.add(status);
        }
        sql = sql + " ORDER BY o.id DESC";
        return qr.query(sql, new BeanListHandler<>(Order.class), params.toArray());
    }

    // 更新订单状态
    public int updateStatus(int orderId, int fromStatus, int toStatus) throws SQLException {
        String sql = "update orders set status = ? where id = ? and status = ?";
        return qr.update(sql, toStatus, orderId, fromStatus);
    }
}
