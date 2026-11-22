package com.echomarket.servlet;

import com.echomarket.dao.OrderDao;
import com.echomarket.dao.RatingDao;
import com.echomarket.entity.Order;
import com.echomarket.entity.Rating;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/orderdetail")
public class OrderDetailServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();
    private final RatingDao ratingDao = new RatingDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        String msgParam = req.getParameter("msg");
        if (msgParam != null && !msgParam.trim().isEmpty()) {
            req.setAttribute("msg", msgParam);
        }

        String idParam = req.getParameter("id");
        int id = parsePositiveInt(idParam);
        if (id <= 0) {
            req.setAttribute("msg", "订单编号不正确");
            req.getRequestDispatcher("/orderdetail.jsp").forward(req, resp);
            return;
        }

        try {
            Order order = orderDao.findById(id);
            if (order == null) {
                req.setAttribute("msg", "订单不存在");
                req.getRequestDispatcher("/orderdetail.jsp").forward(req, resp);
                return;
            }

            boolean isBuyer = order.getBuyerId() == user.getId();
            boolean isSeller = order.getSellerId() == user.getId();
            boolean isAdmin = user.getRole() == 1;
            if (!isBuyer && !isSeller && !isAdmin) {
                req.setAttribute("msg", "这不是你的订单，不能查看");
                req.getRequestDispatcher("/orderdetail.jsp").forward(req, resp);
                return;
            }

            List<Rating> ratings = ratingDao.listByOrder(id);
            Rating myRating = ratingDao.findByOrderAndFrom(id, user.getId());

            req.setAttribute("order", order);
            req.setAttribute("ratings", ratings);
            req.setAttribute("myRating", myRating);
            req.setAttribute("isBuyer", isBuyer);
            req.setAttribute("isSeller", isSeller);
            req.getRequestDispatcher("/orderdetail.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("msg", "查询订单失败，请稍后再试");
            req.getRequestDispatcher("/orderdetail.jsp").forward(req, resp);
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
