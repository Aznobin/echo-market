package com.echomarket.servlet.order;

import com.echomarket.entity.order.Order;
import com.echomarket.dao.order.OrderDao;

import com.echomarket.dao.product.ProductDao;
import com.echomarket.entity.account.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/orderstatus")
public class OrderStatusServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = null;
        if (session != null && session.getAttribute("user") != null) {
            user = (User) session.getAttribute("user");
        }
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = req.getParameter("orderId");
        String action = req.getParameter("action");
        int orderId = parsePositiveInt(idParam);
        if (orderId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/myorders");
            return;
        }

        try {
            Order order = orderDao.findById(orderId);
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/myorders");
                return;
            }

            int status = order.getStatus();
            int newStatus = -1;

            if ("pay".equals(action)) {
                if (order.getBuyerId() != user.getId()) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("只有买家能付款"));
                    return;
                }
                if (status != 0) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("订单状态不对，不能付款"));
                    return;
                }
                newStatus = 1;
            } else if ("ship".equals(action)) {
                if (order.getSellerId() != user.getId()) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("只有卖家能发货"));
                    return;
                }
                if (status != 1) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("买家还没付款，不能发货"));
                    return;
                }
                newStatus = 2;
            } else if ("confirm".equals(action)) {
                if (order.getBuyerId() != user.getId()) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("只有买家能确认收货"));
                    return;
                }
                if (status != 2) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("卖家还没发货，不能确认收货"));
                    return;
                }
                newStatus = 3;
            } else if ("cancel".equals(action)) {
                boolean mine = order.getBuyerId() == user.getId() || order.getSellerId() == user.getId();
                if (!mine) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("这不是你的订单"));
                    return;
                }
                if (status == 2 || status == 3 || status == 4) {
                    resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("这个状态不能取消了"));
                    return;
                }
                newStatus = 4;
            } else {
                resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId);
                return;
            }

            int rows = orderDao.updateStatus(orderId, status, newStatus);
            if (rows != 1) {
                resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("状态已被改过，请刷新再看"));
                return;
            }

            if (newStatus == 4) {
                productDao.updateStatus(order.getProductId(), order.getSellerId(), 0);
            }

            resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId);
        }
    }

    private String enc(String text) {
        try {
            return java.net.URLEncoder.encode(text, "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }

    private int parsePositiveInt(String val) {
        if (val == null) {
            return -1;
        }
        try {
            int n = Integer.parseInt(val.trim());
            return n > 0 ? n : -1;
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}
