package com.jsp.jcart.ecommerce.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class UserConnection {

	private static final String URL = System.getenv().getOrDefault(
			"JCART_DB_URL", "jdbc:mysql://localhost:3306/jcart_web_app?useSSL=false&serverTimezone=UTC");
	private static final String USER = System.getenv().getOrDefault("JCART_DB_USER", "root");
	private static final String PASSWORD = System.getenv().getOrDefault("JCART_DB_PASSWORD", "Raj@#0786");

	static {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("MySQL JDBC driver not found on classpath", e);
		}
	}

	private UserConnection() {
	}

	public static Connection getUserConnection() throws SQLException {
		return DriverManager.getConnection(URL, USER, PASSWORD);
	}
}
