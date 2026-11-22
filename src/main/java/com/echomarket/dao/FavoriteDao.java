package com.echomarket.dao;

import com.echomarket.entity.Favorite;

import com.echomarket.dao.DBUtilDao;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.List;
// 收藏数据操作类
public class FavoriteDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    // 查询用户收藏
    public Favorite findByUserAndProduct(int userId, int productId) throws SQLException {
        String sql = "select id, user_id as userId, product_id as productId, status, create_time as createTime " +
                "from favorite where user_id = ? and product_id = ?";
        return qr.query(sql, new BeanHandler<>(Favorite.class), userId, productId);
    }

    // 判断是否已收藏
    public boolean isFavorited(int userId, int productId) throws SQLException {
        Favorite f = findByUserAndProduct(userId, productId);
        if (f == null) {
            return false;
        }
        return f.getStatus() == 1;
    }

    // 添加商品收藏
    public int add(int userId, int productId) throws SQLException {
        Favorite old = findByUserAndProduct(userId, productId);
        if (old == null) {
            String sql = "insert into favorite (user_id, product_id, status, is_deleted) values (?, ?, 1, 0)";
            return qr.update(sql, userId, productId);
        }
        String sql = "update favorite set status = 1, is_deleted = 0 where id = ?";
        return qr.update(sql, old.getId());
    }

    // 取消商品收藏
    public int cancel(int userId, int productId) throws SQLException {
        String sql = "update favorite set status = 0 where user_id = ? and product_id = ?";
        return qr.update(sql, userId, productId);
    }

    // 查询我的收藏
    public List<Favorite> listByUser(int userId) throws SQLException {
        String sql = "select f.id, f.user_id as userId, f.product_id as productId, f.status, " +
                "f.create_time as createTime, p.title as productTitle, p.price as productPrice, " +
                "p.image as productImage, p.status as productStatus " +
                "from favorite f join product p on f.product_id = p.id " +
                "where f.user_id = ? and f.status = 1 and f.is_deleted = 0 " +
                "order by f.create_time desc";
        return qr.query(sql, new BeanListHandler<>(Favorite.class), userId);
    }

    // 统计收藏数量
    public int countByUser(int userId) throws SQLException {
        String sql = "select count(*) from favorite where user_id = ? and status = 1 and is_deleted = 0";
        return qr.query(sql, new ScalarHandler<Long>(), userId).intValue();
    }
}
