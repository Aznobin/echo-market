package com.echomarket.servlet.message;

import com.echomarket.entity.message.Message;
import com.echomarket.dao.message.MessageDao;

import com.echomarket.entity.account.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/messages")
public class MessageListServlet extends HttpServlet {
    private final MessageDao messageDao = new MessageDao();

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

        try {
            List<Message> all = messageDao.listAllRelated(user.getId());

            List<Message> conversations = new ArrayList<>();
            List<String> keys = new ArrayList<>();
            for (int i = 0; i < all.size(); i++) {
                Message m = all.get(i);
                int otherId;
                if (m.getFromId() == user.getId()) {
                    otherId = m.getToId();
                } else {
                    otherId = m.getFromId();
                }
                int pid = 0;
                if (m.getProductId() != null) {
                    pid = m.getProductId();
                }
                String key = otherId + "_" + pid;
                if (!keys.contains(key)) {
                    keys.add(key);
                    m.setOtherId(otherId);
                    if (m.getFromId() == user.getId()) {
                        m.setOtherName(m.getToName());
                    } else {
                        m.setOtherName(m.getFromName());
                    }
                    conversations.add(m);
                }
            }

            req.setAttribute("conversations", conversations);
            req.setAttribute("unreadCount", messageDao.countUnread(user.getId()));
            req.getRequestDispatcher("/messages.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", "查询消息失败，请稍后再试");
            req.getRequestDispatcher("/messages.jsp").forward(req, resp);
        }
    }
}
