package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Admin-only page that pulls registration rows back from the Google Sheet
 * (via the same Apps Script webhook SheetsLogger posts to) and displays
 * them in a table. Protected by AuthFilter - see filter/AuthFilter.java.
 */
@WebServlet("/registrations")
public class RegistrationsController extends HttpServlet {

	private static final String WEBHOOK_URL = System.getenv().getOrDefault("JCART_SHEETS_WEBHOOK", "");

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		List<String[]> rows = new ArrayList<>();

		if (!WEBHOOK_URL.isEmpty()) {
			try {
				HttpClient client = HttpClient.newHttpClient();
				HttpRequest request = HttpRequest.newBuilder(URI.create(WEBHOOK_URL)).GET().build();
				HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

				for (String line : response.body().split("\n")) {
					if (!line.isBlank()) {
						rows.add(line.split("\\|\\|\\|"));
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		req.setAttribute("registrations", rows);
		req.getRequestDispatcher("registrations.jsp").forward(req, resp);
	}
}