package com.echomarket.servlet;

import com.echomarket.dao.ProductDao;
import com.echomarket.entity.Product;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.SQLException;

@WebServlet("/product/add")
@MultipartConfig
public class ProductAddServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String title = req.getParameter("title");
        String priceStr = req.getParameter("price");
        String description = req.getParameter("description");
        String categoryIdStr = req.getParameter("categoryId");

        Product product = new Product();
        product.setTitle(title);
        product.setDescription(description);
        product.setPrice(priceStr != null && !priceStr.isEmpty()
                ? new BigDecimal(priceStr)
                : BigDecimal.ZERO);
        product.setCategoryId((categoryIdStr != null && !categoryIdStr.isEmpty())
                ? Integer.parseInt(categoryIdStr)
                : 1);
        product.setStatus(0);

        HttpSession session = req.getSession(false);
        Object loginUser = (session != null) ? session.getAttribute("user") : null;
        if (loginUser instanceof User) {
            User user = (User) loginUser;
            product.setSellerId(user.getId());
        } else {
            resp.setContentType("text/html;charset=UTF-8");
            java.io.PrintWriter out = resp.getWriter();
            out.println("<script>");
            out.println("alert('请先登录后再发布闲置商品！');");
            out.println("location.href='" + req.getContextPath() + "/login.jsp';");
            out.println("</script>");
            return;
        }

        Part filePart = req.getPart("imageFile");
        if (filePart == null || filePart.getSize() == 0) {
            resp.sendRedirect(req.getContextPath() + "/productadd.jsp");
            return;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        String fileName = Paths.get(submittedFileName).getFileName().toString();

        String uploadDir = getServletContext().getRealPath("/images");
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        filePart.write(new File(dir, fileName).getAbsolutePath());
        product.setImage(fileName);

        try {
            productDao.insert(product);
        } catch (SQLException e) {
            System.err.println("插入商品失败：" + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/products");
    }
}