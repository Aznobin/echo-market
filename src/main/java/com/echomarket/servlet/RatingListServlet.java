package com.echomarket.servlet;

import com.echomarket.dao.RatingDao;
import com.echomarket.dao.UserDao;
import com.echomarket.entity.Rating;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/ratings")
public class RatingListServlet extends HttpServlet {
    private final RatingDao ratingDao = new RatingDao();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = null;
        if (session != null && session.getAttribute("user") != null) {
            user = (User) session.getAttribute("user");
        }
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int userId = parsePositiveInt(req.getParameter("userId"));
        if (userId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        try {
            User target = userDao.findById(userId);
            if (target == null) {
                req.setAttribute("msg", "用户不存在");
                req.getRequestDispatcher("/products.jsp").forward(req, resp);
                return;
            }

            List<Rating> ratings = ratingDao.listByToId(userId);
            BigDecimal avgScore = ratingDao.avgScore(userId);
            int rateCount = ratingDao.countByTo(userId);

            req.setAttribute("target", target);
            req.setAttribute("ratings", ratings);
            req.setAttribute("avgScore", avgScore);
            req.setAttribute("rateCount", rateCount);
            req.getRequestDispatcher("/ratings.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
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
