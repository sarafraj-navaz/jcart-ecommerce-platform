package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.jsp.jcart.ecommerce.dto.Admin;
import com.jsp.jcart.ecommerce.service.AdminService;

@SuppressWarnings(value = "serial")
@WebServlet(value = "/adminLogin")
public class AdminLoginController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String adminEmail1 = req.getParameter("adminEmail");
		String adminPassword1 = req.getParameter("adminPassword");

		AdminService adminService = new AdminService();

		Admin admin = adminService.adminLoginWithEmailPassService(adminEmail1);

		if (admin != null && admin.getAdminPassword().equals(adminPassword1)) {

			HttpSession session = req.getSession(true);
			session.invalidate();
			session = req.getSession(true);
			session.setAttribute("adminEmail", admin.getAdminEmail());

			req.getRequestDispatcher("admin-home.jsp").forward(req, resp);

		} else if (admin != null) {
			req.setAttribute("incorrectadminPassword", "please enter the valid password");
			req.getRequestDispatcher("admin-login.jsp").forward(req, resp);
		} else {
			req.setAttribute("incorrectadminEmail", "please the valid email");
			req.getRequestDispatcher("admin-login.jsp").forward(req, resp);
		}
	}
}