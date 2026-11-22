package com.echomarket.dao.rating;

import com.echomarket.entity.rating.Rating;

import com.echomarket.dao.common.DBUtilDao;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class RatingDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    public int insert(Rating r) throws SQLException {
        String sql = "insert into rating (order_id, from_id, to_id, score, content, status) " +
                "values (?, ?, ?, ?, ?, 1)";
        return qr.update(sql, r.getOrderId(), r.getFromId(), r.getToId(), r.getScore(), r.getContent());
    }

    public Rating findByOrderAndFrom(int orderId, int fromId) throws SQLException {
        String sql = "select id, order_id as orderId, from_id as fromId, to_id as toId, score, content, " +
                "status, create_time as createTime from rating " +
                "where order_id = ? and from_id = ? and is_deleted = 0";
        return qr.query(sql, new BeanHandler<>(Rating.class), orderId, fromId);
    }

    public List<Rating> listByOrder(int orderId) throws SQLException {
        String sql = "select r.id, r.order_id as orderId, r.from_id as fromId, r.to_id as toId, r.score, " +
                "r.content, r.status, r.create_time as createTime, " +
                "fu.username as fromName, tu.username as toName " +
                "from rating r " +
                "left join `user` fu on r.from_id = fu.id " +
                "left join `user` tu on r.to_id = tu.id " +
                "where r.order_id = ? and r.is_deleted = 0 order by r.id asc";
        return qr.query(sql, new BeanListHandler<>(Rating.class), orderId);
    }

    public List<Rating> listByToId(int toId) throws SQLException {
        String sql = "select r.id, r.order_id as orderId, r.from_id as fromId, r.to_id as toId, r.score, r.content, " +
                "r.status, r.create_time as createTime, u.username as fromName " +
                "from rating r left join user u on r.from_id = u.id " +
                "where r.to_id = ? and r.status = 1 and r.is_deleted = 0 order by r.id desc";
        return qr.query(sql, new BeanListHandler<>(Rating.class), toId);
    }

    public BigDecimal avgScore(int toId) throws SQLException {
        String sql = "select avg(score) from rating where to_id = ? and status = 1 and is_deleted = 0";
        BigDecimal avg = qr.query(sql, new ScalarHandler<BigDecimal>(), toId);
        if (avg == null) {
            return new BigDecimal("0");
        }
        return avg;
    }

    public int countByTo(int toId) throws SQLException {
        String sql = "select count(*) from rating where to_id = ? and status = 1 and is_deleted = 0";
        Long n = qr.query(sql, new ScalarHandler<Long>(), toId);
        if (n == null) {
            return 0;
        }
        return n.intValue();
    }
}
