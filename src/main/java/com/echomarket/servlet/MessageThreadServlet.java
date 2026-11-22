package com.echomarket.servlet;

import com.echomarket.dao.MessageDao;
import com.echomarket.dao.ProductDao;
import com.echomarket.dao.UserDao;
import com.echomarket.entity.Message;
import com.echomarket.entity.Product;
import com.echomarket.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/messagethread")
public class MessageThreadServlet extends HttpServlet {
    private final MessageDao messageDao = new MessageDao();
    private final UserDao userDao = new UserDao();
    private final ProductDao productDao = new ProductDao();

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

        int otherId = parsePositiveInt(req.getParameter("otherId"));
        int productId = parsePositiveInt(req.getParameter("productId"));
        if (otherId <= 0 || productId <= 0) {
            req.setAttribute("msg", "会话参数不对，回消息中心重新进一次");
            req.getRequestDispatcher("/messages.jsp").forward(req, resp);
            return;
        }

        try {
            messageDao.markRead(user.getId(), otherId, productId);

            List<Message> messages = messageDao.listThread(user.getId(), otherId, productId);
            User other = userDao.findById(otherId);
            Product product = productDao.findById(productId);

            req.setAttribute("messages", messages);
            req.setAttribute("other", other);
            req.setAttribute("otherId", otherId);
            req.setAttribute("product", product);
            req.setAttribute("productId", productId);
            req.getRequestDispatcher("/messagethread.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", "查询会话失败，请稍后再试");
            req.getRequestDispatcher("/messages.jsp").forward(req, resp);
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
}
