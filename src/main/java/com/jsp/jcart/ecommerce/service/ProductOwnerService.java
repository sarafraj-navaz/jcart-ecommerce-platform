package com.jsp.jcart.ecommerce.service;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.jsp.jcart.ecommerce.dao.ProductOwnerDao;
import com.jsp.jcart.ecommerce.dto.ProductOwner;
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
}