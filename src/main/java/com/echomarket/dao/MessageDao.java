package com.echomarket.dao;

import com.echomarket.entity.Message;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.SQLException;
import java.util.List;

public class MessageDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    public int insert(Message m) throws SQLException {
        String sql = "insert into message (from_id, to_id, product_id, content, is_read, status) " +
                "values (?, ?, ?, ?, 0, 1)";
        return qr.update(sql, m.getFromId(), m.getToId(), m.getProductId(), m.getContent());
    }

    public List<Message> listThread(int userId, int otherId, int productId) throws SQLException {
        String sql = "select id, from_id as fromId, to_id as toId, product_id as productId, content, " +
                "is_read as isRead, status, create_time as createTime from message " +
                "where product_id = ? and is_deleted = 0 " +
                "and ((from_id = ? and to_id = ?) or (from_id = ? and to_id = ?)) " +
                "order by id asc";
        return qr.query(sql, new BeanListHandler<>(Message.class), productId, userId, otherId, otherId, userId);
    }

    public List<Message> listAllRelated(int userId) throws SQLException {
        String sql = "select m.id, m.from_id as fromId, m.to_id as toId, m.product_id as productId, " +
                "m.content, m.is_read as isRead, m.status, m.create_time as createTime, " +
                "fu.username as fromName, tu.username as toName, p.title as productTitle " +
                "from message m " +
                "left join `user` fu on m.from_id = fu.id " +
                "left join `user` tu on m.to_id = tu.id " +
                "left join product p on m.product_id = p.id " +
                "where m.is_deleted = 0 and (m.from_id = ? or m.to_id = ?) " +
                "order by m.id desc";
        return qr.query(sql, new BeanListHandler<>(Message.class), userId, userId);
    }

    public int markRead(int userId, int otherId, int productId) throws SQLException {
        String sql = "update message set is_read = 1 " +
                "where to_id = ? and from_id = ? and product_id = ? and is_read = 0";
        return qr.update(sql, userId, otherId, productId);
    }

    public int countUnread(int userId) throws SQLException {
        String sql = "select count(*) from message where to_id = ? and is_read = 0 and is_deleted = 0";
        Long n = qr.query(sql, new ScalarHandler<Long>(), userId);
        if (n == null) {
            return 0;
        }
        return n.intValue();
    }
}
