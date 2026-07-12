package com.jsp.jcart.ecommerce.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Password hashing helper using PBKDF2WithHmacSHA256.
 *
 * Why PBKDF2 and not BCrypt: PBKDF2 ships in the JDK itself (javax.crypto),
 * so it needs zero extra Maven dependencies - important here since this
 * project previously stored passwords in plain text and had no hashing
 * library on the classpath at all.
 *
 * Stored format: iterations:base64(salt):base64(hash)
 * Storing the iteration count and salt alongside the hash means we can
 * change the iteration count later without breaking old hashes.
 */
public final class PasswordUtil {

	private static final int SALT_BYTES = 16;
	private static final int HASH_BYTES = 32;
	private static final int ITERATIONS = 120_000;
	private static final String ALGORITHM = "PBKDF2WithHmacSHA256";

	private PasswordUtil() {
	}

	public static String hash(String plainPassword) {
		try {
			byte[] salt = new byte[SALT_BYTES];
			new SecureRandom().nextBytes(salt);

			byte[] hash = pbkdf2(plainPassword.toCharArray(), salt, ITERATIONS, HASH_BYTES);

			return ITERATIONS + ":" + Base64.getEncoder().encodeToString(salt) + ":"
					+ Base64.getEncoder().encodeToString(hash);

		} catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
			throw new IllegalStateException("Could not hash password", e);
		}
	}

	public static boolean verify(String plainPassword, String storedHash) {
		if (storedHash == null || !storedHash.contains(":")) {
			// Handles any legacy plain-text rows left over from before this fix.
			// Safe to delete this branch once the database has been migrated.
			return storedHash != null && storedHash.equals(plainPassword);
		}
		try {
			String[] parts = storedHash.split(":");
			int iterations = Integer.parseInt(parts[0]);
			byte[] salt = Base64.getDecoder().decode(parts[1]);
			byte[] expectedHash = Base64.getDecoder().decode(parts[2]);

			byte[] actualHash = pbkdf2(plainPassword.toCharArray(), salt, iterations, expectedHash.length);

			return slowEquals(expectedHash, actualHash);

		} catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
			throw new IllegalStateException("Could not verify password", e);
		}
	}

	private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int bytes)
			throws NoSuchAlgorithmException, InvalidKeySpecException {
		PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, bytes * 8);
		SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGORITHM);
		return skf.generateSecret(spec).getEncoded();
	}

	/** Constant-time comparison so timing attacks can't leak the hash byte by byte. */
	private static boolean slowEquals(byte[] a, byte[] b) {
		int diff = a.length ^ b.length;
		for (int i = 0; i < a.length && i < b.length; i++) {
			diff |= a[i] ^ b[i];
		}
		return diff == 0;
	}
}