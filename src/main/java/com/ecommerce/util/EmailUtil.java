package com.ecommerce.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * Email Utility Class for sending emails
 * Location: com.ecommerce.util package
 */
public class EmailUtil {
    
    // ============================================
    // CONFIGURE THESE SETTINGS FOR YOUR EMAIL
    // ============================================
    
    // Gmail Configuration (recommended for testing)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "ssnaccache1@gmail.com"; // Change this!
    private static final String SENDER_PASSWORD = "xozm kbwj uggo glgr"; // Change this!
    private static final String SENDER_NAME = "E-Commerce Admin";
    
    // For other email providers, adjust settings:
    // Outlook: smtp-mail.outlook.com, port 587
    // Yahoo: smtp.mail.yahoo.com, port 587
    
    /**
     * Send registration confirmation email
     */
    public static boolean sendRegistrationEmail(String recipientEmail, String recipientName, String username) {
        String subject = "Welcome to E-Commerce - Registration Successful!";
        
        String htmlContent = 
            "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "    <style>" +
            "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            "        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
            "        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }" +
            "        .button { display: inline-block; padding: 12px 30px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }" +
            "        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }" +
            "        .info-box { background: white; padding: 15px; border-left: 4px solid #667eea; margin: 20px 0; }" +
            "    </style>" +
            "</head>" +
            "<body>" +
            "    <div class='container'>" +
            "        <div class='header'>" +
            "            <h1>🛒 Welcome to E-Commerce!</h1>" +
            "        </div>" +
            "        <div class='content'>" +
            "            <h2>Hello " + recipientName + ",</h2>" +
            "            <p>Thank you for registering with our E-Commerce platform!</p>" +
            "            " +
            "            <div class='info-box'>" +
            "                <strong>Your Account Details:</strong><br>" +
            "                <strong>Username:</strong> " + username + "<br>" +
            "                <strong>Email:</strong> " + recipientEmail +
            "            </div>" +
            "            " +
            "            <p>Your account has been successfully created. You can now login and start shopping!</p>" +
            "            " +
            "            <p style='margin-top: 20px;'>" +
            "                <strong>⚠️ Security Notice:</strong><br>" +
            "                If you did not create this account, please contact our support team immediately." +
            "            </p>" +
            "            " +
            "            <a href='http://localhost:8080/EcommerceSOAP' class='button'>Login Now</a>" +
            "            " +
            "            <p style='margin-top: 30px;'>Happy Shopping!<br>The E-Commerce Team</p>" +
            "        </div>" +
            "        <div class='footer'>" +
            "            <p>This is an automated email. Please do not reply.</p>" +
            "            <p>&copy; 2024 E-Commerce. All rights reserved.</p>" +
            "        </div>" +
            "    </div>" +
            "</body>" +
            "</html>";
        
        return sendEmail(recipientEmail, subject, htmlContent);
    }
    
    /**
     * Send welcome email to admin-created users
     */
    public static boolean sendAdminCreatedUserEmail(String recipientEmail, String recipientName, String username, String temporaryPassword) {
        String subject = "Your E-Commerce Account Has Been Created";
        
        String htmlContent = 
            "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "    <style>" +
            "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
            "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
            "        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }" +
            "        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }" +
            "        .button { display: inline-block; padding: 12px 30px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px; }" +
            "        .info-box { background: white; padding: 15px; border-left: 4px solid #667eea; margin: 20px 0; }" +
            "        .warning-box { background: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0; }" +
            "        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }" +
            "    </style>" +
            "</head>" +
            "<body>" +
            "    <div class='container'>" +
            "        <div class='header'>" +
            "            <h1>🛒 E-Commerce Account Created</h1>" +
            "        </div>" +
            "        <div class='content'>" +
            "            <h2>Hello " + recipientName + ",</h2>" +
            "            <p>An administrator has created an account for you on our E-Commerce platform.</p>" +
            "            " +
            "            <div class='info-box'>" +
            "                <strong>Your Login Credentials:</strong><br>" +
            "                <strong>Username:</strong> " + username + "<br>" +
            "                <strong>Temporary Password:</strong> " + temporaryPassword + "<br>" +
            "                <strong>Email:</strong> " + recipientEmail +
            "            </div>" +
            "            " +
            "            <div class='warning-box'>" +
            "                <strong>⚠️ Important Security Notice:</strong><br>" +
            "                Please change your password after your first login for security purposes." +
            "            </div>" +
            "            " +
            "            <p>You can now login and start using the platform!</p>" +
            "            " +
            "            <a href='http://localhost:8080/EcommerceSOAP' class='button'>Login Now</a>" +
            "            " +
            "            <p style='margin-top: 30px;'>Best regards,<br>The E-Commerce Team</p>" +
            "        </div>" +
            "        <div class='footer'>" +
            "            <p>This is an automated email. Please do not reply.</p>" +
            "            <p>&copy; 2024 E-Commerce. All rights reserved.</p>" +
            "        </div>" +
            "    </div>" +
            "</body>" +
            "</html>";
        
        return sendEmail(recipientEmail, subject, htmlContent);
    }
    
    /**
     * Core method to send email
     */
    private static boolean sendEmail(String recipientEmail, String subject, String htmlContent) {
        try {
            // Setup mail server properties
            Properties properties = new Properties();
            properties.put("mail.smtp.host", SMTP_HOST);
            properties.put("mail.smtp.port", SMTP_PORT);
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // Create session with authentication
            Session session = Session.getInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                }
            });
            
            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, SENDER_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            // Send message
            Transport.send(message);
            
            System.out.println("Email sent successfully to: " + recipientEmail);
            return true;
            
        } catch (Exception e) {
            System.err.println("Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Test email configuration
     */
    public static boolean testEmailConfiguration() {
        String testRecipient = SENDER_EMAIL; // Send test to yourself
        String subject = "E-Commerce Email Test";
        String htmlContent = 
            "<html><body>" +
            "<h2>Email Configuration Test</h2>" +
            "<p>If you receive this email, your email configuration is working correctly!</p>" +
            "<p>SMTP Host: " + SMTP_HOST + "</p>" +
            "<p>SMTP Port: " + SMTP_PORT + "</p>" +
            "</body></html>";
        
        return sendEmail(testRecipient, subject, htmlContent);
    }
}