package com.echomarket.dao;

import com.echomarket.entity.User;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;

import java.sql.SQLException;

public class UserDao {

    private final QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

//    查询用户名
    public User findByUsername(String username) throws SQLException {
        String sql = "select id, username, password, create_time as createTime, status "
                   + "from user where username = ?";
        return qr.query(sql, new BeanHandler<>(User.class), username);
    }

//    新增用户
    public int insert(User user) throws SQLException {
        String sql = "insert into user(username, password, status) values(?, ?, 1)";
        return qr.update(sql, user.getUsername(), user.getPassword());
    }
}
