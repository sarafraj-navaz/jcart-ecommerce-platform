package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.jsp.jcart.ecommerce.dto.ProductOwner;
import com.jsp.jcart.ecommerce.service.ProductOwnerService;

/** Step 1 of OTP login: owner types their email/phone, we email/SMS them a code. */
@WebServlet("/owner-send-login-otp")
public class OwnerSendLoginOtpController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String contact = req.getParameter("ownerContact");

		ProductOwner owner = new ProductOwnerService().sendLoginOtp(contact);

		if (owner == null) {
			req.setAttribute("otpError", "No product owner account found with that email/phone.");
			req.getRequestDispatcher("owner-login.jsp").forward(req, resp);
			return;
		}

		req.setAttribute("otpContact", contact);
		req.setAttribute("otpSent", "We've sent a 6-digit code to " + contact + ". It is valid for 5 minutes.");
		req.getRequestDispatcher("owner-otp-login.jsp").forward(req, resp);
	}
}
