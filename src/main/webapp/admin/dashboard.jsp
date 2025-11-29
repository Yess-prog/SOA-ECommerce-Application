<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.ProductServiceInterface" %>
<%@ page import="com.ecommerce.soap.OrderServiceInterface" %>
<%@ page import="com.ecommerce.soap.UserServiceInterface" %>
<%@ page import="com.ecommerce.model.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.util.List" %>

<%
// Check if user is logged in and is admin
if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("../index.jsp");
    return;
}

String fullName = (String) session.getAttribute("fullName");

// Get statistics
int totalProducts = 0;
int totalOrders = 0;
int totalUsers = 0;
int pendingOrders = 0;

try {
    // Get ProductService
    URL productUrl = new URL("http://localhost:8080/EcommerceSOAP/services/ProductService?wsdl");
    QName productQname = new QName("http://soap.ecommerce.com/", "ProductService");
    Service productService = Service.create(productUrl, productQname);
    ProductServiceInterface productSoap = productService.getPort(ProductServiceInterface.class);
    
    // Get OrderService
    URL orderUrl = new URL("http://localhost:8080/EcommerceSOAP/services/OrderService?wsdl");
    QName orderQname = new QName("http://soap.ecommerce.com/", "OrderService");
    Service orderService = Service.create(orderUrl, orderQname);
    OrderServiceInterface orderSoap = orderService.getPort(OrderServiceInterface.class);
    
    // Get UserService
    URL userUrl = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
    QName userQname = new QName("http://soap.ecommerce.com/", "UserService");
    Service userService = Service.create(userUrl, userQname);
    UserServiceInterface userSoap = userService.getPort(UserServiceInterface.class);
    
    List<Product> products = productSoap.getAllProductsForAdmin();
    List<Order> orders = orderSoap.getAllOrders();
    List<User> users = userSoap.getAllUsers();
    List<Order> pending = orderSoap.getOrdersByStatus("PENDING");
    
    if (products != null) totalProducts = products.size();
    if (orders != null) totalOrders = orders.size();
    if (users != null) totalUsers = users.size();
    if (pending != null) pendingOrders = pending.size();
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - E-Commerce</title>
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
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .welcome {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .welcome h2 {
            color: #333;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .stat-label {
            font-size: 16px;
            color: #666;
        }
        
        .quick-actions {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .quick-actions h3 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .action-btn {
            padding: 15px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .action-btn:hover {
            background: #764ba2;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>👨‍💼 Admin Dashboard</h1>
        <div class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="products.jsp">Products</a>
            <a href="categories.jsp">Categories</a>
            <a href="orders.jsp">Orders</a>
            <a href="users.jsp">Users</a>
            <a href="../logout.jsp">Logout</a>
        </div>
    </nav>
    
    <div class="container">
        <div class="welcome">
            <h2>Welcome back, <%= fullName %>!</h2>
            <p>Here's what's happening with your store today.</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📦</div>
                <div class="stat-number"><%= totalProducts %></div>
                <div class="stat-label">Total Products</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">🛍️</div>
                <div class="stat-number"><%= totalOrders %></div>
                <div class="stat-label">Total Orders</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-number"><%= totalUsers %></div>
                <div class="stat-label">Total Users</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">⏳</div>
                <div class="stat-number"><%= pendingOrders %></div>
                <div class="stat-label">Pending Orders</div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>Quick Actions</h3>
            <div class="action-grid">
                <a href="products.jsp" class="action-btn">Manage Products</a>
                <a href="categories.jsp" class="action-btn">Manage Categories</a>
                <a href="orders.jsp" class="action-btn">View Orders</a>
                <a href="users.jsp" class="action-btn">View Users</a>
            </div>
        </div>
    </div>
</body>
</html>