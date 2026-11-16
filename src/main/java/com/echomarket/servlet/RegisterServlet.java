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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            if (userDao.findByUsername(username) != null) {
                req.setAttribute("msg", "用户名已存在");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            userDao.insert(user);
            resp.sendRedirect("login.jsp");
        } catch (SQLException e) {
            throw new ServletException("注册失败", e);
        }
    }
}
