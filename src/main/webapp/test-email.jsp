<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.util.EmailUtil" %>

<%
String action = request.getParameter("action");
String testEmail = request.getParameter("testEmail");
String result = "";
boolean emailSent = false;

if ("test".equals(action) && testEmail != null && !testEmail.isEmpty()) {
    try {
        emailSent = EmailUtil.sendRegistrationEmail(testEmail, "Test User", "testuser");
        if (emailSent) {
            result = "SUCCESS: Test email sent to " + testEmail;
        } else {
            result = "ERROR: Failed to send email. Check console for errors.";
        }
    } catch (Exception e) {
        result = "ERROR: " + e.getMessage();
    }
} else if ("config".equals(action)) {
    try {
        emailSent = EmailUtil.testEmailConfiguration();
        if (emailSent) {
            result = "SUCCESS: Email configuration is working correctly!";
        } else {
            result = "ERROR: Email configuration test failed. Check console for errors.";
        }
    } catch (Exception e) {
        result = "ERROR: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Email Configuration Test - E-Commerce</title>
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
            padding: 20px;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 600px;
            max-width: 100%;
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
        
        .test-section {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .test-section h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
        }
        
        .test-section p {
            color: #666;
            margin-bottom: 15px;
            font-size: 14px;
            line-height: 1.6;
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
        
        input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input[type="email"]:focus {
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
        
        .btn-secondary {
            background: #6c757d;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .info-box {
            background: #d1ecf1;
            border-left: 4px solid #17a2b8;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .info-box h4 {
            color: #0c5460;
            margin-bottom: 10px;
        }
        
        .info-box p {
            color: #0c5460;
            font-size: 13px;
            margin-bottom: 5px;
        }
        
        .info-box code {
            background: white;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
        
        .emoji {
            font-size: 48px;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📧 Email Configuration Test</h1>
        <p class="subtitle">Test your email settings</p>
        
        <% if (!result.isEmpty()) { %>
            <div class="emoji"><%= emailSent ? "✅" : "❌" %></div>
            <div class="message <%= result.startsWith("SUCCESS") ? "success" : "error" %>">
                <%= result %>
            </div>
        <% } %>
        
        <div class="info-box">
            <h4>⚠️ Before Testing</h4>
            <p>Make sure you've configured your email settings in:</p>
            <p><code>com.ecommerce.util.EmailUtil.java</code></p>
            <p><strong>Required:</strong> Gmail App Password or SMTP credentials</p>
        </div>
        
        <!-- Test 1: Quick Configuration Test -->
        <div class="test-section">
            <h3>Test 1: Quick Configuration Test</h3>
            <p>Send a test email to yourself (configured sender email)</p>
            <form method="post">
                <input type="hidden" name="action" value="config">
                <button type="submit" class="btn">Test Email Configuration</button>
            </form>
        </div>
        
        <!-- Test 2: Send to Custom Email -->
        <div class="test-section">
            <h3>Test 2: Send Test Email to Any Address</h3>
            <p>Send a registration confirmation email to test recipient</p>
            <form method="post">
                <input type="hidden" name="action" value="test">
                <div class="form-group">
                    <label for="testEmail">Recipient Email Address</label>
                    <input type="email" id="testEmail" name="testEmail" 
                           placeholder="test@example.com" required>
                </div>
                <button type="submit" class="btn btn-secondary">Send Test Email</button>
            </form>
        </div>
        
        <div class="info-box">
            <h4>📋 Troubleshooting</h4>
            <p><strong>Email not received?</strong></p>
            <p>1. Check spam/junk folder</p>
            <p>2. Verify SMTP credentials in EmailUtil.java</p>
            <p>3. Check server console for error messages</p>
            <p>4. For Gmail: Use App Password, not regular password</p>
        </div>
        
        <div class="back-link">
            <a href="index.jsp">← Back to Login</a>
        </div>
    </div>
</body>
</html>