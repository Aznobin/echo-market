package com.echomarket.servlet.product;

import com.echomarket.dao.product.ProductDao;
import com.echomarket.entity.User;
import com.echomarket.entity.product.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

// 商品编辑与下架
@WebServlet("/product/manage")
public class ProductManageServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();

    // 展示编辑页
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Product product = ownProduct(req);
        req.setAttribute("product", product);
        req.getRequestDispatcher("/productedit.jsp").forward(req, resp);
    }

    // 保存修改或下架
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Product product = ownProduct(req);
        try {
            if ("remove".equals(req.getParameter("action"))) {
                productDao.remove(product.getId());
                resp.sendRedirect(req.getContextPath() + "/products");
                return;
            }
            product.setTitle(req.getParameter("title").trim());
            product.setDescription(req.getParameter("description"));
            product.setPrice(new BigDecimal(req.getParameter("price")));
            product.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            productDao.update(product);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/productdetail?id=" + product.getId());
    }

    // 只允许卖家操作自己的在售商品
    private Product ownProduct(HttpServletRequest req) throws ServletException {
        User user = (User) req.getSession().getAttribute("user");
        try {
            Product product = productDao.findById(Integer.parseInt(req.getParameter("id")));
            if (product == null || product.getSellerId() != user.getId()) {
                throw new ServletException("商品不存在或不属于当前用户");
            }
            return product;
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException(e);
        }
    }
}
