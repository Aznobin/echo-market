package com.echomarket.dao.product;

import com.echomarket.entity.product.Category;

import com.echomarket.dao.DBUtilDao;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.sql.SQLException;
import java.util.List;
// 商品分类数据操作类
public class CategoryDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    // 查询全部商品分类
    public List<Category> findAll() throws SQLException {
        String sql = "select id, name, parent_id as parentId, sort, status from category " +
                "where is_deleted = 0 and status = 1 order by sort asc, id asc";
        return qr.query(sql, new BeanListHandler<>(Category.class));
    }

    // 查询商品分类
    public Category findById(int id) throws SQLException {
        String sql = "select id, name, parent_id as parentId, sort, status from category where id = ?";
        return qr.query(sql, new BeanHandler<>(Category.class), id);
    }
}
