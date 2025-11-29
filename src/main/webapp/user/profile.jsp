<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.UserServiceInterface" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>

<%
if (session.getAttribute("userId") == null) {
    response.sendRedirect("../index.jsp");
    return;
}

Integer userId = (Integer) session.getAttribute("userId");
User user = null;
String message = "";

// Get user details
try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "UserService");
    Service service = Service.create(url, qname);
    UserServiceInterface userService = service.getPort(UserServiceInterface.class);
    
    user = userService.getUserById(userId);
} catch (Exception e) {
    message = "Error loading profile: " + e.getMessage();
}

// Handle profile update
if (request.getParameter("updateProfile") != null) {
    try {
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "UserService");
        Service service = Service.create(url, qname);
        UserServiceInterface userService = service.getPort(UserServiceInterface.class);
        
        String result = userService.updateUserProfile(userId, email, fullName, phone, address);
        
        if (result.startsWith("SUCCESS")) {
            message = "Profile updated successfully!";
            session.setAttribute("fullName", fullName);
            // Reload user data
            user = userService.getUserById(userId);
        } else {
            message = result.replace("ERROR: ", "");
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - E-Commerce</title>
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
            max-width: 600px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .profile-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        input, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        input:disabled {
            background: #f5f5f5;
            color: #666;
        }
        
        .btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>🛒 E-Commerce</h1>
        <div class="navbar-menu">
            <a href="home.jsp">Shop</a>
            <a href="cart.jsp">Cart</a>
            <a href="orders.jsp">My Orders</a>
            <a href="profile.jsp">Profile</a>
            <a href="../logout.jsp">Logout</a>
        </div>
    </nav>
    
    <div class="container">
        <div class="profile-container">
            <h2>My Profile</h2>
            
            <% if (!message.isEmpty()) { %>
                <div class="message"><%= message %></div>
            <% } %>
            
            <% if (user != null) { %>
                <form method="post">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" value="<%= user.getUsername() %>" disabled>
                    </div>
                    
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" name="email" value="<%= user.getEmail() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="fullName" value="<%= user.getFullName() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label>Address</label>
                        <textarea name="address"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                    </div>
                    
                    <button type="submit" name="updateProfile" class="btn">Update Profile</button>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>