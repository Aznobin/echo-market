package com.echomarket.servlet.product;

import com.echomarket.entity.product.Category;
import com.echomarket.dao.product.CategoryDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/productaddpage")
// 发布商品页
public class ProductAddPageServlet extends HttpServlet {
    private final CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String msg = req.getParameter("msg");
        if (msg != null && !msg.trim().isEmpty()) {
            req.setAttribute("msg", msg);
        }

        try {
            List<Category> categories = categoryDao.findAll();
            req.setAttribute("categories", categories);
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.getRequestDispatcher("/productadd.jsp").forward(req, resp);
    }
}
