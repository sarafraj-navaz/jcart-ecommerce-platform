package com.jsp.jcart.ecommerce.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Fixes "broken access control": previously admin-home.jsp, owner-home.jsp
 * and user-home.jsp (and the verify/unverify actions) could be opened
 * directly by URL with no login at all. This filter blocks that by checking
 * for the session attribute each login controller sets, and redirects back
 * to the matching login page if it's missing.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) response;

		String uri = req.getRequestURI();
		String ctx = req.getContextPath();
		String path = uri.substring(ctx.length());

		HttpSession session = req.getSession(false);

		if (path.equals("/admin-home.jsp")) {
			if (session == null || session.getAttribute("adminEmail") == null) {
				resp.sendRedirect(ctx + "/admin-login.jsp");
				return;
			}
		} else if (path.equals("/owner-home.jsp") || path.equals("/add-product-owner.jsp")) {
			if (session == null || session.getAttribute("ownerEmail") == null) {
				resp.sendRedirect(ctx + "/owner-login.jsp");
				return;
			}
		} else if (path.equals("/user-home.jsp")) {
			if (session == null || session.getAttribute("userEmail") == null) {
				resp.sendRedirect(ctx + "/user-login.jsp");
				return;
			}
		} else if (path.equals("/verify") || path.equals("/unverify") || path.equals("/registrations")) {
			// admin-only actions/pages
			if (session == null || session.getAttribute("adminEmail") == null) {
				resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin login required");
				return;
			}
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
	}
}