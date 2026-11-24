package com.echomarket.servlet.report;

import com.echomarket.dao.ReportDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/adminreporthandle")
// 管理员处理举报
public class AdminReportHandleServlet extends HttpServlet {
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        int status = Integer.parseInt(req.getParameter("handleStatus"));
        String remark = req.getParameter("remark");
        try {
            reportDao.updateHandleStatus(id, status, remark == null ? "" : remark.trim());
        } catch (Exception e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/adminreports");
    }
}
