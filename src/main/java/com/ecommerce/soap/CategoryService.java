package com.ecommerce.soap;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.model.Category;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * SOAP Web Service for Category operations
 * Location: com.ecommerce.soap package
 */
@WebService(
    serviceName = "CategoryService",
    portName = "CategoryServicePort",
    targetNamespace = "http://soap.ecommerce.com/",
    endpointInterface = "com.ecommerce.soap.CategoryServiceInterface"
)
public class CategoryService implements CategoryServiceInterface {
    
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    /**
     * Add new category (Admin only)
     */
    @WebMethod
    public String addCategory(
            @WebParam(name = "categoryName") String categoryName,
            @WebParam(name = "description") String description) {
        
        try {
            // Check if category already exists
            if (categoryDAO.categoryExists(categoryName)) {
                return "ERROR: Category already exists";
            }
            
            Category category = new Category(categoryName, description);
            boolean success = categoryDAO.addCategory(category);
            
            if (success) {
                return "SUCCESS: Category added successfully";
            } else {
                return "ERROR: Failed to add category";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Get all categories
     */
    @WebMethod
    public List<Category> getAllCategories() {
        try {
            return categoryDAO.getAllCategories();
        } catch (Exception e) {
            System.err.println("Error getting categories: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get category by ID
     */
    @WebMethod
    public Category getCategoryById(@WebParam(name = "categoryId") int categoryId) {
        try {
            return categoryDAO.getCategoryById(categoryId);
        } catch (Exception e) {
            System.err.println("Error getting category: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Update category (Admin only)
     */
    @WebMethod
    public String updateCategory(
            @WebParam(name = "categoryId") int categoryId,
            @WebParam(name = "categoryName") String categoryName,
            @WebParam(name = "description") String description) {
        
        try {
            Category category = categoryDAO.getCategoryById(categoryId);
            
            if (category == null) {
                return "ERROR: Category not found";
            }
            
            category.setCategoryName(categoryName);
            category.setDescription(description);
            
            boolean success = categoryDAO.updateCategory(category);
            
            if (success) {
                return "SUCCESS: Category updated successfully";
            } else {
                return "ERROR: Failed to update category";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
    
    /**
     * Delete category (Admin only)
     */
    @WebMethod
    public String deleteCategory(@WebParam(name = "categoryId") int categoryId) {
        try {
            boolean success = categoryDAO.deleteCategory(categoryId);
            
            if (success) {
                return "SUCCESS: Category deleted successfully";
            } else {
                return "ERROR: Failed to delete category";
            }
            
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}