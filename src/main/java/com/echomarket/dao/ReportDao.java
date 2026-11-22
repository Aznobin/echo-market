package com.echomarket.dao;

import com.echomarket.entity.Report;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.sql.SQLException;
import java.util.List;

public class ReportDao {
    private QueryRunner qr = new QueryRunner(DBUtilDao.getDataSource());

    public int insert(Report r) throws SQLException {
        String sql = "insert into report (reporter_id, target_type, target_id, reason, handle_status, status) " +
                "values (?, ?, ?, ?, 0, 1)";
        return qr.update(sql, r.getReporterId(), r.getTargetType(), r.getTargetId(), r.getReason());
    }

    public List<Report> listByReporter(int reporterId) throws SQLException {
        String sql = "select r.id, r.reporter_id as reporterId, r.target_type as targetType, " +
                "r.target_id as targetId, r.reason, r.handle_status as handleStatus, r.status, " +
                "r.create_time as createTime, u.username as reporterName, " +
                "CASE WHEN r.target_type = 2 THEN p.title ELSE tu.username END as targetTitle " +
                "from report r " +
                "left join `user` u on r.reporter_id = u.id " +
                "left join product p on r.target_type = 2 and r.target_id = p.id " +
                "left join `user` tu on r.target_type = 1 and r.target_id = tu.id " +
                "where r.reporter_id = ? and r.is_deleted = 0 order by r.id desc";
        return qr.query(sql, new BeanListHandler<>(Report.class), reporterId);
    }

    public List<Report> listAll() throws SQLException {
        String sql = "select r.id, r.reporter_id as reporterId, r.target_type as targetType, " +
                "r.target_id as targetId, r.reason, r.handle_status as handleStatus, r.status, " +
                "r.create_time as createTime, u.username as reporterName, " +
                "CASE WHEN r.target_type = 2 THEN p.title ELSE tu.username END as targetTitle " +
                "from report r " +
                "left join `user` u on r.reporter_id = u.id " +
                "left join product p on r.target_type = 2 and r.target_id = p.id " +
                "left join `user` tu on r.target_type = 1 and r.target_id = tu.id " +
                "where r.is_deleted = 0 order by r.handle_status asc, r.id desc";
        return qr.query(sql, new BeanListHandler<>(Report.class));
    }

    public int updateHandleStatus(int id, int handleStatus) throws SQLException {
        String sql = "update report set handle_status = ? where id = ?";
        return qr.update(sql, handleStatus, id);
    }
}
