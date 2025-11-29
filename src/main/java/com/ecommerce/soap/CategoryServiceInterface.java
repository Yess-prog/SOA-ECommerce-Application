package com.ecommerce.soap;

import com.ecommerce.model.Category;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import java.util.List;

/**
 * Web Service Interface for Category operations
 */
@WebService(name = "CategoryService", targetNamespace = "http://soap.ecommerce.com/")
public interface CategoryServiceInterface {
    
    @WebMethod
    String addCategory(
            @WebParam(name = "categoryName") String categoryName,
            @WebParam(name = "description") String description);
    
    @WebMethod
    List<Category> getAllCategories();
    
    @WebMethod
    Category getCategoryById(@WebParam(name = "categoryId") int categoryId);
    
    @WebMethod
    String updateCategory(
            @WebParam(name = "categoryId") int categoryId,
            @WebParam(name = "categoryName") String categoryName,
            @WebParam(name = "description") String description);
    
    @WebMethod
    String deleteCategory(@WebParam(name = "categoryId") int categoryId);
}