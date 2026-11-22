package com.echomarket.servlet;

import com.echomarket.dao.MessageDao;
import com.echomarket.entity.Message;
import com.echomarket.entity.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/messagesend")
public class MessageSendServlet extends HttpServlet {
    private final MessageDao messageDao = new MessageDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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

        int otherId = parsePositiveInt(req.getParameter("otherId"));
        int productId = parsePositiveInt(req.getParameter("productId"));
        if (otherId <= 0 || productId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/messages");
            return;
        }

        String content = req.getParameter("content");
        if (content == null) {
            content = "";
        }
        content = content.trim();

        if (content.isEmpty() || otherId == user.getId()) {
            resp.sendRedirect(req.getContextPath() + "/messagethread?otherId=" + otherId + "&productId=" + productId);
            return;
        }
        if (content.length() > 500) {
            content = content.substring(0, 500);
        }

        try {
            Message m = new Message();
            m.setFromId(user.getId());
            m.setToId(otherId);
            m.setProductId(productId);
            m.setContent(content);
            messageDao.insert(m);
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/messagethread?otherId=" + otherId + "&productId=" + productId);
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
}
