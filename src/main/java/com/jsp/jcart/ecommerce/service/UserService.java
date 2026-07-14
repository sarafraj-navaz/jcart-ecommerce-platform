package com.jsp.jcart.ecommerce.service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.jsp.jcart.ecommerce.dao.UserDao;
import com.jsp.jcart.ecommerce.dto.User;
import com.jsp.jcart.ecommerce.util.OtpDeliveryUtil;
import com.jsp.jcart.ecommerce.util.OtpUtil;
import com.jsp.jcart.ecommerce.util.PasswordUtil;

public class UserService {

	UserDao userDao = new UserDao();

	public User saveUserService(User user) {

		String password = user.getUserPassword();

		if (password.length() >= 8 && password.length() <= 15) {

			Matcher alphabet = Pattern.compile("[a-zA-Z]").matcher(password);
			Matcher number = Pattern.compile("[0-9]").matcher(password);
			Matcher special = Pattern.compile("[@#$^&*%]").matcher(password);

			if (alphabet.find() && number.find() && special.find()) {
				user.setUserPassword(PasswordUtil.hash(password));
				return userDao.saveUserDao(user);
			}
		}
		return null;
	}

	public User loginWithUserService(String userEmail) {
		return userDao.loginWithUser(userEmail);
	}

	/** Step 1 of OTP login: finds the user by email/phone, generates + sends an OTP. */
	public User sendLoginOtp(String contact) {
		User user = userDao.findByEmailOrPhone(contact);
		if (user == null) {
			return null;
		}
		String otp = OtpUtil.generateOtp();
		userDao.saveOtp(user.getUserId(), otp, OtpUtil.newExpiry());
		OtpDeliveryUtil.sendOtp(contact, otp, "login");
		return user;
	}

	/** Step 2 of OTP login: validates the code and clears it once used. */
	public User verifyLoginOtp(String contact, String otp) {
		User user = userDao.findByEmailOrPhone(contact);
		if (user == null) {
			return null;
		}
		String[] stored = userDao.getOtp(user.getUserId());
		if (stored == null || !OtpUtil.isValid(stored[0], stored[1], otp)) {
			return null;
		}
		userDao.clearOtp(user.getUserId());
		return user;
	}

	/** Step 1 of "forgot password": same OTP mechanism, reused for a different purpose. */
	public User sendPasswordResetOtp(String contact) {
		User user = userDao.findByEmailOrPhone(contact);
		if (user == null) {
			return null;
		}
		String otp = OtpUtil.generateOtp();
		userDao.saveOtp(user.getUserId(), otp, OtpUtil.newExpiry());
		OtpDeliveryUtil.sendOtp(contact, otp, "password reset");
		return user;
	}

	/** Step 2 of "forgot password": validates the code and sets a new (hashed) password. */
	public boolean resetPassword(String contact, String otp, String newPassword) {
		User user = userDao.findByEmailOrPhone(contact);
		if (user == null) {
			return false;
		}
		String[] stored = userDao.getOtp(user.getUserId());
		if (stored == null || !OtpUtil.isValid(stored[0], stored[1], otp)) {
			return false;
		}
		if (newPassword == null || newPassword.length() < 8 || newPassword.length() > 15) {
			return false;
		}
		userDao.updatePassword(user.getUserId(), PasswordUtil.hash(newPassword));
		userDao.clearOtp(user.getUserId());
		return true;
	}
}
