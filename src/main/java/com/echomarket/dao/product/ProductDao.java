package com.echomarket.dao.product;

import com.echomarket.entity.product.Product;

import com.echomarket.dao.common.DBUtilDao;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.sql.SQLException;
import java.util.List;

public class ProductDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());
    private static final String PRODUCT_VIEW = "select p.id, p.title, p.description, p.price, p.image, " +
            "p.category_id as categoryId, p.seller_id as sellerId, p.status, p.update_time as updateTime, " +
            "c.name as categoryName, coalesce(nullif(trim(u.nickname), ''), u.username) as sellerName " +
            "from product p left join category c on c.id = p.category_id " +
            "left join `user` u on u.id = p.seller_id ";

    public List<Product> findAllOnSale() throws SQLException {
        String sql = PRODUCT_VIEW + "where p.status = 0 order by p.update_time desc, p.id desc";
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
        String sql = PRODUCT_VIEW + "where p.id = ?";
        return qr.query(sql, new BeanHandler<>(Product.class), id);
    }

    public List<Product> listBySeller(int sellerId) throws SQLException {
        String sql = "select id, title, description, price, image, category_id as categoryId, " +
                "seller_id as sellerId, status, update_time as updateTime " +
                "from product where seller_id = ? order by id desc";
        return qr.query(sql, new BeanListHandler<>(Product.class), sellerId);
    }

    public int updateStatus(int id, int sellerId, int status) throws SQLException {
        String sql = "update product set status = ? where id = ? and seller_id = ?";
        return qr.update(sql, status, id, sellerId);
    }
}
