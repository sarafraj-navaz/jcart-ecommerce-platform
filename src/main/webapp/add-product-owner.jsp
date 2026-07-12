<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Add Product</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <div class="auth-page">
        <div class="auth-card wide">
            <div class="auth-eyebrow">Product Owner</div>
            <h2 class="auth-title">Add a New Product</h2>
            <p class="auth-subtitle">List a new item in your storefront.</p>

            <form class="auth-form" action="add-product-owner" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="productName">Product Name</label>
                    <input type="text" id="productName" name="productName" placeholder="e.g. Classic Denim Jacket">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="productPrice">Price (&#8377;)</label>
                        <input type="number" id="productPrice" name="productPrice" placeholder="0.00">
                    </div>
                    <div class="form-group">
                        <label for="productType">Category</label>
                        <select name="productType" id="productType">
                            <option value="mens">Men</option>
                            <option value="womens">Women</option>
                            <option value="kids">Kids</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="productWearType">Wear Type</label>
                    <select name="productWearType" id="productWearType">
                        <option value="pants">Pants</option>
                        <option value="shirt">Shirts</option>
                        <option value="jeans">Jeans</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="productImageFile">Product Image</label>
                    <input type="file" id="productImageFile" name="productImageFile" accept="image/*" onchange="previewProductImage(event)">
                    <img id="productImagePreview" class="file-preview" style="display:none;max-width:160px;border-radius:8px;margin-top:10px;">
                </div>

                <button type="submit" class="btn btn-primary btn-block">Add Product</button>
            </form>
        </div>
    </div>

    <script src="script.js"></script>
    <script>
        function previewProductImage(event) {
            const file = event.target.files[0];
            const preview = document.getElementById('productImagePreview');
            if (file) {
                preview.src = URL.createObjectURL(file);
                preview.style.display = 'block';
            } else {
                preview.style.display = 'none';
            }
        }
    </script>
</body>
</html>
