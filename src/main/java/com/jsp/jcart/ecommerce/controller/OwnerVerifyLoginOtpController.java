package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.jsp.jcart.ecommerce.dto.ProductOwner;
import com.jsp.jcart.ecommerce.service.ProductOwnerService;

/** Step 2 of OTP login: owner types the code they received, no password required. */
@WebServlet("/owner-verify-login-otp")
public class OwnerVerifyLoginOtpController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String contact = req.getParameter("ownerContact");
		String otp = req.getParameter("otp");

		ProductOwner owner = new ProductOwnerService().verifyLoginOtp(contact, otp);

		if (owner == null) {
			req.setAttribute("otpContact", contact);
			req.setAttribute("otpError", "That code is incorrect or has expired. Please try again.");
			req.getRequestDispatcher("owner-otp-login.jsp").forward(req, resp);
			return;
		}

		if (!"yes".equals(owner.getVerify())) {
			req.setAttribute("unverified",
					"Your account is pending admin verification. Please wait until it is approved before logging in.");
			req.getRequestDispatcher("owner-login.jsp").forward(req, resp);
			return;
		}

		HttpSession session = req.getSession(true);
		session.invalidate();
		session = req.getSession(true);
		session.setAttribute("ownerEmail", owner.getEmail());
		session.setAttribute("ownerId", owner.getId());
		session.setAttribute("ownerName", owner.getName());

		req.getRequestDispatcher("owner-home.jsp").forward(req, resp);
	}
}
