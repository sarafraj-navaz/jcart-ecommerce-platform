package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.jsp.jcart.ecommerce.dto.User;
import com.jsp.jcart.ecommerce.service.UserService;

/** Step 2 of OTP login: user types the code they received, no password required. */
@WebServlet("/user-verify-login-otp")
public class UserVerifyLoginOtpController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String contact = req.getParameter("userContact");
		String otp = req.getParameter("otp");

		User user = new UserService().verifyLoginOtp(contact, otp);

		if (user == null) {
			req.setAttribute("otpContact", contact);
			req.setAttribute("otpError", "That code is incorrect or has expired. Please try again.");
			req.getRequestDispatcher("user-otp-login.jsp").forward(req, resp);
			return;
		}

		HttpSession session = req.getSession(true);
		session.invalidate();
		session = req.getSession(true);
		session.setAttribute("userEmail", user.getUserEmail());
		session.setAttribute("userId", user.getUserId());
		session.setAttribute("userName", user.getUserName());

		req.getRequestDispatcher("user-home.jsp").forward(req, resp);
	}
}
