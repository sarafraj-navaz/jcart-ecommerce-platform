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
import com.jsp.jcart.ecommerce.util.PasswordUtil;

@WebServlet(value = "/loginUser")
public class UserLoginController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String userEmail = req.getParameter("userName");
		String userPassword = req.getParameter("userPassword");

		UserService userService = new UserService();

		User user = userService.loginWithUserService(userEmail);

		if (user != null && PasswordUtil.verify(userPassword, user.getUserPassword())) {

			HttpSession session = req.getSession(true);
			session.invalidate();
			session = req.getSession(true);
			session.setAttribute("userEmail", user.getUserEmail());
			session.setAttribute("userId", user.getUserId());
			session.setAttribute("userName", user.getUserName());

			req.getRequestDispatcher("user-home.jsp").forward(req, resp);

		} else if (user != null) {
			req.setAttribute("incorrectPassword", "password is mismatch");
			req.getRequestDispatcher("user-login.jsp").forward(req, resp);
		} else {
			req.setAttribute("incorrectEmail", "email is incorrect");
			req.getRequestDispatcher("user-login.jsp").forward(req, resp);
		}
	}
}