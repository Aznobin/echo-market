package com.echomarket.servlet;

import com.echomarket.dao.UserDao;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User user = userDao.findByUsername(username);
            if (user == null) {
                req.setAttribute("msg", "用户不存在");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }
            if (!user.getPassword().equals(password)) {
                req.setAttribute("msg", "密码错误");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }
            req.getSession().setAttribute("user", user);
            resp.sendRedirect("products");
        } catch (SQLException e) {
            throw new ServletException("查询用户失败", e);
        }
    }
}
