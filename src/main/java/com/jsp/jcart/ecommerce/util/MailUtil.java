package com.jsp.jcart.ecommerce.util;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Sends plain emails over SMTP - used for OTP login and "forgot password"
 * emails.
 *
 * Setup: set these environment variables before starting the server
 * (same pattern as JCART_DB_URL / JCART_DB_USER in UserConnection):
 *   JCART_SMTP_HOST      e.g. smtp.gmail.com
 *   JCART_SMTP_PORT      e.g. 587
 *   JCART_SMTP_USER      the sending mailbox, e.g. noreply@yourdomain.com
 *   JCART_SMTP_PASSWORD  an app password (NOT your normal account password)
 *
 * If JCART_SMTP_HOST is not set, sendEmail() just logs the message to the
 * server console instead of failing - so the rest of the app keeps working
 * in dev/without real SMTP configured, and you can still see the OTP.
 */
public final class MailUtil {

	private static final String SMTP_HOST = System.getenv().getOrDefault("JCART_SMTP_HOST", "");
	private static final String SMTP_PORT = System.getenv().getOrDefault("JCART_SMTP_PORT", "587");
	private static final String SMTP_USER = System.getenv().getOrDefault("JCART_SMTP_USER", "");
	private static final String SMTP_PASSWORD = System.getenv().getOrDefault("JCART_SMTP_PASSWORD", "");

	private MailUtil() {
	}

	public static boolean isConfigured() {
		return !SMTP_HOST.isEmpty() && !SMTP_USER.isEmpty() && !SMTP_PASSWORD.isEmpty();
	}

	public static void sendEmail(String toEmail, String subject, String body) {
		if (!isConfigured()) {
			// Dev fallback: print to server console/log so OTP testing still works
			// even before real SMTP credentials are configured.
			System.out.println("=== [J-Cart Mail - SMTP not configured, printing instead] ===");
			System.out.println("To: " + toEmail);
			System.out.println("Subject: " + subject);
			System.out.println(body);
			System.out.println("==============================================================");
			return;
		}

		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", SMTP_HOST);
		props.put("mail.smtp.port", SMTP_PORT);

		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
			}
		});

		try {
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(SMTP_USER, "J-Cart"));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
			message.setSubject(subject);
			message.setText(body);

			Transport.send(message);

		} catch (MessagingException | java.io.UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
}
