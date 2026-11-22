package com.echomarket.servlet;

import com.echomarket.dao.ReportDao;
import com.echomarket.entity.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/adminreporthandle")
public class AdminReportHandleServlet extends HttpServlet {
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = null;
        if (session != null && session.getAttribute("user") != null) {
            user = (User) session.getAttribute("user");
        }
        if (user == null || user.getRole() != 1) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int id = parseIntOr(req.getParameter("id"), -1);
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/adminreports");
            return;
        }
        int handleStatus = parseIntOr(req.getParameter("handleStatus"), 1);
        if (handleStatus != 0 && handleStatus != 1 && handleStatus != 2) {
            handleStatus = 0;
        }

        try {
            reportDao.updateHandleStatus(id, handleStatus);
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/adminreports");
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
