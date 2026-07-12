package com.jsp.jcart.ecommerce.service;

import com.jsp.jcart.ecommerce.dao.AdminDao;
import com.jsp.jcart.ecommerce.dto.Admin;

public class AdminService {

	AdminDao dao=new AdminDao();
	
	public Admin adminLoginWithEmailPassService(String adminEmail) {
		
		return dao.adminLoginWithEmailPassDao(adminEmail);
	}
}