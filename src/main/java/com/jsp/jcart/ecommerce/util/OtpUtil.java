package com.jsp.jcart.ecommerce.util;

import java.security.SecureRandom;

/**
 * Generates 6-digit numeric OTPs and validates them against a stored
 * (otp, expiry) pair. Used for both "login with OTP" and "forgot password".
 */
public final class OtpUtil {

	private static final SecureRandom RANDOM = new SecureRandom();

	/** How long an OTP stays valid after being generated. */
	public static final long OTP_VALID_MILLIS = 5 * 60 * 1000; // 5 minutes

	private OtpUtil() {
	}

	public static String generateOtp() {
		int number = 100000 + RANDOM.nextInt(900000); // always 6 digits, 100000-999999
		return String.valueOf(number);
	}

	public static long newExpiry() {
		return System.currentTimeMillis() + OTP_VALID_MILLIS;
	}

	/**
	 * @param storedOtp      otp_code column value (may be null)
	 * @param storedExpiry   otp_expiry column value as string (may be null/"0")
	 * @param suppliedOtp    what the user typed in
	 */
	public static boolean isValid(String storedOtp, String storedExpiry, String suppliedOtp) {
		if (storedOtp == null || suppliedOtp == null || storedExpiry == null) {
			return false;
		}
		long expiry;
		try {
			expiry = Long.parseLong(storedExpiry);
		} catch (NumberFormatException e) {
			return false;
		}
		if (System.currentTimeMillis() > expiry) {
			return false; // expired
		}
		return storedOtp.trim().equals(suppliedOtp.trim());
	}

	/** True if the given contact string looks like an email address rather than a phone number. */
	public static boolean isEmail(String contact) {
		return contact != null && contact.contains("@");
	}
}
