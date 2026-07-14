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

	/** Owner ke naam se product save karta hai (owner_id product ke saath jud jaata hai). */
	public Product saveProductDaoInsert(Product product, int ownerId) {

		String productRegisterQuery = "insert into products(name,type,weartype,price,image,owner_id) values(?,?,?,?,?,?)";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(productRegisterQuery)) {

			preparedStatement.setString(1, product.getProductName());
			preparedStatement.setString(2, product.getProductType());
			preparedStatement.setString(3, product.getProductWearType());
			preparedStatement.setDouble(4, product.getProductPrice());

			// Image file already "assets/rugs/" folder mein save ho chuki hai (Controller mein),
			// yahan sirf uska relative path text ke roop mein DB mein jaata hai
			preparedStatement.setString(5, product.getImagePath());
			preparedStatement.setInt(6, ownerId);

			preparedStatement.execute();
			product.setOwnerId(ownerId);
			return product;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/** Sabhi products, sirf verified product owners ke, taaki home page par un par hi bharosa kiya ja sake. */
	public List<Product> getAllProductData() {

		// ORDER BY id ASC lagaya hai taaki MySQL har request par same, consistent
		// order return kare. Sirf un products ko dikhaya jaata hai jinke owner ko
		// admin ne verify kar diya hai (verify = 'yes'), ya jinka koi owner link
		// nahi hai (purane/legacy products, migration ke pehle ke).
		String displayProductDataQuery = "select p.* from products p "
				+ "left join owner o on p.owner_id = o.id "
				+ "where p.owner_id is null or o.verify = 'yes' "
				+ "order by p.id asc";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(displayProductDataQuery);
				ResultSet resultSet = preparedStatement.executeQuery()) {

			return mapResultSet(resultSet);

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/** Ek specific product owner ke apne saare products (unke dashboard ke liye). */
	public List<Product> getProductsByOwnerId(int ownerId) {

		String query = "select * from products where owner_id = ? order by id asc";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query)) {

			preparedStatement.setInt(1, ownerId);

			try (ResultSet resultSet = preparedStatement.executeQuery()) {
				return mapResultSet(resultSet);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/** Ek single product uske id se (edit form pre-fill karne ke liye). */
	public Product getProductById(int productId) {

		String query = "select * from products where id = ?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query)) {

			preparedStatement.setInt(1, productId);

			try (ResultSet rs = preparedStatement.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Product ko update karta hai - LEKIN sirf tab jab woh product isi ownerId ka
	 * ho. Isse koi owner kabhi bhi kisi doosre owner ka product edit nahi kar
	 * sakta, chahe URL/form mein id chhed-chhad kyu na ki gayi ho.
	 */
	public boolean updateProductForOwner(Product product, int ownerId, boolean updateImage) {

		String query = updateImage
				? "update products set name=?, type=?, weartype=?, price=?, image=? where id=? and owner_id=?"
				: "update products set name=?, type=?, weartype=?, price=? where id=? and owner_id=?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(query)) {

			int idx = 1;
			preparedStatement.setString(idx++, product.getProductName());
			preparedStatement.setString(idx++, product.getProductType());
			preparedStatement.setString(idx++, product.getProductWearType());
			preparedStatement.setDouble(idx++, product.getProductPrice());
			if (updateImage) {
				preparedStatement.setString(idx++, product.getImagePath());
			}
			preparedStatement.setInt(idx++, product.getProductId());
			preparedStatement.setInt(idx++, ownerId);

			return preparedStatement.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	/** Owner apne product ko permanently delete kar sakta hai (kisi aur ka nahi). */
	public boolean deleteProductByIdForOwner(int productId, int ownerId) {

		String deleteQuery = "delete from products where id = ? and owner_id = ?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(deleteQuery)) {

			preparedStatement.setInt(1, productId);
			preparedStatement.setInt(2, ownerId);
			int rowsAffected = preparedStatement.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	/** Legacy/admin use ke liye rakha hai - bina ownership check ke delete. */
	public boolean deleteProductById(int productId) {

		String deleteQuery = "delete from products where id = ?";

		try (Connection connection = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = connection.prepareStatement(deleteQuery)) {

			preparedStatement.setInt(1, productId);
			int rowsAffected = preparedStatement.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	private List<Product> mapResultSet(ResultSet resultSet) throws SQLException {
		List<Product> products = new ArrayList<>();
		while (resultSet.next()) {
			products.add(mapRow(resultSet));
		}
		return products;
	}

	private Product mapRow(ResultSet resultSet) throws SQLException {
		int ownerId = resultSet.getObject("owner_id") != null ? resultSet.getInt("owner_id") : 0;
		return new Product(resultSet.getInt("id"), resultSet.getString("name"),
				resultSet.getString("type"), resultSet.getString("weartype"),
				resultSet.getDouble("price"), null, resultSet.getString("image"), ownerId);
	}
}
