package com.echomarket.servlet.favorite;

import com.echomarket.dao.FavoriteDao;

import com.echomarket.entity.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/favoritetoggle")
// 收藏操作
public class FavoriteToggleServlet extends HttpServlet {
    private final FavoriteDao favoriteDao = new FavoriteDao();

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

        int productId = parsePositiveInt(req.getParameter("productId"));
        if (productId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        // 更新收藏状态
        try {
            if (favoriteDao.isFavorited(user.getId(), productId)) {
                favoriteDao.cancel(user.getId(), productId);
            } else {
                favoriteDao.add(user.getId(), productId);
            }
            resp.sendRedirect(req.getContextPath() + "/productdetail?id=" + productId);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/productdetail?id=" + productId);
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
