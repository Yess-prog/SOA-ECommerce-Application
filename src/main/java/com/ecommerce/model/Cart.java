package com.ecommerce.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Cart entity class - represents shopping cart items
 * Location: com.ecommerce.model package
 */
public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int cartId;
    private int userId;
    private int productId;
    private int quantity;
    private Date addedAt;
    
    // Constructors
    public Cart() {
    }
    
    public Cart(int userId, int productId, int quantity) {
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
        this.addedAt = new Date();
    }
    
    // Getters and Setters
    public int getCartId() {
        return cartId;
    }
    
    public void setCartId(int cartId) {
        this.cartId = cartId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public Date getAddedAt() {
        return addedAt;
    }
    
    public void setAddedAt(Date addedAt) {
        this.addedAt = addedAt;
    }
    
    @Override
    public String toString() {
        return "Cart{" +
                "cartId=" + cartId +
                ", userId=" + userId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", addedAt=" + addedAt +
                '}';
    }
}