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
					return mapRow(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/** Email ya phone number, dono se user dhoondh sakte hain (OTP login / forgot password ke liye). */
	public User findByEmailOrPhone(String contact) {

		boolean isEmail = contact != null && contact.contains("@");
		String query = isEmail ? "select * from user where email = ?" : "select * from user where phone = ?";

		try (Connection con = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = con.prepareStatement(query)) {

			if (isEmail) {
				preparedStatement.setString(1, contact);
			} else {
				preparedStatement.setLong(1, Long.parseLong(contact.trim()));
			}

			try (ResultSet rs = preparedStatement.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}
		} catch (SQLException | NumberFormatException e) {
			e.printStackTrace();
		}
		return null;
	}

	public void saveOtp(int userId, String otp, long expiry) {

		String query = "update user set otp_code = ?, otp_expiry = ? where id = ?";

		try (Connection con = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = con.prepareStatement(query)) {

			preparedStatement.setString(1, otp);
			preparedStatement.setLong(2, expiry);
			preparedStatement.setInt(3, userId);
			preparedStatement.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/** @return {otp_code, otp_expiry} as strings, or null if the user doesn't exist. */
	public String[] getOtp(int userId) {

		String query = "select otp_code, otp_expiry from user where id = ?";

		try (Connection con = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = con.prepareStatement(query)) {

			preparedStatement.setInt(1, userId);

			try (ResultSet rs = preparedStatement.executeQuery()) {
				if (rs.next()) {
					return new String[] { rs.getString("otp_code"), rs.getString("otp_expiry") };
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public void clearOtp(int userId) {

		String query = "update user set otp_code = null, otp_expiry = null where id = ?";

		try (Connection con = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = con.prepareStatement(query)) {

			preparedStatement.setInt(1, userId);
			preparedStatement.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void updatePassword(int userId, String hashedPassword) {

		String query = "update user set password = ? where id = ?";

		try (Connection con = UserConnection.getUserConnection();
				PreparedStatement preparedStatement = con.prepareStatement(query)) {

			preparedStatement.setString(1, hashedPassword);
			preparedStatement.setInt(2, userId);
			preparedStatement.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private User mapRow(ResultSet rs) throws SQLException {
		return new User(rs.getInt("id"), rs.getString("name"), rs.getString("email"), rs.getLong("phone"),
				rs.getString("password"), rs.getString("address"));
	}
}
