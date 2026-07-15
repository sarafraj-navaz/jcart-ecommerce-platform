package com.jsp.jcart.ecommerce.service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.jsp.jcart.ecommerce.dao.UserDao;
import com.jsp.jcart.ecommerce.dto.User;
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
}
