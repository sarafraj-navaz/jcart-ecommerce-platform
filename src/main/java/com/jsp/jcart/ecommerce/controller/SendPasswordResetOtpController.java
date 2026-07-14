package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.jsp.jcart.ecommerce.service.ProductOwnerService;
import com.jsp.jcart.ecommerce.service.UserService;

/**
 * Shared "forgot password" step 1, for both regular users and product
 * owners. role=user or role=owner. contact = email or phone number.
 */
@WebServlet("/send-reset-otp")
public class SendPasswordResetOtpController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String role = req.getParameter("role");
		String contact = req.getParameter("contact");
		boolean isOwner = "owner".equalsIgnoreCase(role);

		boolean found;
		if (isOwner) {
			found = new ProductOwnerService().sendPasswordResetOtp(contact) != null;
		} else {
			found = new UserService().sendPasswordResetOtp(contact) != null;
		}

		String loginPage = isOwner ? "owner-login.jsp" : "user-login.jsp";

		if (!found) {
			req.setAttribute("otpError", "No " + (isOwner ? "product owner" : "user") + " account found with that email/phone.");
			req.getRequestDispatcher(loginPage).forward(req, resp);
			return;
		}

		req.setAttribute("role", role);
		req.setAttribute("contact", contact);
		req.setAttribute("otpSent", "We've sent a 6-digit reset code to " + contact + ". It is valid for 5 minutes.");
		req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
	}
}
