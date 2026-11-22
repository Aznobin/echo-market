package com.echomarket.servlet;

import com.echomarket.dao.FavoriteDao;
import com.echomarket.entity.Favorite;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/favorites")
public class FavoriteListServlet extends HttpServlet {
    private final FavoriteDao favoriteDao = new FavoriteDao();

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

        try {
            List<Favorite> list = favoriteDao.listByUser(user.getId());
            req.setAttribute("favorites", list);
            req.getRequestDispatcher("/favorites.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", "查询收藏失败，请稍后再试");
            req.getRequestDispatcher("/favorites.jsp").forward(req, resp);
        }
    }
}
