package com.echomarket.dao;

import com.echomarket.entity.User;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;

import java.sql.SQLException;

public class UserDao {
    private final QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    public User findByUsername(String username) throws SQLException {
        String sql = "select id, username, password, create_time as createTime, status, role "
                   + "from user where username = ?";
        return qr.query(sql, new BeanHandler<>(User.class), username);
    }

    public int insert(User user) throws SQLException {
        String sql = "insert into user(username, password, nickname, phone, status, role) values(?, ?, ?, ?, 1, 0)";
        return qr.update(sql, user.getUsername(), user.getPassword(), user.getNickname(), user.getPhone());
    }

    public User findById(int id) throws SQLException {
        String sql = "select id, username, password, create_time as createTime, status, role "
                   + "from user where id = ?";
        return qr.query(sql, new BeanHandler<>(User.class), id);
    }

    public User findByPhone(String phone) throws SQLException {
        String sql = "select id, username, password, nickname, phone, create_time as createTime, status, role "
                   + "from user where phone = ?";
        return qr.query(sql, new BeanHandler<>(User.class), phone);
    }
}
