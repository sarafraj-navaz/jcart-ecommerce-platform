package com.jsp.jcart.ecommerce.service;

import com.jsp.jcart.ecommerce.dao.ProductDao;
import com.jsp.jcart.ecommerce.dto.Product;

public class ProductService {
	
	
	ProductDao dao = new ProductDao();
	
	/*
	 * insert products items
	 */
	public Product saveProductService(Product product) {
		
		return dao.saveProductDaoInsert(product);
	}

}