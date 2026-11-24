package com.echomarket.servlet.api;

import com.echomarket.dao.FavoriteDao;
import com.echomarket.dao.MessageDao;
import com.echomarket.dao.OrderDao;
import com.echomarket.dao.RatingDao;
import com.echomarket.dao.ReportDao;
import com.echomarket.dao.UserDao;
import com.echomarket.dao.product.ProductDao;
import com.echomarket.entity.Favorite;
import com.echomarket.entity.Message;
import com.echomarket.entity.Order;
import com.echomarket.entity.Rating;
import com.echomarket.entity.Report;
import com.echomarket.entity.User;
import com.echomarket.entity.product.Category;
import com.echomarket.entity.product.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

// 市集页面使用的数据接口
@WebServlet("/api")
@MultipartConfig(maxFileSize = 3 * 1024 * 1024)
public class MarketApiServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final FavoriteDao favoriteDao = new FavoriteDao();
    private final MessageDao messageDao = new MessageDao();
    private final OrderDao orderDao = new OrderDao();
    private final RatingDao ratingDao = new RatingDao();
    private final ReportDao reportDao = new ReportDao();
    private final UserDao userDao = new UserDao();
    private final com.echomarket.dao.product.CategoryDao categoryDao = new com.echomarket.dao.product.CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handle(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        String action = str(req, "action");
        try {
            Object result = dispatch(req, action);
            out(resp.getWriter(), result);
        } catch (IllegalStateException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out(resp.getWriter(), Map.of("error", e.getMessage()));
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Object dispatch(HttpServletRequest req, String action) throws Exception {
        switch (action) {
            case "me": return me(req);
            case "user": return user(req);
            case "products": return products(req);
            case "product": return product(req);
            case "categories": return categories();
            case "favorites": return favorites(req);
            case "favorite": return toggleFavorite(req);
            case "messages": return conversations(req);
            case "thread": return thread(req);
            case "message": return sendMessage(req);
            case "orders": return orders(req);
            case "order": return order(req);
            case "orderadd": return addOrder(req);
            case "orderstatus": return orderStatus(req);
            case "ratings": return ratings(req);
            case "rating": return addRating(req);
            case "reports": return reports(req);
            case "report": return addReport(req);
            case "reporthandle": return handleReport(req);
            case "publish": return publish(req);
            case "logout": req.getSession().invalidate(); return true;
            default: throw new IllegalStateException("未知接口：" + action);
        }
    }

    private User loginUser(HttpServletRequest req) {
        Object value = req.getSession().getAttribute("user");
        return value instanceof User ? (User) value : null;
    }

    private User requireUser(HttpServletRequest req) {
        User user = loginUser(req);
        if (user == null) throw new IllegalStateException("请先登录");
        return user;
    }

    private Map<String, Object> me(HttpServletRequest req) {
        User user = loginUser(req);
        if (user == null) return null;
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(user.getId()));
        map.put("username", user.getUsername());
        map.put("nickname", user.getNickname());
        map.put("admin", user.getRole() == 1);
        map.put("avatar", user.getAvatar());
        return map;
    }

    private Map<String, Object> user(HttpServletRequest req) throws Exception {
        String id = str(req, "id");
        User user = id.isEmpty() ? null : userDao.findById(Integer.parseInt(id));
        if (user == null) return null;
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(user.getId()));
        map.put("username", user.getUsername());
        map.put("nickname", user.getNickname());
        map.put("admin", user.getRole() == 1);
        map.put("avatar", user.getAvatar());
        return map;
    }

    private List<Map<String, Object>> products(HttpServletRequest req) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        for (Product p : productDao.findAllOnSale()) list.add(productMap(p));
        return list;
    }

    private Map<String, Object> product(HttpServletRequest req) throws Exception {
        Product p = productDao.findById(Integer.parseInt(str(req, "id")));
        return p == null ? null : productMap(p);
    }

    private Map<String, Object> productMap(Product p) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(p.getId()));
        map.put("title", p.getTitle());
        map.put("price", p.getPrice());
        map.put("categoryId", p.getCategoryId());
        map.put("image", p.getImage() == null ? null : "images/" + p.getImage());
        map.put("seller", String.valueOf(p.getSellerId()));
        map.put("description", p.getDescription());
        map.put("sold", p.getStatus() != null && p.getStatus() != 0);
        return map;
    }

    private List<String> categories() throws Exception {
        List<String> names = new ArrayList<>();
        for (Category c : categoryDao.findAll()) names.add(c.getName());
        return names;
    }

    private List<String> favorites(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        List<String> ids = new ArrayList<>();
        for (Favorite f : favoriteDao.listByUser(user.getId())) ids.add(String.valueOf(f.getProductId()));
        return ids;
    }

    private boolean toggleFavorite(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        int productId = Integer.parseInt(str(req, "id"));
        boolean saved = favoriteDao.isFavorited(user.getId(), productId);
        if (saved) favoriteDao.cancel(user.getId(), productId);
        else favoriteDao.add(user.getId(), productId);
        return !saved;
    }

    private List<Map<String, Object>> conversations(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        Map<String, Map<String, Object>> grouped = new LinkedHashMap<>();
        for (Message m : messageDao.listAllRelated(user.getId())) {
            if (m.getProductId() == null) continue;
            boolean mine = m.getFromId() == user.getId();
            String other = String.valueOf(mine ? m.getToId() : m.getFromId());
            String key = other + ":" + m.getProductId();
            if (grouped.containsKey(key)) continue;
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("other", other);
            map.put("productId", String.valueOf(m.getProductId()));
            map.put("unread", false);
            map.put("last", m.getContent());
            map.put("lastTime", time(m.getCreateTime()));
            grouped.put(key, map);
        }
        return new ArrayList<>(grouped.values());
    }

    private Map<String, Object> thread(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        int other = Integer.parseInt(str(req, "other"));
        int productId = Integer.parseInt(str(req, "product"));
        messageDao.markRead(user.getId(), other, productId);
        List<Map<String, Object>> items = new ArrayList<>();
        for (Message m : messageDao.listThread(user.getId(), other, productId)) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("from", String.valueOf(m.getFromId()));
            item.put("text", m.getContent());
            item.put("time", time(m.getCreateTime()));
            items.add(item);
        }
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("other", String.valueOf(other));
        map.put("productId", String.valueOf(productId));
        map.put("items", items);
        return map;
    }

    private boolean sendMessage(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        String content = str(req, "content").trim();
        if (content.isEmpty()) throw new IllegalStateException("消息不能为空");
        Message m = new Message();
        m.setFromId(user.getId());
        m.setToId(Integer.parseInt(str(req, "other")));
        m.setProductId(Integer.parseInt(str(req, "product")));
        m.setContent(content);
        messageDao.insert(m);
        return true;
    }

    private List<Map<String, Object>> orders(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        List<Order> rows = "seller".equals(str(req, "side"))
                ? orderDao.listBySeller(user.getId(), -1)
                : orderDao.listByBuyer(user.getId(), -1);
        List<Map<String, Object>> list = new ArrayList<>();
        for (Order o : rows) list.add(orderMap(o));
        return list;
    }

    private Map<String, Object> order(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        Order o = orderDao.findById(Integer.parseInt(str(req, "id")));
        if (o == null || (o.getBuyerId() != user.getId() && o.getSellerId() != user.getId())) return null;
        return orderMap(o);
    }

    private Map<String, Object> orderMap(Order o) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", String.valueOf(o.getId()));
        map.put("orderNo", o.getOrderNo());
        map.put("productId", String.valueOf(o.getProductId()));
        map.put("buyer", String.valueOf(o.getBuyerId()));
        map.put("seller", String.valueOf(o.getSellerId()));
        map.put("amount", o.getAmount());
        map.put("status", o.getStatus());
        map.put("deliveryType", o.getDeliveryType());
        map.put("payMethod", o.getPayMethod());
        map.put("receiverName", o.getReceiverName());
        map.put("phone", o.getPhone());
        map.put("address", o.getAddress());
        map.put("remark", o.getRemark());
        map.put("productTitle", o.getProductTitle());
        map.put("productImage", o.getProductImage());
        map.put("time", o.getUpdateTime() == null ? "" : o.getUpdateTime().toString());
        return map;
    }

    private Map<String, Object> addOrder(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        Order order = orderDao.createOrder(
                Integer.parseInt(str(req, "product")), user.getId(),
                str(req, "deliveryType"), str(req, "payMethod"),
                str(req, "receiverName"), str(req, "phone"), str(req, "address"), str(req, "remark"));
        orderDao.updateStatus(order.getId(), 0, 1);
        return orderMap(orderDao.findById(order.getId()));
    }

    private Map<String, Object> orderStatus(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        int id = Integer.parseInt(str(req, "id"));
        Order o = orderDao.findById(id);
        if (o == null) throw new IllegalStateException("订单不存在");
        String action = str(req, "status");
        int from = o.getStatus();
        int to = switch (action) {
            case "pay" -> { if (o.getBuyerId() != user.getId() || from != 0) throw new IllegalStateException("不能付款"); yield 1; }
            case "ship" -> { if (o.getSellerId() != user.getId() || from != 1) throw new IllegalStateException("不能发货"); yield 2; }
            case "confirm" -> { if (o.getBuyerId() != user.getId() || from != 2) throw new IllegalStateException("不能确认收货"); yield 3; }
            case "cancel" -> { if (from > 1) throw new IllegalStateException("不能取消"); yield 4; }
            default -> throw new IllegalStateException("未知操作");
        };
        if (orderDao.updateStatus(id, from, to) != 1) throw new IllegalStateException("订单状态已变化");
        if (to == 4) productDao.updateStatus(o.getProductId(), o.getSellerId(), 0);
        return orderMap(orderDao.findById(id));
    }

    private List<Map<String, Object>> ratings(HttpServletRequest req) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        for (Rating r : ratingDao.listByToId(Integer.parseInt(str(req, "user")))) list.add(ratingMap(r));
        return list;
    }

    private Map<String, Object> ratingMap(Rating r) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("orderId", String.valueOf(r.getOrderId()));
        map.put("from", String.valueOf(r.getFromId()));
        map.put("to", String.valueOf(r.getToId()));
        map.put("score", r.getScore());
        map.put("content", r.getContent());
        map.put("time", time(r.getCreateTime()));
        return map;
    }

    private boolean addRating(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        int orderId = Integer.parseInt(str(req, "order"));
        Order o = orderDao.findById(orderId);
        if (o == null || o.getStatus() != 3) throw new IllegalStateException("订单未完成");
        int to = o.getBuyerId() == user.getId() ? o.getSellerId() : o.getBuyerId();
        if (o.getBuyerId() != user.getId() && o.getSellerId() != user.getId()) throw new IllegalStateException("不是你的订单");
        if (ratingDao.findByOrderAndFrom(orderId, user.getId()) != null) throw new IllegalStateException("已经评价过");
        Rating r = new Rating();
        r.setOrderId(orderId);
        r.setFromId(user.getId());
        r.setToId(to);
        r.setScore(Integer.parseInt(str(req, "score")));
        r.setContent(str(req, "content"));
        ratingDao.insert(r);
        return true;
    }

    private List<Map<String, Object>> reports(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        boolean admin = user.getRole() == 1;
        List<Report> rows = admin ? reportDao.listAll() : reportDao.listByReporter(user.getId());
        List<Map<String, Object>> list = new ArrayList<>();
        for (Report r : rows) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", String.valueOf(r.getId()));
            map.put("from", String.valueOf(r.getReporterId()));
            map.put("targetType", r.getTargetType());
            map.put("targetId", String.valueOf(r.getTargetId()));
            map.put("reason", r.getReason());
            map.put("status", r.getHandleStatus());
            map.put("time", time(r.getCreateTime()));
            list.add(map);
        }
        return list;
    }

    private boolean addReport(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        String reason = str(req, "reason").trim();
        if (reason.isEmpty()) throw new IllegalStateException("请填写举报理由");
        Report r = new Report();
        r.setReporterId(user.getId());
        r.setTargetType(Integer.parseInt(str(req, "targetType")));
        r.setTargetId(Integer.parseInt(str(req, "targetId")));
        r.setReason(reason);
        reportDao.insert(r);
        return true;
    }

    private boolean handleReport(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        if (user.getRole() != 1) throw new IllegalStateException("仅管理员可操作");
        reportDao.updateHandleStatus(Integer.parseInt(str(req, "id")), Integer.parseInt(str(req, "status")));
        return true;
    }

    private Map<String, Object> publish(HttpServletRequest req) throws Exception {
        User user = requireUser(req);
        String title = str(req, "title").trim();
        if (title.isEmpty()) throw new IllegalStateException("请填写商品名称");
        Part part = req.getPart("image");
        if (part == null || part.getSize() == 0) throw new IllegalStateException("请上传商品图片");
        String name = user.getId() + "_" + System.currentTimeMillis() + "_" + Paths.get(part.getSubmittedFileName()).getFileName();
        java.io.File dir = new java.io.File(getServletContext().getRealPath("/images/upload"));
        dir.mkdirs();
        part.write(new java.io.File(dir, name).getAbsolutePath());
        Product p = new Product();
        p.setTitle(title);
        p.setDescription(str(req, "description"));
        p.setPrice(new BigDecimal(str(req, "price")));
        p.setCategoryId(Integer.parseInt(str(req, "categoryId")));
        p.setImage("upload/" + name);
        p.setSellerId(user.getId());
        p.setStatus(0);
        productDao.insert(p);
        return productMap(productDao.listBySeller(user.getId()).get(0));
    }

    private String time(Object value) {
        return value == null ? "" : new SimpleDateFormat("MM-dd HH:mm").format(value);
    }

    private String str(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        return value == null ? "" : value;
    }

    private void out(PrintWriter writer, Object value) {
        writer.print(toJson(value));
    }

    private String toJson(Object value) {
        if (value == null) return "null";
        if (value instanceof String s) return '"' + escape(s) + '"';
        if (value instanceof Number || value instanceof Boolean) return String.valueOf(value);
        if (value instanceof Map<?, ?> map) {
            StringBuilder sb = new StringBuilder("{");
            for (Map.Entry<?, ?> e : map.entrySet()) {
                if (sb.length() > 1) sb.append(',');
                sb.append('"').append(escape(String.valueOf(e.getKey()))).append("\":").append(toJson(e.getValue()));
            }
            return sb.append('}').toString();
        }
        if (value instanceof Iterable<?> list) {
            StringBuilder sb = new StringBuilder("[");
            for (Object item : list) {
                if (sb.length() > 1) sb.append(',');
                sb.append(toJson(item));
            }
            return sb.append(']').toString();
        }
        return '"' + escape(String.valueOf(value)) + '"';
    }

    private String escape(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
