package com.echomarket.servlet.report;

import com.echomarket.dao.ReportDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/adminreports")
// 管理员举报页
public class AdminReportServlet extends HttpServlet {
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("reports", reportDao.listAll());
        } catch (Exception e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/adminreports.jsp").forward(req, resp);
    }
}
