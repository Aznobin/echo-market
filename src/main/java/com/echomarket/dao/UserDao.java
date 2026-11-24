package com.echomarket.dao;

import com.echomarket.entity.User;

import com.echomarket.dao.DBUtilDao;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;

import java.sql.SQLException;
// 用户数据操作类
public class UserDao {
    private final QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    // 查询登录用户
    public User findByUsername(String username) throws SQLException {
        String sql = "select id, username, password, nickname, phone, avatar, create_time as createTime, status, role "
                   + "from user where username = ?";
        return qr.query(sql, new BeanHandler<>(User.class), username);
    }

    // 保存注册用户
    public int insert(User user) throws SQLException {
        String sql = "insert into user(username, password, nickname, phone, status, role) values(?, ?, ?, ?, 1, 0)";
        return qr.update(sql, user.getUsername(), user.getPassword(), user.getNickname(), user.getPhone());
    }

    // 查询用户资料
    public User findById(int id) throws SQLException {
        String sql = "select id, username, password, nickname, phone, avatar, create_time as createTime, status, role "
                   + "from user where id = ?";
        return qr.query(sql, new BeanHandler<>(User.class), id);
    }

    // 更新用户资料
    public int updateProfile(int id, String nickname, String phone, String avatar) throws SQLException {
        return qr.update("update user set nickname = ?, phone = ?, avatar = ? where id = ?", nickname, phone, avatar, id);
    }

    // 更新用户密码
    public int updatePassword(int id, String password) throws SQLException {
        return qr.update("update user set password = ? where id = ?", password, id);
    }

    // 查询手机号对应用户
    public User findByPhone(String phone) throws SQLException {
        String sql = "select id, username, password, nickname, phone, create_time as createTime, status, role "
                   + "from user where phone = ?";
        return qr.query(sql, new BeanHandler<>(User.class), phone);
    }
}
