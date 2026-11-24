package com.echomarket.servlet.account;

import com.echomarket.entity.User;
import com.echomarket.dao.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
// 注册页
public class RegisterServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String username = req.getParameter("username");
        String nickname = req.getParameter("nickname");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String agree = req.getParameter("agree");

        // 注册数据规则
        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("msg", "用户名不能为空");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (nickname == null || nickname.trim().isEmpty()) {
            req.setAttribute("msg", "昵称不能为空");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (phone == null || !phone.trim().matches("^1[3-9]\\d{9}$")) {
            req.setAttribute("msg", "请填写正确的 11 位手机号");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("msg", "密码不能为空");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("msg", "密码至少要 6 位");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (confirmPassword == null || !password.equals(confirmPassword)) {
            req.setAttribute("msg", "两次输入的密码不一致");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (agree == null) {
            req.setAttribute("msg", "请先勾选同意《用户协议》");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        username = username.trim();
        nickname = nickname.trim();
        phone = phone.trim();
        if (username.length() < 3) {
            req.setAttribute("msg", "用户名至少要 3 个字符");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (username.length() > 32) {
            req.setAttribute("msg", "用户名太长了，最多 32 个字符");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (nickname.length() > 32) {
            req.setAttribute("msg", "昵称太长了，最多 32 个字符");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }
        if (password.length() > 64) {
            req.setAttribute("msg", "密码太长了，最多 64 个字符");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        // 判断去重
        try {
            if (userDao.findByUsername(username) != null) {
                req.setAttribute("msg", "用户名已存在");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }
            if (userDao.findByPhone(phone) != null) {
                req.setAttribute("msg", "这个手机号已经注册过了");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }
            // 保存新用户
            User user = new User();
            user.setUsername(username);
            user.setNickname(nickname);
            user.setPhone(phone);
            user.setPassword(password);
            userDao.insert(user);
            resp.sendRedirect(req.getContextPath() + "/");
        } catch (SQLException e) {
            throw new ServletException("注册失败", e);
        }
    }
}
