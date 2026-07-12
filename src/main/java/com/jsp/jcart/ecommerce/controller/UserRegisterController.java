package com.jsp.jcart.ecommerce.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.jsp.jcart.ecommerce.dto.User;
import com.jsp.jcart.ecommerce.service.UserService;
import com.jsp.jcart.ecommerce.util.SheetsLogger;

@WebServlet(value = "/userRegister")
public class UserRegisterController extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String name =req.getParameter("userName");
		String email =req.getParameter("userEmail");
		Long phone =Long.parseLong(req.getParameter("userPhone"));
		String password =req.getParameter("userPassword");
		String address =req.getParameter("userAddress");
		
		
		UserService service =  new UserService();
		
		User user= service.saveUserService(new User(name,email,phone,password,address));
		
		if(user != null) {
			
			SheetsLogger.logRegistrationAsync(name, email, String.valueOf(phone), address);
		 	req.getRequestDispatcher("user-login.jsp").forward(req, resp);
		}
		else {
			
			req.setAttribute("passwordMessage","please redesign password again");
			req.getRequestDispatcher("user-register.jsp").forward(req, resp);
		}
				
	}
}