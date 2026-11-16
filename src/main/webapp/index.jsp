<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    首页只做中转：进站直接跳登录页，登录状态由 LoginFilter 和 session 把关。
--%>
<% response.sendRedirect(request.getContextPath() + "/login.jsp"); %>
