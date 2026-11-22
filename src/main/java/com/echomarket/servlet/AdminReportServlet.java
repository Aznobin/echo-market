package com.echomarket.servlet;

import com.echomarket.dao.ReportDao;
import com.echomarket.entity.Report;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/adminreports")
public class AdminReportServlet extends HttpServlet {
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        if (user.getRole() != 1) {
            req.setAttribute("msg", "只有管理员能进这个页面");
            req.getRequestDispatcher("/products").forward(req, resp);
            return;
        }

        try {
            List<Report> list = reportDao.listAll();
            req.setAttribute("reports", list);
            req.getRequestDispatcher("/adminreports.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", "查询举报失败，请稍后再试");
            req.getRequestDispatcher("/adminreports.jsp").forward(req, resp);
        }
    }
}
