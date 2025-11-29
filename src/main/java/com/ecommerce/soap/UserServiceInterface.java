package com.ecommerce.soap;

import com.ecommerce.model.User;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * Web Service Interface for User operations
 * This is the client-side interface
 */
@WebService(name = "UserService", targetNamespace = "http://soap.ecommerce.com/")
public interface UserServiceInterface {
    
    @WebMethod
    String registerCustomer(
            @WebParam(name = "username") String username,
            @WebParam(name = "password") String password,
            @WebParam(name = "email") String email,
            @WebParam(name = "fullName") String fullName,
            @WebParam(name = "phone") String phone,
            @WebParam(name = "address") String address);
    
    @WebMethod
    int login(
            @WebParam(name = "username") String username,
            @WebParam(name = "password") String password);
    
    @WebMethod
    User getUserById(@WebParam(name = "userId") int userId);
    
    @WebMethod
    String getUserRole(@WebParam(name = "userId") int userId);
    
    @WebMethod
    String updateUserProfile(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "email") String email,
            @WebParam(name = "fullName") String fullName,
            @WebParam(name = "phone") String phone,
            @WebParam(name = "address") String address);
    
    @WebMethod
    List<User> getAllUsers();
    
    @WebMethod
    String deleteUser(@WebParam(name = "userId") int userId);
}