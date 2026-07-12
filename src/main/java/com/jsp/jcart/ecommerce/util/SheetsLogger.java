package com.jsp.jcart.ecommerce.util;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

/**
 * Fire-and-forget logger that POSTs new registrations to a Google Apps
 * Script webhook, which appends a row to a Google Sheet.
 *
 * Setup: see GOOGLE_SHEETS.md in the project root for the Apps Script
 * you need to deploy first, then set JCART_SHEETS_WEBHOOK to its /exec URL.
 */
public final class SheetsLogger {

	private static final String WEBHOOK_URL = System.getenv()
			.getOrDefault("JCART_SHEETS_WEBHOOK", "");

	private static final HttpClient CLIENT = HttpClient.newBuilder()
			.connectTimeout(Duration.ofSeconds(5))
			.build();

	private SheetsLogger() {
	}

	public static void logRegistrationAsync(String name, String email, String phone, String address) {
		if (WEBHOOK_URL.isEmpty()) {
			// Not configured - skip silently rather than breaking registration.
			return;
		}

		String json = String.format(
				"{\"name\":\"%s\",\"email\":\"%s\",\"phone\":\"%s\",\"address\":\"%s\"}",
				escape(name), escape(email), escape(phone), escape(address));

		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(WEBHOOK_URL))
				.header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(json))
				.build();

		CLIENT.sendAsync(request, HttpResponse.BodyHandlers.ofString())
				.exceptionally(ex -> {
					System.err.println("SheetsLogger failed: " + ex.getMessage());
					return null;
				});
	}

	private static String escape(String s) {
		return s == null ? "" : s.replace("\"", "\\\"");
	}
}