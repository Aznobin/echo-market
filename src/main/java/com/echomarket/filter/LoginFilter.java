package com.echomarket.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/welcome.jsp",
        "/myorders",
        "/soldorders",
        "/orderdetail",
        "/orderstatus",
        "/orderadd",
        "/favorites",
        "/favoritetoggle",
        "/messages",
        "/messagethread",
        "/messagesend",
        "/reports",
        "/reportadd",
        "/ratingadd",
        "/ratings",
        "/adminreports",
        "/adminreporthandle",
        "/product/add"
})
public class LoginFilter implements Filter {
    @Override
    public void doFilter(jakarta.servlet.ServletRequest request,
                         jakarta.servlet.ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        chain.doFilter(request, response);
    }
}
