package com.echomarket.servlet.rating;

import com.echomarket.entity.rating.Rating;
import com.echomarket.dao.rating.RatingDao;

import com.echomarket.dao.order.OrderDao;
import com.echomarket.entity.order.Order;
import com.echomarket.entity.account.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/ratingadd")
public class RatingAddServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();
    private final RatingDao ratingDao = new RatingDao();

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

        int orderId = parsePositiveInt(req.getParameter("orderId"));
        if (orderId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/myorders");
            return;
        }
        int score = parseIntOr(req.getParameter("score"), 5);
        if (score < 1) {
            score = 1;
        }
        if (score > 5) {
            score = 5;
        }

        String content = req.getParameter("content");
        if (content == null) {
            content = "";
        }
        content = content.trim();
        if (content.isEmpty()) {
            content = "该用户没有填写评价内容";
        }
        if (content.length() > 255) {
            content = content.substring(0, 255);
        }

        try {
            Order order = orderDao.findById(orderId);
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/myorders");
                return;
            }
            if (order.getStatus() != 3) {
                resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("订单还没完成，不能评价"));
                return;
            }

            int toId = 0;
            if (order.getBuyerId() == user.getId()) {
                toId = order.getSellerId();
            } else if (order.getSellerId() == user.getId()) {
                toId = order.getBuyerId();
            } else {
                resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("这不是你的订单"));
                return;
            }

            if (ratingDao.findByOrderAndFrom(orderId, user.getId()) != null) {
                resp.sendRedirect(req.getContextPath() + "/orderdetail?id=" + orderId + "&msg=" + enc("你已经评价过这笔订单了"));
                return;
            }

            Rating r = new Rating();
            r.setOrderId(orderId);
            r.setFromId(user.getId());
            r.setToId(toId);
            r.setScore(score);
            r.setContent(content);
            ratingDao.insert(r);

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

    private int parseIntOr(String val, int def) {
        if (val == null) {
            return def;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }
}
