package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.jsp.jcart.ecommerce.dto.ProductOwner;
import com.jsp.jcart.ecommerce.service.ProductOwnerService;
import com.jsp.jcart.ecommerce.util.SheetsLogger;

@WebServlet(value = "/ownerRegister")
public class ProductOwnerController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String name = req.getParameter("ownerName");
		String email = req.getParameter("ownerEmail");
		String password = req.getParameter("ownerPassword");
		long phone = Long.parseLong(req.getParameter("ownerPhone"));

		ProductOwner productOwner = new ProductOwnerService().saveProductOwnerService(
				new ProductOwner(name, email, password, phone));

		// Fixed: previously compared productOwner.getPassword().equals(password),
		// but that field now holds the PBKDF2 hash (not the plaintext), so that
		// check would always be false post-hashing. A non-null return already
		// means the save succeeded, so that alone is the success condition.
		if (productOwner != null) {

			SheetsLogger.logRegistrationAsync(name, email, String.valueOf(phone), "");
			req.getRequestDispatcher("owner-login.jsp").forward(req, resp);

		} else {
			
			req.setAttribute("passMessage","please check your password");
			req.getRequestDispatcher("owner-register.jsp").forward(req, resp);
		}

	}

}