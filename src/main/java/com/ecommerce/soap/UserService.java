package com.ecommerce.soap;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.model.User.UserRole;
import com.ecommerce.util.EmailUtil;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * SOAP Web Service for User operations
 * Location: com.ecommerce.soap package
 */
@WebService(serviceName = "UserService", portName = "UserServicePort", 
            targetNamespace = "http://soap.ecommerce.com/", 
            endpointInterface = "com.ecommerce.soap.UserServiceInterface")
public class UserService implements UserServiceInterface {
    
    private UserDAO userDAO = new UserDAO();
    
    /**
     * Register a new customer
     */
    @WebMethod
    public String registerCustomer(
            @WebParam(name = "username") String username,
            @WebParam(name = "password") String password,
            @WebParam(name = "email") String email,
            @WebParam(name = "fullName") String fullName,
            @WebParam(name = "phone") String phone,
            @WebParam(name = "address") String address) {
        
        try {
            // Check if username already exists
            if (userDAO.usernameExists(username)) {
                return "ERROR: Username already exists";
            }
            
            // Create new user
            User user = new User(username, password, email, fullName, UserRole.CUSTOMER);
            user.setPhone(phone);
            user.setAddress(address);
            
            boolean success = userDAO.registerUser(user);
            
            if (success) {
                // Send confirmation email
                try {
                    boolean emailSent = EmailUtil.sendRegistrationEmail(email, fullName, username);
                    if (emailSent) {
                        System.out.println("Registration email sent to: " + email);
                    } else {
                        System.out.println("User registered but email sending failed");
                    }
                } catch (Exception e) {
                    System.err.println("Email sending error: " + e.getMessage());
                    // Don't fail registration if email fails
                }
                
                return "SUCCESS: User registered successfully";
            } else {
                return "ERROR: Failed to register user";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * User login
     * Returns user ID if successful, -1 if failed
     */
    @WebMethod
    public int login(
            @WebParam(name = "username") String username,
            @WebParam(name = "password") String password) {
        
        try {
            User user = userDAO.login(username, password);
            
            if (user != null) {
                return user.getUserId();
            } else {
                return -1; // Login failed
            }
            
        } catch (Exception e) {
            System.err.println("Login error: " + e.getMessage());
            return -1;
        }
    }
    
    /**
     * Get user details by ID
     */
    @WebMethod
    public User getUserById(@WebParam(name = "userId") int userId) {
        try {
            return userDAO.getUserById(userId);
        } catch (Exception e) {
            System.err.println("Error getting user: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get user role (ADMIN or CUSTOMER)
     */
    @WebMethod
    public String getUserRole(@WebParam(name = "userId") int userId) {
        try {
            User user = userDAO.getUserById(userId);
            if (user != null) {
                return user.getRole().toString();
            }
            return "NOT_FOUND";
        } catch (Exception e) {
            return "ERROR";
        }
    }
    
    /**
     * Update user profile
     */
    @WebMethod
    public String updateUserProfile(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "email") String email,
            @WebParam(name = "fullName") String fullName,
            @WebParam(name = "phone") String phone,
            @WebParam(name = "address") String address) {
        
        try {
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                return "ERROR: User not found";
            }
            
            user.setEmail(email);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setAddress(address);
            
            boolean success = userDAO.updateUser(user);
            
            if (success) {
                return "SUCCESS: Profile updated successfully";
            } else {
                return "ERROR: Failed to update profile";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get all users (Admin only)
     */
    @WebMethod
    public List<User> getAllUsers() {
        try {
            return userDAO.getAllUsers();
        } catch (Exception e) {
            System.err.println("Error getting all users: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Delete user (Admin only)
     */
    @WebMethod
    public String deleteUser(@WebParam(name = "userId") int userId) {
        try {
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                return "SUCCESS: User deleted successfully";
            } else {
                return "ERROR: Failed to delete user";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}