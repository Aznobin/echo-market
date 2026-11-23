package com.echomarket.servlet.product;

import com.echomarket.entity.product.Product;
import com.echomarket.dao.product.ProductDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/products")
public class ProductListServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Product> productList = productDao.findAllOnSale();
            req.setAttribute("products", productList);
        } catch (SQLException e) {
            log("查询在售商品失败", e);
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            req.setAttribute("msg", "暂时无法加载商品，请稍后刷新再试。");
        }
        req.getRequestDispatcher("/products.jsp").forward(req, resp);
    }
}
