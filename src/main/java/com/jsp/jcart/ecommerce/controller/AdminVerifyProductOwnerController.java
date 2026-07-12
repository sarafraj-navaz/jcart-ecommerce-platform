package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.jsp.jcart.ecommerce.service.ProductOwnerService;

@SuppressWarnings("serial")
@WebServlet(value = "/verify")
public class AdminVerifyProductOwnerController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		new ProductOwnerService().verifyProductOwnerByIdService(Integer.parseInt(req.getParameter("ownerid")));

		req.getRequestDispatcher("verify-owner.jsp").forward(req, resp);
	}
}