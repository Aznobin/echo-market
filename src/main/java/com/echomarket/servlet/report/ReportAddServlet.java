package com.echomarket.servlet.report;

import com.echomarket.entity.Report;
import com.echomarket.dao.ReportDao;

import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/reportadd")
// 提交举报
public class ReportAddServlet extends HttpServlet {
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        req.getRequestDispatcher("/reportadd.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = null;
        if (session != null && session.getAttribute("user") != null) {
            user = (User) session.getAttribute("user");
        }
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int targetType = parseIntOr(req.getParameter("targetType"), 2);
        int targetId = parsePositiveInt(req.getParameter("targetId"));
        if (targetId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        // 获取举报内容
        String reason = req.getParameter("reason");
        if (reason == null) {
            reason = "";
        }
        reason = reason.trim();

        if (reason.isEmpty()) {
            req.setAttribute("msg", "举报理由不能空着");
            req.setAttribute("targetType", targetType);
            req.setAttribute("targetId", targetId);
            req.getRequestDispatcher("/reportadd.jsp").forward(req, resp);
            return;
        }
        if (reason.length() > 500) {
            reason = reason.substring(0, 500);
        }

        try {
            // 保存举报
            Report r = new Report();
            r.setReporterId(user.getId());
            r.setTargetType(targetType);
            r.setTargetId(targetId);
            r.setReason(reason);
            reportDao.insert(r);
            resp.sendRedirect(req.getContextPath() + "/reports");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", "提交失败，请稍后再试");
            req.getRequestDispatcher("/reportadd.jsp").forward(req, resp);
        }
    }

    private int parsePositiveInt(String val) {
        if (val == null) {
            return -1;
        }
        try {
            int n = Integer.parseInt(val.trim());
            return n > 0 ? n : -1;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private int parseIntOr(String val, int def) {
        if (val == null) {
            return def;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return def;
        }
    }
}
