package com.jsp.jcart.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsp.jcart.ecommerce.connection.UserConnection;
import com.jsp.jcart.ecommerce.dto.ProductOwner;

public class ProductOwnerDao {

	public ProductOwner saveProductOwnerDao(ProductOwner productOwner) {

		String insertQuery = "insert into owner(name,email,password,phone,verify) values(?,?,?,?,?)";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(insertQuery)) {

			preparedStatement.setString(1, productOwner.getName());
			preparedStatement.setString(2, productOwner.getEmail());
			preparedStatement.setString(3, productOwner.getPassword()); // already hashed by ProductOwnerService
			preparedStatement.setLong(4, productOwner.getPhone());
			preparedStatement.setString(5, "no");

			preparedStatement.execute();
			return productOwner;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public ProductOwner loginWithEmailPassword(String email) {

		String selectEmailQuery = "select * from owner where email = ?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(selectEmailQuery)) {

			preparedStatement.setString(1, email);

			try (ResultSet rs = preparedStatement.executeQuery()) {
				if (rs.next()) {
					return new ProductOwner(rs.getInt("id"), rs.getString("name"), rs.getString("email"),
							rs.getString("password"), rs.getLong("phone"), rs.getString("verify"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<ProductOwner> displayAllProductOwnerDao() {

		String query = "select * from owner";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query);
				ResultSet resultSet = preparedStatement.executeQuery()) {

			List<ProductOwner> owners = new ArrayList<>();
			while (resultSet.next()) {
				owners.add(new ProductOwner(resultSet.getInt("id"), resultSet.getString("name"),
						resultSet.getString("email"), resultSet.getString("password"), resultSet.getLong("phone"),
						resultSet.getString("verify")));
			}
			return owners;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/** Fixed: now uses a PreparedStatement instead of string-concatenated SQL. */
	public int verifyProductOwnerByIdDao(int productOwnerId) {

		String query = "update owner set verify='yes' where id=?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query)) {

			preparedStatement.setInt(1, productOwnerId);
			return preparedStatement.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	/** Fixed: now uses a PreparedStatement instead of string-concatenated SQL. */
	public int unverifyProductOwnerByIdDao(int productOwnerId) {

		String query = "update owner set verify='no' where id=?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query)) {

			preparedStatement.setInt(1, productOwnerId);
			return preparedStatement.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
}