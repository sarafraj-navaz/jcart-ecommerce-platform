package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.jsp.jcart.ecommerce.service.ProductService;

/**
 * Owner dashboard se ek product ko delete karta hai.
 * Access sirf logged-in owner ko hi milta hai (dekho AuthFilter), aur DAO
 * layer par bhi dobara check hota hai ki product isi owner ka ho - taaki
 * URL mein id badal kar koi doosre owner ka product delete na kar sake.
 * Usage: delete-product-owner?id=<productId>
 */
@WebServlet(value = "/delete-product-owner")
public class DeleteProductController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("ownerId") == null) {
			resp.sendRedirect(req.getContextPath() + "/owner-login.jsp");
			return;
		}
		int ownerId = (int) session.getAttribute("ownerId");

		String idParam = req.getParameter("id");
		try {
			int productId = Integer.parseInt(idParam);
			new ProductService().deleteProductService(productId, ownerId);
		} catch (NumberFormatException e) {
			// Invalid/missing id -> ignore, bas dashboard par wapas bhej do
		}

		resp.sendRedirect(req.getContextPath() + "/owner-home.jsp");
	}
}
