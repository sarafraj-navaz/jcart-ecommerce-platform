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
 * Shared "forgot password" step 2, for both regular users and product
 * owners. Verifies the OTP that /send-reset-otp emailed/texted out, and if
 * it is correct, saves the new password. role=user or role=owner.
 */
@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String role = req.getParameter("role");
		String contact = req.getParameter("contact");
		String otp = req.getParameter("otp");
		String newPassword = req.getParameter("newPassword");
		String confirmPassword = req.getParameter("confirmPassword");
		boolean isOwner = "owner".equalsIgnoreCase(role);
		String loginPage = isOwner ? "owner-login.jsp" : "user-login.jsp";

		if (newPassword == null || !newPassword.equals(confirmPassword)) {
			req.setAttribute("role", role);
			req.setAttribute("contact", contact);
			req.setAttribute("resetError", "Passwords do not match. Please try again.");
			req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
			return;
		}

		boolean success = isOwner
				? new ProductOwnerService().resetPassword(contact, otp, newPassword)
				: new UserService().resetPassword(contact, otp, newPassword);

		if (!success) {
			req.setAttribute("role", role);
			req.setAttribute("contact", contact);
			req.setAttribute("resetError",
					"That code is incorrect/expired, or the new password doesn't meet the requirements "
							+ "(8-15 characters, with a letter, a number, and a special character).");
			req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
			return;
		}

		req.setAttribute("resetSuccess", "Your password has been reset. Please log in with your new password.");
		req.getRequestDispatcher(loginPage).forward(req, resp);
	}
}
