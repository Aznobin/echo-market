package com.echomarket.dao;

import com.echomarket.entity.Product;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.sql.SQLException;
import java.util.List;

public class ProductDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());
    public List<Product> findAllOnSale() throws SQLException {
        String sql = "select id, title, description, price, image, " +
                "category_id as categoryId, seller_id as sellerId, " +
                "status, update_time as updateTime " +
                "from product where status = 0 order by update_time desc";
        return qr.query(sql,new BeanListHandler<>(Product.class));
    }

    public int insert(Product product) throws SQLException {
        String sql = "insert into product (title, description, price, image, category_id, seller_id, status) " +
                "values (?, ?, ?, ?, ?, ?, 0)";
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
        String sql = "select id, title, description, price, image, " +
                "category_id as categoryId, seller_id as sellerId, " +
                "status, update_time as updateTime " +
                "from product where id = ?";
        return qr.query(sql, new BeanHandler<>(Product.class), id);
    }

    public List<Product> listBySeller(int sellerId) throws SQLException {
        String sql = "select id, title, description, price, image, category_id as categoryId, " +
                "seller_id as sellerId, status, update_time as updateTime " +
                "from product where seller_id = ? order by id desc";
        return qr.query(sql, new BeanListHandler<>(Product.class), sellerId);
    }
}
