<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.jsp.jcart.ecommerce.dto.Product"%>
<%@page import="com.jsp.jcart.ecommerce.dao.ProductDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>J-Cart · Luxury Carpets & Rugs</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

    <jsp:include page="home-buttom.jsp" />

    <%
    ProductDao productDao = new ProductDao();
    List<Product> products = productDao.getAllProductData();
    String[] rugAlt = {
        "Hand-knotted Persian medallion rug",
        "Modern geometric wool rug",
        "Heritage floral border carpet",
        "Contemporary abstract weave",
        "Classic vintage-inspired rug"
    };
    %>

    <div class="shop-wrap">
        <!-- Hero Section -->
        <div class="shop-hero">
            <div class="auth-eyebrow"><i class="fas fa-arrow-right" style="font-size:0.5rem;margin-right:6px;"></i> J-Cart Home &amp; Living</div>
            <h1>Carpets Woven for <span style="color:var(--gold);">Modern Luxury</span></h1>
            <p>Hand-finished rugs and carpets, crafted with premium materials and timeless pattern work — sourced from verified makers on J-Cart.</p>

            <div class="hero-stats">
                <div class="stat-item">
                    <div class="stat-number">250+</div>
                    <div class="stat-label">Handcrafted Rugs</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">12</div>
                    <div class="stat-label">Artisan Partners</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">4.9★</div>
                    <div class="stat-label">Average Rating</div>
                </div>
            </div>
        </div>

        <!-- Product Section -->
        <%
        int totalProductCount = (products == null) ? 0 : products.size();
        int featuredLimit = 16; // Home page par max 16 cards; mobile CSS inme se sirf pehli 8 dikhayega
        List<Product> featuredProducts = (products == null) ? products
                : (products.size() > featuredLimit ? products.subList(0, featuredLimit) : products);
        %>
        <div class="section-header">
            <div class="section-title">
                <span class="eyebrow-dot"></span>
                Featured Collection
            </div>
            <a href="all-carpets.jsp" class="role-link" style="width:auto;padding:6px 16px;font-size:12px;">
                View All (<%= totalProductCount %>) <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <% if (products == null || products.isEmpty()) { %>
            <div class="empty-state">
                <span class="empty-icon"><i class="fas fa-rug"></i></span>
                <p style="font-size:1.1rem;font-weight:500;">New pieces are being added to the collection.</p>
                <p style="font-size:0.9rem;opacity:0.7;">Check back shortly for our latest arrivals.</p>
            </div>
        <% } else { %>
            <div class="product-grid">
                <%
                int cardIndex = 0;
                for (Product product : featuredProducts) {
                    cardIndex++;
                    boolean hasStaticPhoto = product.getImagePath() != null && !product.getImagePath().trim().isEmpty();
                    String imgSrc = hasStaticPhoto ? product.getImagePath() : ("photo?id=" + product.getProductId());

                    String badgeClass = "";
                    String badgeText = "";
                    if (product.getProductId() % 3 == 0) {
                        badgeClass = "new";
                        badgeText = "New Arrival";
                    } else if (product.getProductId() % 5 == 0) {
                        badgeClass = "limited";
                        badgeText = "Limited";
                    }

                    String productType = product.getProductWearType() != null ? product.getProductWearType() : "Handwoven";
                    int reviews = (product.getProductId() % 20) + 12;
                    long price = (long) product.getProductPrice();

                    String waMessage = "Hi J-Cart! I'm interested in the \"" + product.getProductName()
                            + "\" (" + productType + ") priced at Rs. " + price + ". Please share more details.";
                    String waLink = "https://wa.me/917617809982?text=" + URLEncoder.encode(waMessage, "UTF-8");
                %>
                <div class="product-card"
                     style="--i: <%= cardIndex %>;"
                     data-name="<%= product.getProductName() %>"
                     data-type="<%= productType %>"
                     data-price="<%= price %>"
                     data-img="<%= imgSrc %>"
                     data-reviews="<%= reviews %>"
                     data-badge="<%= badgeText %>"
                     data-wa="<%= waLink %>">
                    <div class="product-media">
                        <img src="<%= imgSrc %>"
                             alt="<%= product.getProductName() %>"
                             loading="lazy"
                             onerror="this.style.display='none'; this.parentElement.querySelector('.fallback-swatch').style.display='flex';">
                        <div class="fallback-swatch" style="display:none;width:100%;height:100%;background:linear-gradient(135deg, #2d4a6b, #1a2d44);align-items:center;justify-content:center;font-size:3rem;color:var(--gold);">
                            <i class="fas fa-rug"></i>
                        </div>
                        <% if (!badgeText.isEmpty()) { %>
                            <span class="product-badge <%= badgeClass %>"><%= badgeText %></span>
                        <% } %>
                        <span class="product-view-hint"><i class="fas fa-expand"></i> View Details</span>
                    </div>
                    <div class="product-overlay">
                        <div class="product-type"><%= productType %></div>
                        <div class="product-name"><%= product.getProductName() %></div>
                        <div class="product-rating">
                            <span class="stars">★★★★★</span>
                            <span>(<%= reviews %> reviews)</span>
                        </div>
                        <div class="product-footer">
                            <div class="product-price">&#8377;<%= price %><span class="price-unit">/piece</span></div>
                            <a class="btn btn-primary btn-sm whatsapp-add" href="<%= waLink %>" target="_blank" rel="noopener" onclick="event.stopPropagation();">
                                <i class="fab fa-whatsapp"></i> Add
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>

            <div style="text-align:center;margin-top:36px;">
                <a href="all-carpets.jsp" class="btn btn-outline" style="padding:0.7rem 2rem;">
                    Browse All Carpets <i class="fas fa-arrow-right" style="margin-left:8px;"></i>
                </a>
            </div>
        <% } %>
    </div>

    <!-- About Us Section -->
    <div id="about" class="about-section" style="max-width:1100px;margin:70px auto 0;padding:0 20px;scroll-margin-top:90px;">
        <div class="section-header" style="justify-content:center;text-align:center;flex-direction:column;gap:6px;">
            <div class="section-title" style="justify-content:center;">
                <span class="eyebrow-dot"></span>
                About J-Cart
            </div>
        </div>

        <div class="about-grid">
            <div class="about-copy">
                <h2>Woven by Artisans, Delivered with Care</h2>
                <p>
                    J-Cart started with a simple idea: bring genuine, hand-finished carpets and rugs from
                    India's skilled weavers straight to your home, without the usual retail markup. Every
                    piece on our platform is sourced directly from verified product owners &mdash; the
                    artisans and workshops who actually make them.
                </p>
                <p>
                    We personally verify every product owner before their carpets go live, so you always
                    know what you're buying and who you're buying it from. No middlemen, no guesswork
                    &mdash; just quality rugs at fair prices, with a real person on WhatsApp if you have
                    a question.
                </p>
                <div class="hero-stats">
                    <div class="stat-item">
                        <div class="stat-number">250+</div>
                        <div class="stat-label">Handcrafted Rugs</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">12</div>
                        <div class="stat-label">Artisan Partners</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">4.9★</div>
                        <div class="stat-label">Average Rating</div>
                    </div>
                </div>
            </div>

            <div class="about-visual">
                <div class="about-visual-badge">
                    <i class="fas fa-certificate"></i>
                    <div>
                        <div class="num">100%</div>
                        <div class="label">Verified Makers</div>
                    </div>
                </div>
                <div class="about-visual-main">
                    <img src="assets/rugs/rug1.jpeg" alt="Hand-knotted carpet in a living room" loading="lazy">
                </div>
                <div class="about-visual-accent">
                    <img src="assets/rugs/rug14.jpg" alt="Close-up of handwoven rug pattern" loading="lazy">
                </div>
            </div>
        </div>

        <div class="about-features">
            <div class="about-feature">
                <div class="about-feature-icon"><i class="fas fa-hand-holding-heart"></i></div>
                <div>
                    <h3>Our Mission</h3>
                    <p>Make authentic, artisan-made carpets accessible and affordable for every home in India.</p>
                </div>
            </div>
            <div class="about-feature">
                <div class="about-feature-icon"><i class="fas fa-award"></i></div>
                <div>
                    <h3>Quality First</h3>
                    <p>Every product owner is verified by our admin team before their listings go live.</p>
                </div>
            </div>
            <div class="about-feature">
                <div class="about-feature-icon"><i class="fas fa-people-carry"></i></div>
                <div>
                    <h3>Direct Support</h3>
                    <p>Talk to us directly on call or WhatsApp &mdash; no ticket queues, no chatbots.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Contact Section -->
    <div id="contact" class="contact-section" style="max-width:1100px;margin:70px auto 0;padding:0 20px;scroll-margin-top:90px;">
        <div class="section-header" style="justify-content:center;text-align:center;flex-direction:column;gap:6px;">
            <div class="section-title" style="justify-content:center;">
                <span class="eyebrow-dot"></span>
                Contact Us
            </div>
        </div>
        <p style="text-align:center;color:var(--text-muted);max-width:500px;margin:12px auto 30px;">
            Questions about an order, a specific rug, or becoming a product owner? Reach out &mdash; we
            usually reply within a few hours.
        </p>

        <div class="role-grid">
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-phone"></i></div>
                <p class="role-name">Call Us</p>
                <p class="role-desc">Mon&ndash;Sat, 10 AM &ndash; 7 PM IST</p>
                <a class="role-link" href="tel:+917617809982">+91 76178 09982 <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="role-card">
                <div class="role-icon"><i class="fab fa-whatsapp"></i></div>
                <p class="role-name">WhatsApp</p>
                <p class="role-desc">Fastest way to ask about a specific carpet or order status.</p>
                <a class="role-link" href="https://wa.me/917617809982?text=<%= URLEncoder.encode("Hi J-Cart! I have a question.", "UTF-8") %>" target="_blank" rel="noopener">Chat with Us <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-envelope"></i></div>
                <p class="role-name">Email</p>
                <p class="role-desc">For detailed queries, bulk orders, or partnerships.</p>
                <a class="role-link" href="mailto:sarafrajnavaz.hmfa@gmail.com">sarafrajnavaz.hmfa@gmail.com <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-map-marker-alt"></i></div>
                <p class="role-name">Address</p>
                <p class="role-desc">Uttar Pradesh, India<br>Ships pan-India</p>
            </div>
        </div>
    </div>

    <!-- Portal Section -->
    <div class="portal-section" style="max-width:1100px;margin:60px auto 0;text-align:center;padding:0 20px 20px;">
        <div class="auth-eyebrow"><i class="fas fa-lock" style="margin-right:6px;"></i> Secure Access Portal</div>
        <h2 style="font-family:var(--font-display);font-size:clamp(1.6rem,3vw,2.4rem);font-weight:700;color:var(--text-main);margin-bottom:8px;">Manage Your J-Cart Account</h2>
        <p style="color:var(--text-muted);font-size:1rem;max-width:500px;margin:0 auto 40px;">Sign in as an Admin, Buyer, or Product Owner to continue.</p>

        <div class="role-grid">
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-shield-alt"></i></div>
                <p class="role-name">Admin</p>
                <p class="role-desc">Manage users, verify product owners, and configure system-wide settings.</p>
                <a class="role-link" href="admin-login.jsp">Sign in as Admin <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-user-circle"></i></div>
                <p class="role-name">Buyer</p>
                <p class="role-desc">Browse the collection, manage your account, and shop with ease.</p>
                <a class="role-link" href="user-login.jsp">Sign in as Buyer <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="role-card">
                <div class="role-icon"><i class="fas fa-store"></i></div>
                <p class="role-name">Product Owner</p>
                <p class="role-desc">List carpets, track verification status, and manage your storefront.</p>
                <a class="role-link" href="owner-login.jsp">Sign in as Owner <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
    </div>

    <!-- Product Detail Modal -->
    <div class="product-modal-backdrop" id="productModalBackdrop" onclick="closeProductModal(event)">
        <div class="product-modal" onclick="event.stopPropagation();">
            <button class="modal-close" onclick="closeProductModal(event)" aria-label="Close"><i class="fas fa-times"></i></button>
            <div class="modal-media">
                <img id="modalImg" src="" alt="" onclick="openImageLightbox();">
                <span class="product-badge" id="modalBadge"></span>
            </div>
            <div class="modal-body">
                <div class="product-type" id="modalType"></div>
                <h2 id="modalName"></h2>
                <div class="product-rating">
                    <span class="stars">★★★★★</span>
                    <span id="modalReviews"></span>
                </div>
                <div class="modal-price" id="modalPrice"></div>
                <p class="modal-desc">Hand-finished with premium materials and timeless pattern work — sourced from verified artisan makers on J-Cart. Sign in to add this piece to your cart, or reach out directly below.</p>

                <div class="modal-actions">
                    <a id="modalWaBtn" class="btn btn-primary" href="#" target="_blank" rel="noopener">
                        <i class="fab fa-whatsapp"></i> Order via WhatsApp
                    </a>
                    <a href="user-login.jsp" class="btn btn-outline">
                        <i class="fas fa-shopping-cart"></i> Sign In to Buy
                    </a>
                </div>

                <div class="modal-contact">
                    <div class="auth-eyebrow" style="margin-bottom:12px;"><i class="fas fa-headset" style="margin-right:6px;"></i> Need Help? Contact Us</div>
                    <a class="contact-line" href="tel:+917617809982"><i class="fas fa-phone"></i> +91 76178 09982</a>
                    <a class="contact-line" href="mailto:sarafrajnavaz.hmfa@gmail.com"><i class="fas fa-envelope"></i> sarafrajnavaz.hmfa@gmail.com</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Fullscreen Image Lightbox -->
    <div class="image-lightbox-backdrop" id="imageLightboxBackdrop" onclick="closeImageLightbox();">
        <button class="image-lightbox-close" onclick="closeImageLightbox(); event.stopPropagation();" aria-label="Close"><i class="fas fa-times"></i></button>
        <img id="lightboxImg" src="" alt="">
    </div>

    <!-- Footer -->
    <footer class="page-footer">
        <div class="social-icons">
            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
            <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            <a href="#" aria-label="Twitter"><i class="fab fa-x-twitter"></i></a>
            <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
            <a href="#" aria-label="Pinterest"><i class="fab fa-pinterest-p"></i></a>
        </div>
        <div class="footer-links">
            <a href="#about">About Us</a>
            <a href="#contact">Contact</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Shipping &amp; Returns</a>
        </div>
        <p>&copy; <%= java.time.Year.now() %> J-Cart. All rights reserved. Crafted with <i class="fas fa-heart" style="color:var(--gold);font-size:0.7rem;"></i> in India</p>
    </footer>

    <script src="script.js"></script>
    <script>
        // Product detail modal
        function openProductModal(card) {
            document.getElementById('modalImg').src = card.dataset.img;
            document.getElementById('modalImg').alt = card.dataset.name;
            document.getElementById('modalType').textContent = card.dataset.type;
            document.getElementById('modalName').textContent = card.dataset.name;
            document.getElementById('modalReviews').textContent = '(' + card.dataset.reviews + ' reviews)';
            document.getElementById('modalPrice').innerHTML = '&#8377;' + card.dataset.price + '<span class="price-unit">/piece</span>';
            document.getElementById('modalWaBtn').href = card.dataset.wa;

            const badgeEl = document.getElementById('modalBadge');
            if (card.dataset.badge) {
                badgeEl.textContent = card.dataset.badge;
                badgeEl.style.display = 'inline-block';
                badgeEl.className = 'product-badge ' + (card.dataset.badge === 'New Arrival' ? 'new' : 'limited');
            } else {
                badgeEl.style.display = 'none';
            }

            document.getElementById('productModalBackdrop').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeProductModal(e) {
            document.getElementById('productModalBackdrop').classList.remove('active');
            document.body.style.overflow = '';
        }

        // Fullscreen image lightbox
        function openImageLightbox() {
            const src = document.getElementById('modalImg').src;
            const alt = document.getElementById('modalImg').alt;
            document.getElementById('lightboxImg').src = src;
            document.getElementById('lightboxImg').alt = alt;
            document.getElementById('imageLightboxBackdrop').classList.add('active');
        }

        function closeImageLightbox() {
            document.getElementById('imageLightboxBackdrop').classList.remove('active');
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.product-card').forEach(function(card) {
                card.addEventListener('click', function() {
                    openProductModal(card);
                });
            });
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeImageLightbox();
                closeProductModal(e);
            }
        });

        // Initialize search filter on product cards
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.createElement('input');
            searchInput.type = 'text';
            searchInput.placeholder = 'Search products...';
            searchInput.className = 'search-input';
            searchInput.style.cssText = `
                width: 100%;
                max-width: 300px;
                padding: 8px 16px;
                border-radius: 8px;
                border: 1px solid var(--navy-line);
                background: rgba(10, 22, 40, 0.6);
                color: var(--text-main);
                font-size: 14px;
                margin-bottom: 20px;
            `;
            
            const header = document.querySelector('.section-header');
            if (header) {
                header.style.flexWrap = 'wrap';
                header.appendChild(searchInput);
            }
            
            searchInput.addEventListener('input', function() {
                const query = this.value.toLowerCase().trim();
                document.querySelectorAll('.product-card').forEach(function(card) {
                    const name = card.querySelector('.product-name')?.textContent?.toLowerCase() || '';
                    const type = card.querySelector('.product-type')?.textContent?.toLowerCase() || '';
                    if (query === '' || name.includes(query) || type.includes(query)) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    </script>
</body>
</html>