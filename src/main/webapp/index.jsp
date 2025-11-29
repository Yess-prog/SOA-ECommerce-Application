<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.UserServiceInterface" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>

<%
// Handle login submission
String message = "";
if (request.getParameter("login") != null) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    try {
        // Call SOAP service
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "UserService");
        Service service = Service.create(url, qname);
        UserServiceInterface userService = service.getPort(UserServiceInterface.class);
        
        int userId = userService.login(username, password);
        
        if (userId != -1) {
            // Login successful
            String role = userService.getUserRole(userId);
            User user = userService.getUserById(userId);
            
            session.setAttribute("userId", userId);
            session.setAttribute("username", username);
            session.setAttribute("role", role);
            session.setAttribute("fullName", user.getFullName());
            
            // Redirect based on role
            if ("ADMIN".equals(role)) {
                response.sendRedirect("admin/dashboard.jsp");
            } else {
                response.sendRedirect("user/home.jsp");
            }
            return;
        } else {
            message = "Invalid username or password!";
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
    <title>E-Commerce - Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 400px;
        }
        
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
        }
        
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
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
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            width: 100%;
            padding: 12px;
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
        }
        
        .error {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .register-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        .demo-credentials {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 12px;
        }
        
        .demo-credentials h4 {
            margin-bottom: 10px;
            color: #333;
        }
        
        .demo-credentials p {
            margin: 5px 0;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🛒 E-Commerce System</h1>
        <p class="subtitle">SOAP Web Services</p>
        
        <% if (!message.isEmpty()) { %>
            <div class="message error"><%= message %></div>
        <% } %>
        
        <div class="demo-credentials">
            <h4>Demo Credentials:</h4>
            <p><strong>Admin:</strong> admin / admin123</p>
            <p><strong>Customer:</strong> Register new account</p>
        </div>
        
        <form method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <button type="submit" name="login" class="btn">Login</button>
        </form>
        
        <div class="register-link">
            Don't have an account? <a href="register.jsp">Register here</a>
        </div>
    </div>
</body>
</html>