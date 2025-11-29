<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.soap.UserServiceInterface" %>
<%@ page import="com.ecommerce.model.*" %>
<%@ page import="com.ecommerce.util.EmailUtil" %>
<%@ page import="java.net.URL" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.ws.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("../index.jsp");
    return;
}

// Handle Add User
String message = "";
if (request.getParameter("addUser") != null) {
    try {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "UserService");
        Service service = Service.create(url, qname);
        UserServiceInterface userService = service.getPort(UserServiceInterface.class);
        
        String result = userService.registerCustomer(username, password, email, fullName, phone, address);
        
        if (result.startsWith("SUCCESS")) {
            // Send email notification
            try {
                boolean emailSent = EmailUtil.sendAdminCreatedUserEmail(email, fullName, username, password);
                if (emailSent) {
                    message = result + " - Confirmation email sent to user.";
                } else {
                    message = result + " - But failed to send email notification.";
                }
            } catch (Exception e) {
                message = result + " - But email sending failed: " + e.getMessage();
            }
        } else {
            message = result;
        }
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Handle Update User
if (request.getParameter("updateUser") != null) {
    try {
        int userIdToUpdate = Integer.parseInt(request.getParameter("userIdToUpdate"));
        String email = request.getParameter("emailUpdate");
        String fullName = request.getParameter("fullNameUpdate");
        String phone = request.getParameter("phoneUpdate");
        String address = request.getParameter("addressUpdate");
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "UserService");
        Service service = Service.create(url, qname);
        UserServiceInterface userService = service.getPort(UserServiceInterface.class);
        
        String result = userService.updateUserProfile(userIdToUpdate, email, fullName, phone, address);
        message = result;
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Handle Delete User
if (request.getParameter("deleteUser") != null) {
    try {
        int userIdToDelete = Integer.parseInt(request.getParameter("userId"));
        
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "UserService");
        Service service = Service.create(url, qname);
        UserServiceInterface userService = service.getPort(UserServiceInterface.class);
        
        String result = userService.deleteUser(userIdToDelete);
        message = result;
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}

// Get all users
List<User> users = null;

try {
    URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
    QName qname = new QName("http://soap.ecommerce.com/", "UserService");
    Service service = Service.create(url, qname);
    UserServiceInterface userService = service.getPort(UserServiceInterface.class);
    
    users = userService.getAllUsers();
    
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

// Get user to edit if edit button was clicked
User userToEdit = null;
if (request.getParameter("editUser") != null) {
    try {
        int editUserId = Integer.parseInt(request.getParameter("editUserId"));
        URL url = new URL("http://localhost:8080/EcommerceSOAP/services/UserService?wsdl");
        QName qname = new QName("http://soap.ecommerce.com/", "UserService");
        Service service = Service.create(url, qname);
        UserServiceInterface userService = service.getPort(UserServiceInterface.class);
        
        userToEdit = userService.getUserById(editUserId);
    } catch (Exception e) {
        message = "ERROR: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Admin</title>
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
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        input, select, textarea {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            margin-right: 10px;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-warning {
            background: #ffc107;
            color: #333;
        }
        
        .btn-danger {
            background: #ff4757;
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #f9f9f9;
            font-weight: 600;
            color: #333;
        }
        
        .role-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .role-ADMIN {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .role-CUSTOMER {
            background: #d4edda;
            color: #155724;
        }
        
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        
        .success {
            background-color: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
        
        .error {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .user-info {
            font-size: 12px;
            color: #666;
        }
        
        .actions-cell {
            white-space: nowrap;
        }
        
        .edit-section {
            background: #fff3cd;
            border: 2px solid #ffc107;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .edit-section h3 {
            color: #856404;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <h1>👨‍💼 Admin - Users</h1>
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
        <% if (!message.isEmpty()) { %>
            <div class="message <%= message.startsWith("SUCCESS") ? "success" : "error" %>">
                <%= message.replace("SUCCESS: ", "").replace("ERROR: ", "") %>
            </div>
        <% } %>
        
        <% if (userToEdit != null) { %>
        <div class="edit-section">
            <h3>✏️ Edit User: <%= userToEdit.getUsername() %></h3>
            <form method="post">
                <input type="hidden" name="userIdToUpdate" value="<%= userToEdit.getUserId() %>">
                
                <div class="form-grid">
                    <div class="form-group">
                        <label>Username (Cannot be changed)</label>
                        <input type="text" value="<%= userToEdit.getUsername() %>" disabled>
                    </div>
                    
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" name="emailUpdate" value="<%= userToEdit.getEmail() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="fullNameUpdate" value="<%= userToEdit.getFullName() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phoneUpdate" value="<%= userToEdit.getPhone() != null ? userToEdit.getPhone() : "" %>">
                    </div>
                    
                    <div class="form-group full-width">
                        <label>Address</label>
                        <textarea name="addressUpdate"><%= userToEdit.getAddress() != null ? userToEdit.getAddress() : "" %></textarea>
                    </div>
                </div>
                
                <button type="submit" name="updateUser" class="btn btn-success">Update User</button>
                <a href="users.jsp"><button type="button" class="btn btn-warning">Cancel</button></a>
            </form>
        </div>
        <% } %>
        
        <div class="section">
            <h2>Add New User</h2>
            <form method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Username *</label>
                        <input type="text" name="username" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Password *</label>
                        <input type="password" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Email *</label>
                        <input type="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="fullName" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone">
                    </div>
                    
                    <div class="form-group">
                        <label>Role *</label>
                        <select name="role" required>
                            <option value="CUSTOMER">Customer</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                    
                    <div class="form-group full-width">
                        <label>Address</label>
                        <textarea name="address"></textarea>
                    </div>
                </div>
                
                <button type="submit" name="addUser" class="btn btn-primary">Add User</button>
            </form>
        </div>
        
        <div class="section">
            <h2>All Users</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users != null && !users.isEmpty()) {
                        Integer currentUserId = (Integer) session.getAttribute("userId");
                        for (User user : users) { %>
                            <tr>
                                <td><%= user.getUserId() %></td>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getFullName() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getPhone() != null ? user.getPhone() : "N/A" %></td>
                                <td>
                                    <span class="role-badge role-<%= user.getRole() %>">
                                        <%= user.getRole() %>
                                    </span>
                                </td>
                                <td class="user-info"><%= user.getCreatedAt() != null ? sdf.format(user.getCreatedAt()) : "N/A" %></td>
                                <td class="actions-cell">
                                    <form method="post" style="display:inline;">
                                        <input type="hidden" name="editUserId" value="<%= user.getUserId() %>">
                                        <button type="submit" name="editUser" class="btn btn-warning" style="padding: 5px 10px;">Edit</button>
                                    </form>
                                    
                                    <% if (user.getUserId() != currentUserId) { %>
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                            <button type="submit" name="deleteUser" class="btn btn-danger" style="padding: 5px 10px;"
                                                    onclick="return confirm('Are you sure you want to delete this user?')">Delete</button>
                                        </form>
                                    <% } else { %>
                                        <span style="color: #999; font-size: 12px;">(You)</span>
                                    <% } %>
                                </td>
                            </tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="8">No users found</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>