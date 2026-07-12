package com.jsp.jcart.ecommerce.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsp.jcart.ecommerce.connection.UserConnection;
import com.jsp.jcart.ecommerce.dto.Product;

public class ProductDao {

	public Product saveProductDaoInsert(Product product) {

		String productRegisterQuery = "insert into products(name,type,weartype,price,image) values(?,?,?,?,?)";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(productRegisterQuery)) {

			preparedStatement.setString(1, product.getProductName());
			preparedStatement.setString(2, product.getProductType());
			preparedStatement.setString(3, product.getProductWearType());
			preparedStatement.setDouble(4, product.getProductPrice());

			// Image file already "assets/rugs/" folder mein save ho chuki hai (Controller mein),
			// yahan sirf uska relative path text ke roop mein DB mein jaata hai
			preparedStatement.setString(5, product.getImagePath());

			preparedStatement.execute();
			return product;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<Product> getAllProductData() {

		String displayProductDataQuery = "select * from products";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(displayProductDataQuery);
				ResultSet resultSet = preparedStatement.executeQuery()) {

			List<Product> products = new ArrayList<>();
			while (resultSet.next()) {
				products.add(new Product(resultSet.getInt("id"), resultSet.getString("name"),
						resultSet.getString("type"), resultSet.getString("weartype"),
						resultSet.getDouble("price"), null, resultSet.getString("image")));
			}
			return products;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
}