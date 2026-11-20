package com.echomarket.dao;

import com.echomarket.entity.Product;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.sql.SQLException;
import java.util.List;

public class ProductDao {
    private QueryRunner qr = new QueryRunner(DBUtil.getDataSource());
    public List<Product> findAllOnSale() throws SQLException {
        String sql = "SELECT id, title, description, price, image, " +
                "category_id AS categoryId, seller_id AS sellerId, " +
                "status, update_time AS updateTime " +
                "FROM product WHERE status = 0 ORDER BY update_time DESC";
//        return qr.query(sql,new BeanListHandler<>(Product.class));
        return qr.query(sql,new BeanListHandler<>(Product.class));
    }

    public int insert(Product product) throws SQLException {
        String sql = "INSERT INTO product (title, description, price, image, category_id, seller_id, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, 0)";
        return qr.update(
                sql,
                product.getTitle(),
                product.getDescription(),
                product.getPrice(),
                product.getImage(),
                product.getCategoryId(),
                product.getSellerId()
        );
    }


    public Product findById(int id) throws SQLException {
        String sql = "SELECT id, title, description, price, image, " +
                "category_id AS categoryId, seller_id AS sellerId, " +
                "status, update_time AS updateTime " +
                "FROM product WHERE id = ?";
        return qr.query(sql, new BeanHandler<>(Product.class), id);
    }
}
