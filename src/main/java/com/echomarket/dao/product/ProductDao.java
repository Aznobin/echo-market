package com.echomarket.dao.product;

import com.echomarket.entity.product.Product;

import com.echomarket.dao.DBUtilDao;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.sql.SQLException;
import java.util.List;
// 商品数据操作类
public class ProductDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());
    // 查询在售商品
    public List<Product> findAllOnSale() throws SQLException {
        String sql = "select id, title, description, price, image, " +
                "category_id as categoryId, seller_id as sellerId, " +
                "status, update_time as updateTime " +
                "from product where status = 0 order by update_time desc";
        return qr.query(sql,new BeanListHandler<>(Product.class));
    }

    public List<Product> findFavorites(int userId) throws SQLException {
        String sql = "select p.id, p.title, p.description, p.price, p.image, " +
                "p.category_id as categoryId, p.seller_id as sellerId, " +
                "p.status, p.update_time as updateTime " +
                "from favorite f join product p on f.product_id = p.id " +
                "where f.user_id = ? and f.status = 1 and f.is_deleted = 0 " +
                "order by f.create_time desc, f.id desc";
        return qr.query(sql, new BeanListHandler<>(Product.class), userId);
    }

    // 保存发布的商品
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

    // 查询商品详情
    public Product findById(int id) throws SQLException {
        String sql = "select id, title, description, price, image, " +
                "category_id as categoryId, seller_id as sellerId, " +
                "status, update_time as updateTime " +
                "from product where id = ?";
        return qr.query(sql, new BeanHandler<>(Product.class), id);
    }

    // 查询卖家商品
    public List<Product> listBySeller(int sellerId) throws SQLException {
        String sql = "select id, title, description, price, image, category_id as categoryId, " +
                "seller_id as sellerId, status, update_time as updateTime " +
                "from product where seller_id = ? order by id desc";
        return qr.query(sql, new BeanListHandler<>(Product.class), sellerId);
    }

    // 修改商品资料
    public int update(Product product) throws SQLException {
        String sql = "update product set title = ?, description = ?, price = ?, category_id = ? " +
                "where id = ? and seller_id = ? and status = 0";
        return qr.update(sql, product.getTitle(), product.getDescription(), product.getPrice(),
                product.getCategoryId(), product.getId(), product.getSellerId());
    }

    // 下架商品
    public int remove(int id) throws SQLException {
        return qr.update("update product set status = 2 where id = ? and status = 0", id);
    }

    // 更新商品状态
    public int updateStatus(int id, int sellerId, int status) throws SQLException {
        String sql = "update product set status = ? where id = ? and seller_id = ?";
        return qr.update(sql, status, id, sellerId);
    }
}
