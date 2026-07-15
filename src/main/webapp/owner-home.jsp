<%@page import="com.jsp.jcart.ecommerce.dto.Product"%>
<%@page import="com.jsp.jcart.ecommerce.service.ProductService"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Owner Dashboard</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    // AuthFilter isko already ensure kar chuka hai ki session mein ownerId maujood hai,
    // lekin defensive coding ke liye yahan bhi dobara check kar rahe hain.
    Integer ownerIdObj = (Integer) session.getAttribute("ownerId");
    int ownerId = ownerIdObj == null ? 0 : ownerIdObj;
    String ownerName = (String) session.getAttribute("ownerName");
    if (ownerName == null) ownerName = "there";

    java.util.List<Product> products = new ProductService().getProductsForOwnerService(ownerId);
    int productCount = products == null ? 0 : products.size();
    %>

    <div class="dashboard-page">
        <div class="dashboard-content">
            <div class="dashboard-hero">
                <div class="dashboard-hero-left">
                    <div class="dashboard-hero-icon">
                        <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    </div>
                    <div>
                        <div class="auth-eyebrow">Product Owner</div>
                        <h2>Welcome back, <%= ownerName %></h2>
                        <p class="subtitle">Manage only the products you have listed on J-Cart.</p>
                    </div>
                </div>
                <div class="dashboard-hero-actions">
                    <a class="btn btn-primary" href="add-product-owner.jsp">+ Add Product</a>
                    <a class="btn btn-danger" href="logout" data-confirm="Log out of your storefront?">Logout</a>
                </div>
            </div>

            <div class="stat-grid">
                <div class="stat-card">
                    <div class="stat-label">Your Products Listed</div>
                    <div class="stat-value"><%= productCount %></div>
                </div>
            </div>

            <div class="section">
                <div class="section-title">
                    <span class="eyebrow-dot"></span>
                    Your Products
                </div>
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Photo</th>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Type</th>
                                <th>Wear Type</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (products == null || products.isEmpty()) { %>
                            <tr class="empty-row"><td colspan="8">You haven't added any products yet. Click "+ Add Product" to list your first carpet.</td></tr>
                            <% } else {
                                for (Product product : products) {
                                    int swatch = (product.getProductId() % 5) + 1;
                            %>
                            <tr>
                                <td>
                                    <div style="width:44px;height:44px;border-radius:8px;overflow:hidden;position:relative;">
                                        <img src="<%= product.getImagePath() %>" alt="<%= product.getProductName() %>"
                                             style="width:100%;height:100%;object-fit:cover;display:block;"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <div class="rug-swatch rug-swatch-<%= swatch %>" style="display:none;">
                                            <span class="rug-fringe top"></span>
                                            <span class="rug-fringe"></span>
                                        </div>
                                    </div>
                                </td>
                                <td><%= product.getProductId() %></td>
                                <td><%= product.getProductName() %></td>
                                <td><%= product.getProductType() %></td>
                                <td><%= product.getProductWearType() %></td>
                                <td>&#8377; <%= product.getProductPrice() %></td>
                                <td><span class="badge badge-success">live</span></td>
                                <td class="action-cell">
                                    <a class="btn btn-outline btn-sm" href="edit-product-owner?id=<%= product.getProductId() %>">
                                        <i class="fas fa-pen"></i> Edit
                                    </a>
                                    <a class="btn btn-danger btn-sm"
                                       href="delete-product-owner?id=<%= product.getProductId() %>"
                                       data-confirm="Delete &quot;<%= product.getProductName() %>&quot;? This cannot be undone.">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
