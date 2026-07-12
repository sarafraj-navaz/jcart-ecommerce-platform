package com.jsp.jcart.ecommerce.controller;

import java.io.File;

/**
 * Resolves a persistent, on-disk folder for owner-uploaded product images.
 *
 * IMPORTANT: Is folder ko jaan-boojh kar webapp/target/exploded-war directory
 * ke BAHAR rakha gaya hai. Wo directory har redeploy/rebuild (Eclipse "Clean",
 * `mvn package`, Docker image rebuild, container restart) par dobara bana di
 * jaati hai — isliye wahan save ki gayi files delete ho jaati thin.
 *
 * Default location: <user.home>/jcart-uploads
 * Override karne ke liye environment variable set karo: JCART_UPLOAD_DIR
 *
 * Docker mein persistence ke liye is folder ko ek named volume se mount karo, e.g.:
 *   docker run -v jcart-uploads:/root/jcart-uploads ...
 */
final class UploadPaths {

	private UploadPaths() {
	}

	static File getUploadDir() {
		String configured = System.getenv("JCART_UPLOAD_DIR");
		String path = (configured != null && !configured.isBlank())
				? configured
				: System.getProperty("user.home") + File.separator + "jcart-uploads";

		File dir = new File(path);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		return dir;
	}
}
