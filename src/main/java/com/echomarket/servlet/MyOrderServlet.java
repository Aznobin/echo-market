package com.echomarket.servlet;

import com.echomarket.dao.OrderDao;
import com.echomarket.entity.Order;
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

@WebServlet("/myorders")
public class MyOrderServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();

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

        int status = parseIntOr(req.getParameter("status"), -1);

        try {
            List<Order> orders = orderDao.listByBuyer(user.getId(), status);
            req.setAttribute("orders", orders);
            req.setAttribute("status", status);
            req.getRequestDispatcher("/myorders.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("msg", "查询订单失败，请稍后再试");
            req.getRequestDispatcher("/myorders.jsp").forward(req, resp);
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
