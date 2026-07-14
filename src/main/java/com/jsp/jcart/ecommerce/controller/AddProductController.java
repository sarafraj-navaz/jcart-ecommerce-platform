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

@WebServlet(value = "/add-product-owner")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // max 5MB image
public class AddProductController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("ownerId") == null) {
			resp.sendRedirect(req.getContextPath() + "/owner-login.jsp");
			return;
		}
		int ownerId = (int) session.getAttribute("ownerId");

		String name = req.getParameter("productName");
		String type = req.getParameter("productType");
		String wearType = req.getParameter("productWearType");
		double price = Double.parseDouble(req.getParameter("productPrice"));

		Product product = new Product(name, type, wearType, price);

		// Uploaded file ko ek PERSISTENT folder mein save karo (webapp ke deployed
		// folder ke bahar), taaki redeploy/rebuild/container-restart ke baad bhi
		// image gayab na ho. Serving PhotoController (/photo?file=...) ke through hoti hai.
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

			// DB mein ab ek servlet URL store hoga, ek static asset path nahi
			product.setImagePath("photo?file=" + newFileName);
		}

		new ProductService().saveProductService(product, ownerId);

		req.getRequestDispatcher("owner-home.jsp").forward(req, resp);
	}

}