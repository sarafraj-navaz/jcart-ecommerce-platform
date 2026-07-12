package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.jsp.jcart.ecommerce.dao.ProductDao;

/**
 * Owner dashboard se ek product ko delete karta hai.
 * Access sirf logged-in owner ko hi milta hai (dekho AuthFilter).
 * Usage: delete-product-owner?id=<productId>
 */
@WebServlet(value = "/delete-product-owner")
public class DeleteProductController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String idParam = req.getParameter("id");
		try {
			int productId = Integer.parseInt(idParam);
			new ProductDao().deleteProductById(productId);
		} catch (NumberFormatException e) {
			// Invalid/missing id -> ignore, bas dashboard par wapas bhej do
		}

		resp.sendRedirect(req.getContextPath() + "/owner-home.jsp");
	}
}
