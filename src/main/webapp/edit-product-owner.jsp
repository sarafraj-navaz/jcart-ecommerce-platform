<%@page import="com.jsp.jcart.ecommerce.dto.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Edit Product</title>
<link rel="stylesheet" href="style.css">
<style>
    .form-row-3 {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 16px;
    }
    @media (max-width: 768px) {
        .form-row-3 {
            grid-template-columns: 1fr;
        }
    }
    .price-input-wrapper {
        position: relative;
    }
    .price-input-wrapper input {
        padding-left: 28px;
    }
    .price-input-wrapper .currency-symbol {
        position: absolute;
        left: 10px;
        top: 50%;
        transform: translateY(-50%);
        font-weight: 600;
        color: #555;
    }
    .field-hint {
        font-size: 12px;
        color: #888;
        margin-top: 4px;
    }
    .current-image-preview {
        display: flex;
        align-items: center;
        gap: 14px;
        margin-bottom: 10px;
    }
    .current-image-preview img {
        width: 72px;
        height: 72px;
        object-fit: cover;
        border-radius: 10px;
        border: 2px solid rgba(31,61,107,0.2);
    }
</style>
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <%
    Product product = (Product) request.getAttribute("product");
    // Yeh case normally nahi aana chahiye (EditProductController pehle hi check kar chuka hai),
    // lekin defensive coding ke liye yahan bhi rakha hai.
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/owner-home.jsp");
        return;
    }
    %>

    <div class="auth-page">
        <div class="auth-card wide">
            <div class="auth-eyebrow">Product Owner</div>
            <h2 class="auth-title">Edit Product</h2>
            <p class="auth-subtitle">Update the details of "<%= product.getProductName() %>".</p>

            <form class="auth-form" action="edit-product-owner" method="post" enctype="multipart/form-data">

                <input type="hidden" name="productId" value="<%= product.getProductId() %>">

                <!-- Product Name -->
                <div class="form-group">
                    <label for="productName">Product Name <span style="color:#e74c3c;">*</span></label>
                    <input type="text" id="productName" name="productName" value="<%= product.getProductName() %>" required>
                </div>

                <!-- Type & Price -->
                <div class="form-row-3">
                    <div class="form-group">
                        <label for="productType">Type <span style="color:#e74c3c;">*</span></label>
                        <select name="productType" id="productType" required>
                            <%
                            String[] types = { "Living Room", "Bedroom", "Dining Room", "Hallway", "Outdoor", "Office" };
                            for (String t : types) {
                                String selected = t.equalsIgnoreCase(product.getProductType()) ? "selected" : "";
                            %>
                            <option value="<%= t %>" <%= selected %>><%= t %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="productWearType">Wear Type / Style <span style="color:#e74c3c;">*</span></label>
                        <select name="productWearType" id="productWearType" required>
                            <%
                            String[] wearTypes = { "Persian", "Modern Geometric", "Handwoven Wool",
                                    "Landscaping Material", "Traditional", "Contemporary", "Bohemian", "Vintage" };
                            for (String w : wearTypes) {
                                String selected = w.equalsIgnoreCase(product.getProductWearType()) ? "selected" : "";
                            %>
                            <option value="<%= w %>" <%= selected %>><%= w %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="productPrice">Price (₹) <span style="color:#e74c3c;">*</span></label>
                        <div class="price-input-wrapper">
                            <span class="currency-symbol">₹</span>
                            <input type="number" id="productPrice" name="productPrice" step="0.01" min="0"
                                   value="<%= product.getProductPrice() %>" required>
                        </div>
                    </div>
                </div>

                <!-- Current Image + Replace -->
                <div class="form-group">
                    <label>Current Image</label>
                    <div class="current-image-preview">
                        <img src="<%= product.getImagePath() %>" alt="<%= product.getProductName() %>"
                             onerror="this.style.display='none';">
                        <span class="field-hint">Leave the field below empty to keep this image.</span>
                    </div>
                    <label for="productImageFile">Replace Image (optional)</label>
                    <input type="file" id="productImageFile" name="productImageFile" accept="image/*">
                </div>

                <div style="display:flex;gap:12px;">
                    <button type="submit" class="btn btn-primary btn-block">Save Changes</button>
                    <a class="btn btn-outline btn-block" href="owner-home.jsp" style="text-align:center;">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>
