package com.echomarket.servlet.account;

import com.echomarket.dao.UserDao;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;

// 个人资料页
@WebServlet("/profile")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    // 展示资料表单
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("user", req.getSession().getAttribute("user"));
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    // 保存昵称、手机号、密码和头像
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String nickname = req.getParameter("nickname").trim();
        String phone = req.getParameter("phone").trim();
        String password = req.getParameter("password");
        String avatar = user.getAvatar();

        Part part = req.getPart("avatar");
        if (part != null && part.getSize() > 0) {
            String name = user.getId() + "_" + Paths.get(part.getSubmittedFileName()).getFileName();
            File dir = new File(getServletContext().getRealPath("/images/avatars"));
            dir.mkdirs();
            part.write(new File(dir, name).getAbsolutePath());
            avatar = "avatars/" + name;
        }

        try {
            userDao.updateProfile(user.getId(), nickname, phone, avatar);
            if (password != null && !password.isBlank()) {
                userDao.updatePassword(user.getId(), password);
            }
            req.getSession().setAttribute("user", userDao.findById(user.getId()));
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/profile?ok=1");
    }
}
