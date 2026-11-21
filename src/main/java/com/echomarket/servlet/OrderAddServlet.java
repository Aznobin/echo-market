package com.echomarket.servlet;

import com.echomarket.dao.OrderDao;
import com.echomarket.dao.ProductDao;
import com.echomarket.entity.Order;
import com.echomarket.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.lang.reflect.Method;

@WebServlet("/orderadd")
public class OrderAddServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Integer buyerId = resolveLoginUserId(req);
        int productId = parsePositiveInt(req.getParameter("productId"));
        String deliveryType = trimOrNull(req.getParameter("deliveryType"));
        String payMethod = trimOrNull(req.getParameter("payMethod"));
        String receiverName = trimOrNull(req.getParameter("receiverName"));
        String phone = trimOrNull(req.getParameter("phone"));
        String address = trimOrNull(req.getParameter("address"));
        String remark = trimOrNull(req.getParameter("remark"));

        if (productId > 0) {
            try {
                Product product = productDao.findById(productId);
                req.setAttribute("product", product);
            } catch (Exception ignored) {
            }
        }

        if (buyerId == null) {
            req.setAttribute("msg", "请先登录后再提交订单");
            req.getRequestDispatcher("/orderbuyerinfo.jsp").forward(req, resp);
            return;
        }

        if (productId <= 0) {
            req.setAttribute("msg", "商品参数无效");
            req.getRequestDispatcher("/orderbuyerinfo.jsp").forward(req, resp);
            return;
        }

        if (receiverName == null || phone == null || address == null) {
            req.setAttribute("msg", "请完整填写联系人称呼、联系电话和校内交接/收货地址");
            req.getRequestDispatcher("/orderbuyerinfo.jsp").forward(req, resp);
            return;
        }

        if (!"meetup".equals(deliveryType) && !"dorm".equals(deliveryType)) {
            deliveryType = "meetup";
        }
        if (!"online".equals(payMethod) && !"cod".equals(payMethod)) {
            payMethod = "online";
        }

        try {
            Order created = orderDao.createOrder(
                    productId, buyerId, deliveryType, payMethod,
                    receiverName, phone, address, remark
            );
            HttpSession session = req.getSession();
            session.setAttribute("lastOrder", created);
            resp.sendRedirect(req.getContextPath() + "/ordersuccess.jsp");
        } catch (IllegalStateException e) {
            req.setAttribute("msg", e.getMessage());
            req.getRequestDispatcher("/orderbuyerinfo.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", "下单失败，请稍后重试");
            req.getRequestDispatcher("/orderbuyerinfo.jsp").forward(req, resp);
        }
    }

    private Integer resolveLoginUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            userObj = session.getAttribute("loginUser");
        }
        if (userObj == null) {
            return null;
        }
        if (userObj instanceof Integer) {
            return (Integer) userObj;
        }
        try {
            Method getId = userObj.getClass().getMethod("getId");
            Object idVal = getId.invoke(userObj);
            if (idVal instanceof Integer) {
                return (Integer) idVal;
            }
            if (idVal != null) {
                return Integer.parseInt(idVal.toString());
            }
        } catch (Exception ignored) {
        }
        return null;
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

    private String trimOrNull(String val) {
        if (val == null) {
            return null;
        }
        String t = val.trim();
        return t.isEmpty() ? null : t;
    }
}