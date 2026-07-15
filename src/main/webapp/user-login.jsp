<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | User Login</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    String emailMessage = (String) request.getAttribute("incorrectPassword");
    String passwordMessage = (String) request.getAttribute("incorrectEmail");
    %>

    <div class="auth-page">
        <div class="auth-card">
            <div class="auth-eyebrow">User</div>
            <h2 class="auth-title">Welcome Back</h2>
            <p class="auth-subtitle">Sign in to continue shopping.</p>

            <% if (emailMessage != null) { %>
            <div class="alert alert-error"><%= emailMessage %></div>
            <% } %>
            <% if (passwordMessage != null) { %>
            <div class="alert alert-error"><%= passwordMessage %></div>
            <% } %>

            <form class="auth-form" action="loginUser" method="post">
                <div class="form-group">
                    <label for="userName">Username</label>
                    <input type="text" id="userName" name="userName" placeholder="Your username">
                </div>
                <div class="form-group password-field">
                    <label for="userPassword">Password</label>
                    <input type="password" id="userPassword" name="userPassword" placeholder="At least 8 characters">
                    <button type="button" class="password-toggle">SHOW</button>
                </div>
                <div class="form-group">
                    <label for="dropdown">Login as</label>
                    <select name="dropdown" id="dropdown">
                        <option value="Login with Admin">Login with Admin</option>
                        <option value="Login with Product Owner">Login with Product Owner</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary btn-block">Login</button>
            </form>

            <p class="auth-footer">New here? <a href="user-register.jsp">Create an account</a></p>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
