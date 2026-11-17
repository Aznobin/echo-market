package com.echomarket.dao;

import com.echomarket.entity.Product;
import org.apache.commons.dbutils.QueryRunner;
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
}
