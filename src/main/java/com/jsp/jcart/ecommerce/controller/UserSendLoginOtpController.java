package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.jsp.jcart.ecommerce.dto.User;
import com.jsp.jcart.ecommerce.service.UserService;

/** Step 1 of OTP login: user types their email/phone, we email/SMS them a code. */
@WebServlet("/user-send-login-otp")
public class UserSendLoginOtpController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String contact = req.getParameter("userContact");

		User user = new UserService().sendLoginOtp(contact);

		if (user == null) {
			req.setAttribute("otpError", "No account found with that email/phone.");
			req.getRequestDispatcher("user-login.jsp").forward(req, resp);
			return;
		}

		req.setAttribute("otpContact", contact);
		req.setAttribute("otpSent", "We've sent a 6-digit code to " + contact + ". It is valid for 5 minutes.");
		req.getRequestDispatcher("user-otp-login.jsp").forward(req, resp);
	}
}
