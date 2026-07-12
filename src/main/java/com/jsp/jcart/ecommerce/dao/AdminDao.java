package com.jsp.jcart.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jsp.jcart.ecommerce.connection.UserConnection;
import com.jsp.jcart.ecommerce.dto.Admin;

public class AdminDao {

	public Admin adminLoginWithEmailPassDao(String adminEmail) {

		String selectAdminQuery = "select * from admin where email = ?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(selectAdminQuery)) {

			preparedStatement.setString(1, adminEmail);

			try (ResultSet resultSet = preparedStatement.executeQuery()) {
				if (resultSet.next()) {
					return new Admin(resultSet.getString("email"), resultSet.getString("password"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
}