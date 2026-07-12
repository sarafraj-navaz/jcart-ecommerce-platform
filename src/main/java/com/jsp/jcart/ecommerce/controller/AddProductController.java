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
import jakarta.servlet.http.Part;

import com.jsp.jcart.ecommerce.dto.Product;
import com.jsp.jcart.ecommerce.service.ProductService;

@WebServlet(value = "/add-product-owner")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // max 5MB image
public class AddProductController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String name = req.getParameter("productName");
		String type = req.getParameter("productType");
		String wearType = req.getParameter("productWearType");
		double price = Double.parseDouble(req.getParameter("productPrice"));

		Product product = new Product(name, type, wearType, price);

		// Uploaded file ko "assets/rugs" folder mein save karo aur uska relative path DB ke liye rakho
		Part filePart = req.getPart("productImageFile");
		if (filePart != null && filePart.getSize() > 0) {
			String originalName = filePart.getSubmittedFileName();
			String extension = originalName != null && originalName.contains(".")
					? originalName.substring(originalName.lastIndexOf('.'))
					: ".jpg";
			String newFileName = "rug-" + UUID.randomUUID() + extension;

			// Deployed webapp ke andar assets/rugs ka real (disk) path nikalo
			String rugsFolderPath = getServletContext().getRealPath("/assets/rugs/");
			File rugsFolder = new File(rugsFolderPath);
			if (!rugsFolder.exists()) {
				rugsFolder.mkdirs();
			}

			Path targetPath = new File(rugsFolder, newFileName).toPath();
			try (InputStream fileContent = filePart.getInputStream()) {
				Files.copy(fileContent, targetPath, StandardCopyOption.REPLACE_EXISTING);
			}

			// Yahi path database ke "image" column mein jaayega
			product.setImagePath("assets/rugs/" + newFileName);
		}

		new ProductService().saveProductService(product);

		req.getRequestDispatcher("owner-home.jsp").forward(req, resp);
	}

}