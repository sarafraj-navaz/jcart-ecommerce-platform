package com.jsp.jcart.ecommerce.service;

import java.util.List;

import com.jsp.jcart.ecommerce.dao.ProductDao;
import com.jsp.jcart.ecommerce.dto.Product;

public class ProductService {

	ProductDao dao = new ProductDao();

	/** Naya product insert karta hai aur usse logged-in owner ke saath link karta hai. */
	public Product saveProductService(Product product, int ownerId) {
		return dao.saveProductDaoInsert(product, ownerId);
	}

	/** Home page / all-carpets page ke liye - sirf verified owners ke products. */
	public List<Product> getAllProductsService() {
		return dao.getAllProductData();
	}

	/** Owner dashboard ke liye - sirf isi owner ke products. */
	public List<Product> getProductsForOwnerService(int ownerId) {
		return dao.getProductsByOwnerId(ownerId);
	}

	public Product getProductByIdService(int productId) {
		return dao.getProductById(productId);
	}

	/** Ownership dobara DAO layer par bhi check hoti hai, taaki tampering se koi aur owner ka product edit na ho sake. */
	public boolean updateProductService(Product product, int ownerId, boolean updateImage) {
		return dao.updateProductForOwner(product, ownerId, updateImage);
	}

	/** Ownership DAO layer par check hoti hai - sirf apna hi product delete ho sakta hai. */
	public boolean deleteProductService(int productId, int ownerId) {
		return dao.deleteProductByIdForOwner(productId, ownerId);
	}
}
