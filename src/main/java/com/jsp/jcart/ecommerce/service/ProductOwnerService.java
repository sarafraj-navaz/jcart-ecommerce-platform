package com.jsp.jcart.ecommerce.service;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.jsp.jcart.ecommerce.dao.ProductOwnerDao;
import com.jsp.jcart.ecommerce.dto.ProductOwner;
import com.jsp.jcart.ecommerce.util.OtpDeliveryUtil;
import com.jsp.jcart.ecommerce.util.OtpUtil;
import com.jsp.jcart.ecommerce.util.PasswordUtil;

public class ProductOwnerService {

	ProductOwnerDao dao = new ProductOwnerDao();

	public ProductOwner saveProductOwnerService(ProductOwner productOwner) {

		String password = productOwner.getPassword();

		if (password.length() >= 8 && password.length() <= 15) {

			Matcher alphabet = Pattern.compile("[a-zA-Z]").matcher(password);
			Matcher number = Pattern.compile("[0-9]").matcher(password);
			Matcher special = Pattern.compile("[@#$%^&*!>?<:?><]").matcher(password);

			if (alphabet.find() && number.find() && special.find()) {
				productOwner.setPassword(PasswordUtil.hash(password));
				return dao.saveProductOwnerDao(productOwner);
			}
		}
		return null;
	}

	public ProductOwner loginWithEmailPasswordService(String email) {
		return dao.loginWithEmailPassword(email);
	}

	public int verifyProductOwnerByIdService(int productOwnerId) {
		return dao.verifyProductOwnerByIdDao(productOwnerId);
	}

	public int unverifyProductOwnerByIdService(int productOwnerId) {
		return dao.unverifyProductOwnerByIdDao(productOwnerId);
	}

	public List<ProductOwner> displayAllProductOwnerService() {
		return dao.displayAllProductOwnerDao();
	}

	/** Step 1 of OTP login: finds the owner by email/phone, generates + sends an OTP. */
	public ProductOwner sendLoginOtp(String contact) {
		ProductOwner owner = dao.findByEmailOrPhone(contact);
		if (owner == null) {
			return null;
		}
		String otp = OtpUtil.generateOtp();
		dao.saveOtp(owner.getId(), otp, OtpUtil.newExpiry());
		OtpDeliveryUtil.sendOtp(contact, otp, "login");
		return owner;
	}

	/** Step 2 of OTP login: validates the code and clears it once used. */
	public ProductOwner verifyLoginOtp(String contact, String otp) {
		ProductOwner owner = dao.findByEmailOrPhone(contact);
		if (owner == null) {
			return null;
		}
		String[] stored = dao.getOtp(owner.getId());
		if (stored == null || !OtpUtil.isValid(stored[0], stored[1], otp)) {
			return null;
		}
		dao.clearOtp(owner.getId());
		return owner;
	}

	/** Step 1 of "forgot password": same OTP mechanism, reused for a different purpose. */
	public ProductOwner sendPasswordResetOtp(String contact) {
		ProductOwner owner = dao.findByEmailOrPhone(contact);
		if (owner == null) {
			return null;
		}
		String otp = OtpUtil.generateOtp();
		dao.saveOtp(owner.getId(), otp, OtpUtil.newExpiry());
		OtpDeliveryUtil.sendOtp(contact, otp, "password reset");
		return owner;
	}

	/** Step 2 of "forgot password": validates the code and sets a new (hashed) password. */
	public boolean resetPassword(String contact, String otp, String newPassword) {
		ProductOwner owner = dao.findByEmailOrPhone(contact);
		if (owner == null) {
			return false;
		}
		String[] stored = dao.getOtp(owner.getId());
		if (stored == null || !OtpUtil.isValid(stored[0], stored[1], otp)) {
			return false;
		}
		if (newPassword == null || newPassword.length() < 8 || newPassword.length() > 15) {
			return false;
		}
		dao.updatePassword(owner.getId(), PasswordUtil.hash(newPassword));
		dao.clearOtp(owner.getId());
		return true;
	}
}