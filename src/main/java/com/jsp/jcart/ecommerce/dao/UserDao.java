package com.jsp.jcart.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jsp.jcart.ecommerce.connection.UserConnection;
import com.jsp.jcart.ecommerce.dto.User;

/**
 * @author Sarafraj
 */
public class UserDao {

	public User saveUserDao(User user) {

		String insertQuery = "insert into user(name,email,password,phone,address) values(?,?,?,?,?)";

		try (Connection con = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = con.prepareStatement(insertQuery)) {

			preparedStatement.setString(1, user.getUserName());
			preparedStatement.setString(2, user.getUserEmail());
			preparedStatement.setString(3, user.getUserPassword()); // already hashed by UserService
			preparedStatement.setLong(4, user.getUserPhone());
			preparedStatement.setString(5, user.getUserAddress());

			preparedStatement.execute();
			return user;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Looks a user up by email only. Password comparison happens in the
	 * service/controller layer against the hash returned here - see
	 * PasswordUtil.verify().
	 */
	public User loginWithUser(String userEmail) {

		String emailQuery = "select * from user where email = ?";

		try (Connection con = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = con.prepareStatement(emailQuery)) {

			preparedStatement.setString(1, userEmail);

			try (ResultSet rs = preparedStatement.executeQuery()) {
				if (rs.next()) {
					return new User(rs.getString("email"), rs.getString("password"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
}