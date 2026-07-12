package com.jsp.jcart.ecommerce.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Owner ke through upload ki gayi product images ko serve karta hai.
 *
 * Ye images webapp ke andar (assets/rugs) save NAHI hoti, balki ek persistent
 * folder mein save hoti hain (dekho AddProductController + UploadPaths), jo
 * redeploy / rebuild / container-restart ke baad bhi surakshit rehta hai.
 *
 * Usage: photo?file=rug-<uuid>.jpg
 */
@WebServlet(value = "/photo")
public class PhotoController extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String fileName = req.getParameter("file");

		// Basic safety: sirf plain filename allow karo, koi path traversal (../) allow nahi
		if (fileName == null || fileName.isBlank()
				|| fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file name");
			return;
		}

		File imageFile = new File(UploadPaths.getUploadDir(), fileName);

		if (!imageFile.exists() || !imageFile.isFile()) {
			resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found: " + fileName);
			return;
		}

		String contentType = getServletContext().getMimeType(imageFile.getName());
		if (contentType == null) {
			contentType = "application/octet-stream";
		}
		resp.setContentType(contentType);
		resp.setContentLengthLong(imageFile.length());
		// Browser ko image cache karne do (image content kabhi overwrite nahi hoti, naya upload = naya filename)
		resp.setHeader("Cache-Control", "public, max-age=31536000, immutable");

		try (var in = Files.newInputStream(imageFile.toPath())) {
			in.transferTo(resp.getOutputStream());
		}
	}
}
