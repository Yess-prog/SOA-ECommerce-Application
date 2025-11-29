package com.ecommerce.dao;

import com.ecommerce.model.Cart;
import com.ecommerce.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Cart entity
 * Location: com.ecommerce.dao package
 */
public class CartDAO {
    
    /**
     * Add item to cart
     * If item already exists, update quantity
     */
    public boolean addToCart(Cart cartItem) {
        // First check if item already exists in cart
        String checkSql = "SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE cart SET quantity = quantity + ? WHERE cart_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            
            // Check if item exists
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, cartItem.getUserId());
                checkStmt.setInt(2, cartItem.getProductId());
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    // Item exists, update quantity
                    int cartId = rs.getInt("cart_id");
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, cartItem.getQuantity());
                        updateStmt.setInt(2, cartId);
                        return updateStmt.executeUpdate() > 0;
                    }
                } else {
                    // Item doesn't exist, insert new
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setInt(1, cartItem.getUserId());
                        insertStmt.setInt(2, cartItem.getProductId());
                        insertStmt.setInt(3, cartItem.getQuantity());
                        return insertStmt.executeUpdate() > 0;
                    }
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error adding to cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all cart items for a user
     */
    public List<Cart> getCartByUserId(int userId) {
        List<Cart> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                cartItems.add(extractCartFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting cart items: " + e.getMessage());
            e.printStackTrace();
        }
        
        return cartItems;
    }
    
    /**
     * Update cart item quantity
     */
    public boolean updateCartItemQuantity(int cartId, int newQuantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE cart_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, newQuantity);
            pstmt.setInt(2, cartId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating cart item: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Remove item from cart
     */
    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM cart WHERE cart_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error removing from cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Remove specific product from user's cart
     */
    public boolean removeProductFromCart(int userId, int productId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error removing product from cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Clear all items from user's cart
     */
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error clearing cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get cart item count for a user
     */
    public int getCartItemCount(int userId) {
        String sql = "SELECT COUNT(*) FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting cart item count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Check if product is in user's cart
     */
    public boolean isProductInCart(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking product in cart: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Helper method to extract Cart from ResultSet
     */
    private Cart extractCartFromResultSet(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setUserId(rs.getInt("user_id"));
        cart.setProductId(rs.getInt("product_id"));
        cart.setQuantity(rs.getInt("quantity"));
        cart.setAddedAt(rs.getTimestamp("added_at"));
        return cart;
    }
}