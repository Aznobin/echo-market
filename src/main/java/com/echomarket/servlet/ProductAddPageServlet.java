package com.echomarket.servlet;

import com.echomarket.dao.CategoryDao;
import com.echomarket.entity.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/productaddpage")
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
