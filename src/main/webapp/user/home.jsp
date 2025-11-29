<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.ProductServiceInterface" %>
<%@ page import="com.ecommerce.soap.CategoryServiceInterface" %>
<%@ page import="com.ecommerce.soap.CartServiceInterface" %>
<%@ page import="com.ecommerce.model.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.util.List" %>

<%
// Check if user is logged in
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../index.jsp");
    return;
}

String username = (String) session.getAttribute("username");
String fullName = (String) session.getAttribute("fullName");
Integer userId = (Integer) session.getAttribute("userId");

// Get products and categories
List<Product> products = null;
List<Category> categories = null;
int cartCount = 0;

try {
    // Get ProductService
    URL productUrl = new URL("http://localhost:8080/EcommerceSOAP/services/ProductService?wsdl");
    QName productQname = new QName("http://soap.ecommerce.com/", "ProductService");
    Service productService = Service.create(productUrl, productQname);
    ProductServiceInterface productSoap = productService.getPort(ProductServiceInterface.class);
    
    // Get CategoryService
    URL categoryUrl = new URL("http://localhost:8080/EcommerceSOAP/services/CategoryService?wsdl");
    QName categoryQname = new QName("http://soap.ecommerce.com/", "CategoryService");
    Service categoryService = Service.create(categoryUrl, categoryQname);
    CategoryServiceInterface categorySoap = categoryService.getPort(CategoryServiceInterface.class);
    
    // Get CartService
    URL cartUrl = new URL("http://localhost:8080/EcommerceSOAP/services/CartService?wsdl");
    QName cartQname = new QName("http://soap.ecommerce.com/", "CartService");
    Service cartService = Service.create(cartUrl, cartQname);
    CartServiceInterface cartSoap = cartService.getPort(CartServiceInterface.class);
    
    products = productSoap.getAllProducts();
    categories = categorySoap.getAllCategories();
    cartCount = cartSoap.getCartItemCount(userId);
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shop - E-Commerce</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar h1 {
            font-size: 24px;
        }
        
        .navbar-menu {
            display: flex;
            gap: 20px;
            align-items: center;
        }
        
        .navbar-menu a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .navbar-menu a:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .cart-badge {
            background: #ff4757;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            margin-left: 5px;
        }
        
        .welcome {
            font-size: 14px;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .filters {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .filters h3 {
            margin-bottom: 15px;
            color: #333;
        }
        
        .category-btn {
            display: inline-block;
            padding: 8px 15px;
            margin: 5px;
            background: #f0f0f0;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .category-btn:hover {
            background: #667eea;
            color: white;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .product-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
        }
        
        .product-image {
            width: 100%;
            height: 200px;
            background: #f0f0f0;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 48px;
        }
        
        .product-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .product-price {
            font-size: 24px;
            color: #667eea;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .product-stock {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }
        
        .btn-add-cart {
            width: 100%;
            padding: 10px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
        }
        
        .btn-add-cart:hover {
            background: #764ba2;
        }
        
        .btn-add-cart:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🛒 E-Commerce</h1>
        <div class="navbar-menu">
            <span class="welcome">Welcome, <%= fullName %>!</span>
            <a href="home.jsp">Shop</a>
            <a href="cart.jsp">Cart <span class="cart-badge"><%= cartCount %></span></a>
            <a href="orders.jsp">My Orders</a>
            <a href="profile.jsp">Profile</a>
            <a href="../logout.jsp">Logout</a>
        </div>
    </nav>
    
    <div class="container">
        <div class="filters">
            <h3>Categories</h3>
            <a href="home.jsp"><button class="category-btn">All Products</button></a>
            <% if (categories != null) {
                for (Category category : categories) { %>
                    <a href="home.jsp?categoryId=<%= category.getCategoryId() %>">
                        <button class="category-btn"><%= category.getCategoryName() %></button>
                    </a>
            <%  }
            } %>
        </div>
        
        <div class="products-grid">
            <% if (products != null && !products.isEmpty()) {
                for (Product product : products) { %>
                    <div class="product-card">
                        <div class="product-image">📦</div>
                        <div class="product-name"><%= product.getProductName() %></div>
                        <div class="product-price">$<%= String.format("%.2f", product.getPrice()) %></div>
                        <div class="product-stock">
                            Stock: <%= product.getStockQuantity() %> available
                        </div>
                        <form action="addToCart.jsp" method="post">
                            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                            <input type="hidden" name="productName" value="<%= product.getProductName() %>">
                            <button type="submit" class="btn-add-cart" 
                                <%= product.getStockQuantity() <= 0 ? "disabled" : "" %>>
                                <%= product.getStockQuantity() > 0 ? "Add to Cart" : "Out of Stock" %>
                            </button>
                        </form>
                    </div>
            <%  }
            } else { %>
                <p>No products available.</p>
            <% } %>
        </div>
    </div>
</body>
</html>