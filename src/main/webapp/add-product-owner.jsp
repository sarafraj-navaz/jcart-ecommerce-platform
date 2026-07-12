<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>J-Cart | Add Product</title>
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
    .type-badge {
        display: inline-block;
        font-size: 11px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        padding: 4px 10px;
        border-radius: 20px;
        background: #f0f4ff;
        color: #2a5cff;
        margin-top: 4px;
    }
    .field-hint {
        font-size: 12px;
        color: #888;
        margin-top: 4px;
    }
</style>
</head>
<body>
    <jsp:include page="home-buttom.jsp"></jsp:include>

    <div class="auth-page">
        <div class="auth-card wide">
            <div class="auth-eyebrow">Product Owner</div>
            <h2 class="auth-title">Add a New Product</h2>
            <p class="auth-subtitle">List a new item in your storefront.</p>

            <form class="auth-form" action="add-product-owner" method="post" enctype="multipart/form-data">
                
                <!-- Product Name -->
                <div class="form-group">
                    <label for="productName">Product Name <span style="color:#e74c3c;">*</span></label>
                    <input type="text" id="productName" name="productName" placeholder="e.g. Moroccan Sunset Medallion Rug" required>
                </div>

                <!-- Type & Price -->
                <div class="form-row-3">
                    <div class="form-group">
                        <label for="productType">Type <span style="color:#e74c3c;">*</span></label>
                        <select name="productType" id="productType" required>
                            <option value="">Select Type</option>
                            <option value="Living Room">Living Room</option>
                            <option value="Bedroom">Bedroom</option>
                            <option value="Dining Room">Dining Room</option>
                            <option value="Hallway">Hallway</option>
                            <option value="Outdoor">Outdoor</option>
                            <option value="Office">Office</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="productWearType">Wear Type / Style <span style="color:#e74c3c;">*</span></label>
                        <select name="productWearType" id="productWearType" required>
                            <option value="">Select Style</option>
                            <option value="Persian">Persian</option>
                            <option value="Modern Geometric">Modern Geometric</option>
                            <option value="Handwoven Wool">Handwoven Wool</option>
                            <option value="Landscaping Material">Landscaping Material</option>
                            <option value="Traditional">Traditional</option>
                            <option value="Contemporary">Contemporary</option>
                            <option value="Bohemian">Bohemian</option>
                            <option value="Vintage">Vintage</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="productPrice">Price (₹) <span style="color:#e74c3c;">*</span></label>
                        <div class="price-input-wrapper">
                            <span class="currency-symbol">₹</span>
                            <input type="number" id="productPrice" name="productPrice" placeholder="0.00" step="0.01" min="0" required>
                        </div>
                        <div class="field-hint">Price in Indian Rupees</div>
                    </div>
                </div>

                <!-- Image Upload -->
                <div class="form-group">
                    <label for="productImageFile">Product Image <span style="color:#e74c3c;">*</span></label>
                    <input type="file" id="productImageFile" name="productImageFile" accept="image/*" onchange="previewProductImage(event)" required>
                    <div id="imagePreviewContainer" style="margin-top:12px;display:none;">
                        <img id="productImagePreview" style="max-width:160px;border-radius:12px;border:2px solid #e9ecef;padding:4px;">
                        <button type="button" onclick="clearImage()" style="display:inline-block;margin-left:12px;background:#fee;border:1px solid #f5c6cb;color:#721c24;padding:4px 12px;border-radius:6px;cursor:pointer;font-size:13px;">Remove</button>
                    </div>
                    <div class="field-hint">Upload a clear product image (JPG, PNG, WebP)</div>
                </div>

                <!-- Hidden field for image path (will be set by server) -->
                <input type="hidden" name="productImage" id="productImage" value="">

                <button type="submit" class="btn btn-primary btn-block">Add Product</button>
            </form>

            <!-- Quick reference to database fields -->
            <div style="margin-top:20px;padding-top:16px;border-top:1px solid #e9ecef;">
                <div style="display:flex;flex-wrap:wrap;gap:8px;font-size:12px;color:#888;">
                    <span class="type-badge">id</span>
                    <span class="type-badge">name</span>
                    <span class="type-badge">type</span>
                    <span class="type-badge">wear type</span>
                    <span class="type-badge">price</span>
                    <span class="type-badge">image</span>
                </div>
                <div style="font-size:11px;color:#aaa;margin-top:6px;">
                    ⚡ Fields match your database: <strong>id, name, type, wearytype, price, image</strong>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
    <script>
        function previewProductImage(event) {
            const file = event.target.files[0];
            const preview = document.getElementById('productImagePreview');
            const container = document.getElementById('imagePreviewContainer');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    container.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                container.style.display = 'none';
            }
        }

        function clearImage() {
            const fileInput = document.getElementById('productImageFile');
            const preview = document.getElementById('productImagePreview');
            const container = document.getElementById('imagePreviewContainer');
            
            fileInput.value = '';
            preview.src = '';
            container.style.display = 'none';
        }

        // Optional: Auto-suggest filename format for image path
        document.getElementById('productName').addEventListener('input', function() {
            // This is just a visual hint - the server will handle actual path
            const name = this.value.trim();
            if (name) {
                const slug = name.toLowerCase().replace(/[^a-z0-9]+/g, '-');
                document.querySelector('.field-hint:last-child').textContent = 
                    '📁 Suggested image path: assets/rugs/' + slug + '.jpeg';
            }
        });
    </script>
</body>
</html>