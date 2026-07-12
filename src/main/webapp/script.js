/* =========================================================
   J-Cart :: Complete Frontend JavaScript v3.0
   ========================================================= */

document.addEventListener("DOMContentLoaded", function() {
    // Initialize all components
    initNavbar();
    initPasswordToggles();
    initAlerts();
    initConfirmDialogs();
    initFileUploads();
    initParticles();
    initToastSystem();
    initFormValidation();
    initAutoRefresh();
    initKeyboardShortcuts();
    initThemeToggle();
    initCountdownTimers();
    initTooltips();
    initScrollAnimations();
    initButtonRipple();
    initMagneticButtons();
    initTiltCards();
});

/* =========================================================
   NAVBAR
   ========================================================= */
function initNavbar() {
    const nav = document.querySelector('.navbar');
    const toggle = document.querySelector('.navbar-toggle');
    const links = document.querySelector('.navbar-links');

    // Scroll shadow
    window.addEventListener('scroll', function() {
        if (window.scrollY > 10) {
            nav.classList.add('scrolled');
        } else {
            nav.classList.remove('scrolled');
        }
    });

    // Mobile toggle
    if (toggle) {
        toggle.addEventListener('click', function() {
            links.classList.toggle('open');
        });
    }

    // Active link highlighting
    const currentPath = window.location.pathname.split('/').pop() || 'index.jsp';
    document.querySelectorAll('.navbar-links a').forEach(function(link) {
        const href = link.getAttribute('href');
        if (href && href.includes(currentPath)) {
            link.classList.add('active');
        }
    });
}

/* =========================================================
   PASSWORD TOGGLE
   ========================================================= */
function initPasswordToggles() {
    document.querySelectorAll('.password-toggle').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const wrapper = this.closest('.password-field');
            if (!wrapper) return;
            const input = wrapper.querySelector('input[type="password"], input[type="text"]');
            if (!input) return;
            
            const isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';
            this.textContent = isPassword ? 'HIDE' : 'SHOW';
            this.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
        });
    });
}

/* =========================================================
   ALERTS (Auto-dismiss)
   ========================================================= */
function initAlerts() {
    document.querySelectorAll('.alert').forEach(function(alert) {
        setTimeout(function() {
            alert.style.transition = 'all 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function() {
                alert.remove();
            }, 500);
        }, 6000);
    });
}

/* =========================================================
   CONFIRM DIALOGS
   ========================================================= */
function initConfirmDialogs() {
    document.querySelectorAll('[data-confirm]').forEach(function(el) {
        el.addEventListener('click', function(e) {
            const message = this.getAttribute('data-confirm') || 'Are you sure?';
            if (!confirm(message)) {
                e.preventDefault();
                return false;
            }
            
            // Show loading state for buttons
            if (this.classList.contains('btn')) {
                const originalText = this.innerHTML;
                this.innerHTML = '<span class="spinner"></span> Processing...';
                this.classList.add('btn-loading');
                this.disabled = true;
                
                // Re-enable after navigation (if not redirected)
                setTimeout(function() {
                    el.innerHTML = originalText;
                    el.classList.remove('btn-loading');
                    el.disabled = false;
                }, 5000);
            }
        });
    });
}

/* =========================================================
   FILE UPLOAD PREVIEW
   ========================================================= */
function initFileUploads() {
    document.querySelectorAll('.file-field input[type="file"]').forEach(function(input) {
        input.addEventListener('change', function() {
            const wrapper = this.closest('.file-field');
            if (!wrapper) return;
            
            const preview = wrapper.querySelector('.file-preview');
            const label = wrapper.querySelector('.file-label span') || wrapper.querySelector('.file-label');
            
            if (!this.files || !this.files[0]) return;
            
            const file = this.files[0];
            
            // Update label
            if (label) {
                label.textContent = file.name;
            }
            
            // Show preview for images
            if (preview && file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = `<img src="${e.target.result}" alt="Preview">`;
                    preview.style.display = 'flex';
                };
                reader.readAsDataURL(file);
            }
        });
    });
}

/* =========================================================
   PARTICLES (Animated Background)
   ========================================================= */
function initParticles() {
    const container = document.createElement('div');
    container.className = 'particle-container';
    document.body.appendChild(container);
    
    const colors = ['#d4a843', '#e8d48a', '#8899b8', '#2ecc71', '#3498db'];
    const count = 30;
    
    for (let i = 0; i < count; i++) {
        const particle = document.createElement('div');
        particle.className = 'particle';
        particle.style.left = Math.random() * 100 + '%';
        particle.style.width = (Math.random() * 4 + 2) + 'px';
        particle.style.height = particle.style.width;
        particle.style.background = colors[Math.floor(Math.random() * colors.length)];
        particle.style.animationDuration = (Math.random() * 20 + 15) + 's';
        particle.style.animationDelay = (Math.random() * 20) + 's';
        container.appendChild(particle);
    }
}

/* =========================================================
   TOAST SYSTEM
   ========================================================= */
function initToastSystem() {
    // Create toast container if it doesn't exist
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    
    // Make showToast globally available
    window.showToast = function(message, type = 'info', duration = 5000) {
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-exclamation-circle',
            warning: 'fa-exclamation-triangle',
            info: 'fa-info-circle'
        };
        
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <span class="toast-icon"><i class="fas ${icons[type] || icons.info}"></i></span>
            <span class="toast-content">${message}</span>
            <button class="toast-close" aria-label="Dismiss notification">&times;</button>
        `;
        
        container.appendChild(toast);
        
        // Close button
        toast.querySelector('.toast-close').addEventListener('click', function() {
            dismissToast(toast);
        });
        
        // Auto-dismiss
        setTimeout(function() {
            dismissToast(toast);
        }, duration);
        
        return toast;
    };
    
    function dismissToast(toast) {
        toast.style.transition = 'all 0.4s ease';
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(40px) scale(0.95)';
        setTimeout(function() {
            toast.remove();
        }, 400);
    }
    
    // Convert existing alerts to toasts
    document.querySelectorAll('.alert').forEach(function(alert) {
        const type = alert.classList.contains('alert-error') ? 'error' :
                    alert.classList.contains('alert-success') ? 'success' :
                    alert.classList.contains('alert-warning') ? 'warning' : 'info';
        const message = alert.textContent.trim();
        if (message) {
            window.showToast(message, type, 6000);
            alert.remove();
        }
    });
}

/* =========================================================
   FORM VALIDATION
   ========================================================= */
function initFormValidation() {
    document.querySelectorAll('form').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            const inputs = this.querySelectorAll('input[required], select[required], textarea[required]');
            let isValid = true;
            
            inputs.forEach(function(input) {
                if (!input.value.trim()) {
                    isValid = false;
                    input.style.borderColor = 'var(--danger)';
                    input.style.boxShadow = '0 0 0 4px rgba(231, 76, 94, 0.2)';
                    
                    // Show error message
                    const errorMsg = document.createElement('small');
                    errorMsg.style.color = 'var(--danger)';
                    errorMsg.style.fontSize = '11px';
                    errorMsg.style.marginTop = '4px';
                    errorMsg.style.display = 'block';
                    errorMsg.textContent = 'This field is required';
                    
                    const parent = input.closest('.form-group');
                    const existing = parent.querySelector('.field-error');
                    if (existing) existing.remove();
                    parent.appendChild(errorMsg);
                    
                    input.addEventListener('input', function() {
                        this.style.borderColor = '';
                        this.style.boxShadow = '';
                        const err = this.closest('.form-group').querySelector('.field-error');
                        if (err) err.remove();
                    });
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                // Scroll to first error
                const firstError = this.querySelector('input[style*="border-color: var(--danger)"]');
                if (firstError) {
                    firstError.focus();
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });
    });
}

/* =========================================================
   AUTO REFRESH (For dashboard pages)
   ========================================================= */
function initAutoRefresh() {
    // Check if we're on a dashboard page
    if (document.querySelector('.dashboard-page')) {
        // Refresh data every 60 seconds (only if page is visible)
        let refreshInterval = setInterval(function() {
            if (!document.hidden) {
                // Only refresh if there's no pending action
                const loadingBtns = document.querySelectorAll('.btn-loading');
                if (loadingBtns.length === 0) {
                    // Show subtle refresh indicator
                    const indicator = document.querySelector('.refresh-indicator');
                    if (indicator) {
                        indicator.style.opacity = '1';
                        setTimeout(function() {
                            indicator.style.opacity = '0';
                        }, 2000);
                    }
                    // Uncomment to auto-refresh
                    // location.reload();
                }
            }
        }, 60000);
    }
}

/* =========================================================
   KEYBOARD SHORTCUTS
   ========================================================= */
function initKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // Ctrl+Shift+R = Refresh
        if (e.ctrlKey && e.shiftKey && (e.key === 'r' || e.key === 'R')) {
            e.preventDefault();
            location.reload();
        }
        
        // Ctrl+Shift+D = Toggle dark mode (if implemented)
        if (e.ctrlKey && e.shiftKey && (e.key === 'd' || e.key === 'D')) {
            e.preventDefault();
            toggleTheme();
        }
        
        // Ctrl+F = Focus search
        if (e.ctrlKey && (e.key === 'f' || e.key === 'F')) {
            const searchInput = document.querySelector('.search-box input, #searchInput');
            if (searchInput) {
                e.preventDefault();
                searchInput.focus();
                searchInput.select();
            }
        }
        
        // Escape = Close modals / mobile menu
        if (e.key === 'Escape') {
            const mobileMenu = document.querySelector('.navbar-links.open');
            if (mobileMenu) {
                mobileMenu.classList.remove('open');
            }
        }
    });
}

/* =========================================================
   THEME TOGGLE (Dark/Light)
   ========================================================= */
function initThemeToggle() {
    const savedTheme = localStorage.getItem('jcart-theme');
    if (savedTheme === 'dark') {
        document.body.classList.add('dark-mode');
    }
    
    // Create theme toggle if not exists
    const toggleBtn = document.querySelector('.theme-toggle');
    if (toggleBtn) {
        toggleBtn.addEventListener('click', toggleTheme);
    }
}

function toggleTheme() {
    document.body.classList.toggle('dark-mode');
    const isDark = document.body.classList.contains('dark-mode');
    localStorage.setItem('jcart-theme', isDark ? 'dark' : 'light');
    
    const icon = document.querySelector('.theme-toggle i');
    if (icon) {
        icon.className = isDark ? 'fas fa-sun' : 'fas fa-moon';
    }
}

/* =========================================================
   COUNTDOWN TIMERS (For event pages)
   ========================================================= */
function initCountdownTimers() {
    document.querySelectorAll('.countdown').forEach(function(el) {
        const target = new Date(el.getAttribute('data-target')).getTime();
        if (isNaN(target)) return;
        
        function updateCountdown() {
            const now = new Date().getTime();
            const diff = target - now;
            
            if (diff <= 0) {
                el.innerHTML = 'Event Started!';
                return;
            }
            
            const days = Math.floor(diff / (1000 * 60 * 60 * 24));
            const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);
            
            el.innerHTML = `
                <span>${days}d</span>
                <span>${hours}h</span>
                <span>${minutes}m</span>
                <span>${seconds}s</span>
            `;
        }
        
        updateCountdown();
        setInterval(updateCountdown, 1000);
    });
}

/* =========================================================
   TOOLTIPS
   ========================================================= */
function initTooltips() {
    document.querySelectorAll('[data-tooltip]').forEach(function(el) {
        el.addEventListener('mouseenter', function(e) {
            const tooltip = document.createElement('div');
            tooltip.className = 'tooltip-popup';
            tooltip.textContent = this.getAttribute('data-tooltip');
            tooltip.style.cssText = `
                position: fixed;
                background: rgba(10, 22, 40, 0.95);
                color: var(--text-main);
                padding: 6px 14px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
                pointer-events: none;
                z-index: 9999;
                backdrop-filter: blur(8px);
                border: 1px solid rgba(31, 61, 107, 0.3);
                max-width: 300px;
                white-space: nowrap;
            `;
            document.body.appendChild(tooltip);
            
            const rect = this.getBoundingClientRect();
            const tooltipRect = tooltip.getBoundingClientRect();
            
            let top = rect.top - tooltipRect.height - 8;
            let left = rect.left + (rect.width / 2) - (tooltipRect.width / 2);
            
            // Prevent overflow
            if (top < 10) top = rect.bottom + 8;
            if (left < 10) left = 10;
            if (left + tooltipRect.width > window.innerWidth - 10) {
                left = window.innerWidth - tooltipRect.width - 10;
            }
            
            tooltip.style.top = top + 'px';
            tooltip.style.left = left + 'px';
            
            this._tooltip = tooltip;
        });
        
        el.addEventListener('mouseleave', function() {
            if (this._tooltip) {
                this._tooltip.remove();
                this._tooltip = null;
            }
        });
    });
}

/* =========================================================
   SCROLL ANIMATIONS
   ========================================================= */
function initScrollAnimations() {
    const elements = document.querySelectorAll('.animate-on-scroll');
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    });
    
    elements.forEach(function(el) {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'all 0.6s cubic-bezier(0.16, 1, 0.3, 1)';
        observer.observe(el);
    });
}

/* =========================================================
   SEARCH / FILTER (Real-time)
   ========================================================= */
function filterItems(searchInputId, itemSelector) {
    const input = document.getElementById(searchInputId);
    if (!input) return;
    
    input.addEventListener('input', function() {
        const query = this.value.toLowerCase().trim();
        const items = document.querySelectorAll(itemSelector);
        
        items.forEach(function(item) {
            const text = item.textContent.toLowerCase();
            if (query === '' || text.includes(query)) {
                item.style.display = '';
                item.style.animation = 'slideUpFade 0.3s ease both';
            } else {
                item.style.display = 'none';
            }
        });
    });
}

/* =========================================================
   EXPORT DATA (CSV)
   ========================================================= */
function exportToCSV(data, filename = 'export.csv') {
    if (!data || data.length === 0) {
        showToast('No data to export', 'warning');
        return;
    }
    
    const headers = Object.keys(data[0]);
    const rows = data.map(row => headers.map(h => row[h] || '').join(','));
    const csv = [headers.join(','), ...rows].join('\n');
    
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    URL.revokeObjectURL(url);
    
    showToast('Export successful!', 'success');
}

/* =========================================================
   CONSOLE BRANDING
   ========================================================= */
console.log('%c 🏺 J-Cart ', 'font-size:28px; font-weight:bold; background:#d4a843; color:#0a1628; padding:12px 24px; border-radius:12px;');
console.log('%c Luxury E-Commerce Platform v3.0', 'font-size:14px; color:#8899b8;');
console.log('%c Built with ❤️ using JSP & Servlets', 'font-size:12px; color:#8899b8;');
console.log('📦 Features: Dark Mode | Toast Notifications | Live Search | Export CSV | Auto-Refresh | Keyboard Shortcuts');
/* =========================================================
   BUTTON RIPPLE EFFECT
   Adds a Material-style expanding ripple from the exact
   click point on every .btn (works on <button> and <a class="btn">)
   ========================================================= */
function initButtonRipple() {
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.btn');
        if (!btn) return;

        const rect = btn.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height) * 1.8;
        const ripple = document.createElement('span');
        ripple.className = 'btn-ripple';
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = (e.clientX - rect.left - size / 2) + 'px';
        ripple.style.top = (e.clientY - rect.top - size / 2) + 'px';

        btn.appendChild(ripple);
        ripple.addEventListener('animationend', function() {
            ripple.remove();
        });
    });
}

/* =========================================================
   MAGNETIC BUTTONS
   Primary / large / role-link buttons gently follow the
   cursor within their own bounds, then spring back on leave.
   Skipped on touch devices.
   ========================================================= */
function initMagneticButtons() {
    if (!window.matchMedia('(pointer: fine)').matches) return;
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

    const magnets = document.querySelectorAll('.btn-primary, .btn-lg, .role-link, .navbar-brand');

    magnets.forEach(function(el) {
        el.classList.add('magnetic');

        el.addEventListener('mousemove', function(e) {
            const rect = el.getBoundingClientRect();
            const x = e.clientX - rect.left - rect.width / 2;
            const y = e.clientY - rect.top - rect.height / 2;
            const pull = 0.28;
            el.style.setProperty('--mx', (x * pull) + 'px');
            el.style.setProperty('--my', (y * pull) + 'px');
        });

        el.addEventListener('mouseleave', function() {
            el.style.setProperty('--mx', '0px');
            el.style.setProperty('--my', '0px');
        });
    });
}

/* =========================================================
   3D TILT CARDS
   Product cards, role cards and auth cards tilt in 3D
   towards the cursor with a moving light glare on top.
   ========================================================= */
function initTiltCards() {
    if (!window.matchMedia('(pointer: fine)').matches) return;
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

    const cards = document.querySelectorAll('.product-card, .role-card, .auth-card, .about-feature, .about-visual-main');

    cards.forEach(function(card) {
        card.classList.add('tilt-card');

        const glare = document.createElement('div');
        glare.className = 'tilt-glare';
        card.appendChild(glare);

        let frame = null;

        card.addEventListener('mousemove', function(e) {
            const rect = card.getBoundingClientRect();
            const px = (e.clientX - rect.left) / rect.width;   // 0 -> 1
            const py = (e.clientY - rect.top) / rect.height;   // 0 -> 1

            const maxTilt = card.classList.contains('product-card') ? 10 : 6;
            const rotateY = (px - 0.5) * maxTilt * 2;
            const rotateX = (0.5 - py) * maxTilt * 2;

            if (frame) cancelAnimationFrame(frame);
            frame = requestAnimationFrame(function() {
                card.style.setProperty('--rx', rotateX.toFixed(2) + 'deg');
                card.style.setProperty('--ry', rotateY.toFixed(2) + 'deg');
                glare.style.background =
                    'radial-gradient(circle at ' + (px * 100) + '% ' + (py * 100) + '%, rgba(255,255,255,0.22), transparent 55%)';
            });
        });

        card.addEventListener('mouseleave', function() {
            card.style.setProperty('--rx', '0deg');
            card.style.setProperty('--ry', '0deg');
            glare.style.background = 'transparent';
        });
    });
}

