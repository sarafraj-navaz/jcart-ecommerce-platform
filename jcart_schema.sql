-- JCart database schema
-- Column names match exactly what UserDao/ProductDao/ProductOwnerDao/AdminDao expect

CREATE DATABASE IF NOT EXISTS jcart_web_app;
USE jcart_web_app;

CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    password VARCHAR(200),
    phone BIGINT,
    address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150),
    type VARCHAR(50),
    weartype VARCHAR(50),
    price DOUBLE,
    image VARCHAR(255)   -- relative path, e.g. assets/rugs/rug-<uuid>.jpg
);

CREATE TABLE IF NOT EXISTS owner (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    password VARCHAR(200),
    phone BIGINT,
    verify VARCHAR(10) DEFAULT 'no'
);

CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) UNIQUE,
    password VARCHAR(200)
);

-- Ek default admin daal dijiye taaki admin login test kar sakein
INSERT INTO admin (email, password) VALUES ('admin@jcart.com', 'Admin@123')
ON DUPLICATE KEY UPDATE email = email;
