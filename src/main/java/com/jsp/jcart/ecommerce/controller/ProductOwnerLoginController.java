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
import com.jsp.jcart.ecommerce.util.PasswordUtil;

@WebServlet("/ownerLogin")
public class ProductOwnerLoginController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String email = req.getParameter("OwnerEmail");
		String password = req.getParameter("OwnerPassword");

		ProductOwner owner = new ProductOwnerService().loginWithEmailPasswordService(email);

		if (owner != null && PasswordUtil.verify(password, owner.getPassword())) {

			if ("yes".equals(owner.getVerify())) {

				HttpSession session = req.getSession(true);
				session.invalidate();
				session = req.getSession(true);
				session.setAttribute("ownerEmail", owner.getEmail());
				session.setAttribute("ownerId", owner.getId());
				session.setAttribute("ownerName", owner.getName());

				req.getRequestDispatcher("owner-home.jsp").forward(req, resp);
			} else {
				req.setAttribute("unverified", "you are not verified please contact with admin team");
				req.getRequestDispatcher("owner-login.jsp").forward(req, resp);
			}

		} else if (owner != null) {
			req.setAttribute("incorrectOwnerPass", "please pass correct password");
			req.getRequestDispatcher("owner-login.jsp").forward(req, resp);
		} else {
			req.setAttribute("incorrectOwnerEmail", "please pass correct email");
			req.getRequestDispatcher("owner-login.jsp").forward(req, resp);
		}
	}
}