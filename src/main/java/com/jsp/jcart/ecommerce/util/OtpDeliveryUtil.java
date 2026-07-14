package com.jsp.jcart.ecommerce.util;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

/**
 * Sends an OTP to a "contact" that is either an email address or a phone
 * number, deciding which channel to use automatically.
 *
 * Email: sent via real SMTP (see MailUtil for setup).
 *
 * Phone/SMS: this project does not ship with a paid SMS gateway. If you
 * configure JCART_SMS_WEBHOOK (any HTTP endpoint that accepts
 * {"phone":"...","message":"..."} as JSON - e.g. a Twilio/Fast2SMS/MSG91
 * relay you set up), the OTP is POSTed there. Otherwise, exactly like
 * SheetsLogger and MailUtil's dev fallback, the OTP is printed to the
 * server console so you can still test the OTP flow end-to-end locally.
 */
public final class OtpDeliveryUtil {

	private static final String SMS_WEBHOOK_URL = System.getenv().getOrDefault("JCART_SMS_WEBHOOK", "");

	private static final HttpClient CLIENT = HttpClient.newBuilder()
			.connectTimeout(Duration.ofSeconds(5))
			.build();

	private OtpDeliveryUtil() {
	}

	public static void sendOtp(String contact, String otp, String purpose) {
		String message = "Your J-Cart " + purpose + " OTP is " + otp + ". It is valid for 5 minutes. "
				+ "Do not share this code with anyone.";

		if (OtpUtil.isEmail(contact)) {
			MailUtil.sendEmail(contact, "J-Cart OTP - " + purpose, message);
			return;
		}

		sendSms(contact, message);
	}

	private static void sendSms(String phone, String message) {
		if (SMS_WEBHOOK_URL.isEmpty()) {
			// Dev fallback: no real SMS gateway configured yet.
			System.out.println("=== [J-Cart SMS - no gateway configured, printing instead] ===");
			System.out.println("To: " + phone);
			System.out.println(message);
			System.out.println("================================================================");
			return;
		}

		String json = String.format("{\"phone\":\"%s\",\"message\":\"%s\"}", escape(phone), escape(message));

		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(SMS_WEBHOOK_URL))
				.header("Content-Type", "application/json")
				.POST(HttpRequest.BodyPublishers.ofString(json))
				.build();

		CLIENT.sendAsync(request, HttpResponse.BodyHandlers.ofString())
				.exceptionally(ex -> {
					System.err.println("OtpDeliveryUtil SMS send failed: " + ex.getMessage());
					return null;
				});
	}

	private static String escape(String s) {
		return s == null ? "" : s.replace("\"", "\\\"");
	}
}
