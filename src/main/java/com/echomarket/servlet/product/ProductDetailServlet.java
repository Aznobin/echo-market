package com.echomarket.servlet.product;

import com.echomarket.entity.product.Product;
import com.echomarket.dao.product.ProductDao;

import com.echomarket.dao.favorite.FavoriteDao;
import com.echomarket.dao.rating.RatingDao;
import com.echomarket.dao.account.UserDao;
import com.echomarket.entity.account.User;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/productdetail")
public class ProductDetailServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final RatingDao ratingDao = new RatingDao();
    private final FavoriteDao favoriteDao = new FavoriteDao();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()){
            req.setAttribute("msg","缺少商品编号参数");
            req.getRequestDispatcher("/productdetail.jsp").forward(req,resp);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam.trim());
            if (id <= 0){
                req.setAttribute("mag", "商品编号无效");
                req.getRequestDispatcher("/productdetail.jsp").forward(req,resp);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("msg", "商品编号必须为有效数字");
            req.getRequestDispatcher("/productdetail.jsp").forward(req,resp);
            return;
        }

        try {
            Product product = productDao.findById(id);
            if (product == null){
                 req.setAttribute("msg","该商品不存在或已被删除");
                 req.getRequestDispatcher("/productdetail.jsp").forward(req,resp);
                return;
            }
            req.setAttribute("product",product);

            try {
                User seller = userDao.findById(product.getSellerId());
                req.setAttribute("seller", seller);
                req.setAttribute("sellerScore", ratingDao.avgScore(product.getSellerId()));
                req.setAttribute("sellerRateCount", ratingDao.countByTo(product.getSellerId()));
            } catch (Exception e) {
                e.printStackTrace();
            }

            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User loginUser = (User) session.getAttribute("user");
                try {
                    req.setAttribute("favorited", favoriteDao.isFavorited(loginUser.getId(), id));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            req.getRequestDispatcher("/productdetail.jsp").forward(req,resp);
        } catch (SQLException e) {
            throw new ServletException("查询商品详情失败，id=" + id, e);
        }
    }
}
