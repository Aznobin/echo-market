package com.echomarket.servlet.order;
import com.echomarket.dao.product.ProductDao;
import com.echomarket.entity.product.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/productbuy")
public class OrderBuyerInfoServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("productId");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam.trim());
                Product product = productDao.findById(id);
                req.setAttribute("product", product);
            } catch (NumberFormatException e) {
                req.setAttribute("msg", "商品参数不合法");
            } catch (Exception e) {
                req.setAttribute("msg", "查询商品信息失败");
            }
        } 
        req.getRequestDispatcher("/orderbuyerinfo.jsp").forward(req, resp);
    }
}
