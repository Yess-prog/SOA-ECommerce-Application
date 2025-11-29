package com.ecommerce.soap;

import com.ecommerce.model.Cart;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

@WebService(name = "CartService", targetNamespace = "http://soap.ecommerce.com/")
public interface CartServiceInterface {
    
    @WebMethod
    String addToCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "productId") int productId,
            @WebParam(name = "quantity") int quantity);
    
    @WebMethod
    List<Cart> getCartItems(@WebParam(name = "userId") int userId);
    
    @WebMethod
    String updateCartItemQuantity(
            @WebParam(name = "cartId") int cartId,
            @WebParam(name = "newQuantity") int newQuantity);
    
    @WebMethod
    String removeFromCart(@WebParam(name = "cartId") int cartId);
    
    @WebMethod
    String removeProductFromCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "productId") int productId);
    
    @WebMethod
    String clearCart(@WebParam(name = "userId") int userId);
    
    @WebMethod
    int getCartItemCount(@WebParam(name = "userId") int userId);
    
    @WebMethod
    boolean isProductInCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "productId") int productId);
}