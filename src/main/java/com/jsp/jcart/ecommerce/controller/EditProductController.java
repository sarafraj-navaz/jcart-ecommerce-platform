package com.jsp.jcart.ecommerce.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.jsp.jcart.ecommerce.dto.Product;
import com.jsp.jcart.ecommerce.service.ProductService;

/**
 * Lets a product owner edit ONE OF THEIR OWN products.
 * GET  /edit-product-owner?id=123  -> loads edit-product-owner.jsp pre-filled
 * POST /edit-product-owner         -> saves the changes
 *
 * Ownership is enforced at the DB layer (ProductDao.updateProductForOwner
 * only updates a row where owner_id matches), so even a tampered id in the
 * URL/form can't be used to edit someone else's product.
 */
@WebServlet(value = "/edit-product-owner")
@MultipartConfig(maxFileSize = 20 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class EditProductController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession(false);
		int ownerId = (session != null && session.getAttribute("ownerId") != null)
				? (int) session.getAttribute("ownerId")
				: 0;

		try {
			int productId = Integer.parseInt(req.getParameter("id"));
			Product product = new ProductService().getProductByIdService(productId);

			// Product exist karta hai lekin kisi doosre owner ka hai -> access nahi denge
			if (product == null || product.getOwnerId() != ownerId) {
				resp.sendRedirect(req.getContextPath() + "/owner-home.jsp");
				return;
			}

			req.setAttribute("product", product);
			req.getRequestDispatcher("edit-product-owner.jsp").forward(req, resp);

		} catch (NumberFormatException e) {
			resp.sendRedirect(req.getContextPath() + "/owner-home.jsp");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession(false);
		int ownerId = (session != null && session.getAttribute("ownerId") != null)
				? (int) session.getAttribute("ownerId")
				: 0;

		int productId;
		try {
			productId = Integer.parseInt(req.getParameter("productId"));
		} catch (NumberFormatException e) {
			resp.sendRedirect(req.getContextPath() + "/owner-home.jsp");
			return;
		}

		String name = req.getParameter("productName");
		String type = req.getParameter("productType");
		String wearType = req.getParameter("productWearType");
		double price = Double.parseDouble(req.getParameter("productPrice"));

		Product product = new Product(productId, name, type, wearType, price, null, null, ownerId);

		boolean updateImage = false;
		Part filePart = req.getPart("productImageFile");
		if (filePart != null && filePart.getSize() > 0) {
			String originalName = filePart.getSubmittedFileName();
			String extension = originalName != null && originalName.contains(".")
					? originalName.substring(originalName.lastIndexOf('.'))
					: ".jpg";
			String newFileName = "rug-" + UUID.randomUUID() + extension;

			File uploadDir = UploadPaths.getUploadDir();
			Path targetPath = new File(uploadDir, newFileName).toPath();
			try (InputStream fileContent = filePart.getInputStream()) {
				Files.copy(fileContent, targetPath, StandardCopyOption.REPLACE_EXISTING);
			}

			product.setImagePath("photo?file=" + newFileName);
			updateImage = true;
		}

		if (ownerId > 0) {
			new ProductService().updateProductService(product, ownerId, updateImage);
		}

		resp.sendRedirect(req.getContextPath() + "/owner-home.jsp");
	}
}
