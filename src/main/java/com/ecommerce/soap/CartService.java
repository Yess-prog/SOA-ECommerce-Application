package com.ecommerce.soap;

import com.ecommerce.dao.CartDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Cart;
import com.ecommerce.model.Product;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * SOAP Web Service for Shopping Cart operations
 * Location: com.ecommerce.soap package
 */
@WebService(
    serviceName = "CartService",
    portName = "CartServicePort",
    targetNamespace = "http://soap.ecommerce.com/",
    endpointInterface = "com.ecommerce.soap.CartServiceInterface"
)
public class CartService implements CartServiceInterface {
    
    private CartDAO cartDAO = new CartDAO();
    private ProductDAO productDAO = new ProductDAO();
    
    /**
     * Add product to cart
     */
    @WebMethod
    public String addToCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "productId") int productId,
            @WebParam(name = "quantity") int quantity) {
        
        try {
            // Validate product exists and has stock
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                return "ERROR: Product not found";
            }
            
            if (product.getStockQuantity() < quantity) {
                return "ERROR: Insufficient stock. Available: " + product.getStockQuantity();
            }
            
            Cart cartItem = new Cart(userId, productId, quantity);
            boolean success = cartDAO.addToCart(cartItem);
            
            if (success) {
                return "SUCCESS: Product added to cart";
            } else {
                return "ERROR: Failed to add product to cart";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get all cart items for a user
     */
    @WebMethod
    public List<Cart> getCartItems(@WebParam(name = "userId") int userId) {
        try {
            return cartDAO.getCartByUserId(userId);
        } catch (Exception e) {
            System.err.println("Error getting cart items: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Update cart item quantity
     */
    @WebMethod
    public String updateCartItemQuantity(
            @WebParam(name = "cartId") int cartId,
            @WebParam(name = "newQuantity") int newQuantity) {
        
        try {
            if (newQuantity <= 0) {
                return "ERROR: Quantity must be greater than 0";
            }
            
            boolean success = cartDAO.updateCartItemQuantity(cartId, newQuantity);
            
            if (success) {
                return "SUCCESS: Cart item quantity updated";
            } else {
                return "ERROR: Failed to update cart item";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Remove item from cart
     */
    @WebMethod
    public String removeFromCart(@WebParam(name = "cartId") int cartId) {
        try {
            boolean success = cartDAO.removeFromCart(cartId);
            
            if (success) {
                return "SUCCESS: Item removed from cart";
            } else {
                return "ERROR: Failed to remove item from cart";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Remove specific product from cart
     */
    @WebMethod
    public String removeProductFromCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "productId") int productId) {
        
        try {
            boolean success = cartDAO.removeProductFromCart(userId, productId);
            
            if (success) {
                return "SUCCESS: Product removed from cart";
            } else {
                return "ERROR: Failed to remove product from cart";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Clear all items from cart
     */
    @WebMethod
    public String clearCart(@WebParam(name = "userId") int userId) {
        try {
            boolean success = cartDAO.clearCart(userId);
            
            if (success) {
                return "SUCCESS: Cart cleared successfully";
            } else {
                return "ERROR: Failed to clear cart";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get cart item count
     */
    @WebMethod
    public int getCartItemCount(@WebParam(name = "userId") int userId) {
        try {
            return cartDAO.getCartItemCount(userId);
        } catch (Exception e) {
            System.err.println("Error getting cart count: " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Check if product is in cart
     */
    @WebMethod
    public boolean isProductInCart(
            @WebParam(name = "userId") int userId,
            @WebParam(name = "productId") int productId) {
        
        try {
            return cartDAO.isProductInCart(userId, productId);
        } catch (Exception e) {
            System.err.println("Error checking product in cart: " + e.getMessage());
            return false;
        }
    }
}