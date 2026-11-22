package com.echomarket.servlet.account;

import com.echomarket.entity.account.User;
import com.echomarket.dao.account.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    private static final Map<String, Integer> FAIL_COUNT = new HashMap<>();

    private void logFail(String username, String reason) {
        int count = 1;
        if (FAIL_COUNT.containsKey(username)) {
            count = FAIL_COUNT.get(username) + 1;
        }
        FAIL_COUNT.put(username, count);
        System.err.println("[登录失败] 用户名=" + username + " 原因=" + reason + " 该用户累计失败=" + count + " 次");
    }

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
                logFail(username, "用户不存在");
                req.setAttribute("msg", "用户不存在");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }
            if (!user.getPassword().equals(password)) {
                logFail(username, "密码错误");
                req.setAttribute("msg", "密码错误");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }
            req.getSession().setAttribute("user", user);

            resp.sendRedirect(req.getContextPath() + "/products");
        } catch (SQLException e) {
            throw new ServletException("查询用户失败", e);
        }
    }
}
