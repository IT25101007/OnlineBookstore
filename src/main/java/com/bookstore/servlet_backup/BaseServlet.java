/**
 * Session Guard Utility Methods
 *
 * Add these methods to each servlet or create a BaseServlet class that all servlets extend.
 *
 * Option 1: Create a BaseServlet abstract class
 */

// Create this file at: src/main/java/com/bookstore/servlet/BaseServlet.java
package com.bookstore.servlet_backup;

import com.bookstore.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public abstract class BaseServlet extends jakarta.servlet.http.HttpServlet {

    /**
     * Check if user is logged in
     * @return true if user is logged in, false otherwise
     */
    protected User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("user");
    }

    /**
     * Check if current user is admin
     */
    protected boolean isAdmin(HttpServletRequest request) {
        User user = getSessionUser(request);
        return user != null && "ADMIN".equals(user.getRole());
    }

    /**
     * Check session and redirect to login if not authenticated
     * @return true if user is logged in, false otherwise
     */
    protected boolean checkLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    /**
     * Check if user is admin, redirect if not
     * @return true if user is admin, false otherwise
     */
    protected boolean checkAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!checkLogin(request, response)) {
            return false;
        }
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return false;
        }
        return true;
    }

    /**
     * Check if user has required role
     * @param requiredRole - "ADMIN" or "CUSTOMER"
     * @return true if user has required role, false otherwise
     */
    protected boolean checkRole(HttpServletRequest request, HttpServletResponse response,
                                String requiredRole) throws IOException {
        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (requiredRole != null && !requiredRole.equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/books");
            return false;
        }
        return true;
    }
}

// Then modify each servlet to extend BaseServlet:

/*
Example - Updated UserServlet:

@WebServlet(urlPatterns = {"/register", "/login", "/profile", "/users", "/logout"})
public class UserServlet extends BaseServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/profile":
                if (!checkLogin(request, response)) return;
                // ... rest of code
                break;
            case "/users":
                if (!checkAdmin(request, response)) return;
                // ... rest of code
                break;
            // ... other cases
        }
    }
}

Example - Updated BookServlet (add/edit/delete require admin):

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    String path = request.getServletPath();
    
    switch (path) {
        case "/book/add":
            if (!checkAdmin(request, response)) return;
            // ... rest of code
            break;
        case "/book/edit":
            if (!checkAdmin(request, response)) return;
            // ... rest of code
            break;
        // ... other cases (browsing doesn't require login)
    }
}

Example - CartServlet (requires login):

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    if (!checkLogin(request, response)) return;
    // ... rest of code
}

Example - OrderServlet (requires login):

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    if (!checkLogin(request, response)) return;
    // ... rest of code
}

Example - PaymentServlet (requires login):

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    if (!checkLogin(request, response)) return;
    // ... rest of code
}

Example - AdminServlet (requires admin):

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    if (!checkAdmin(request, response)) return;
    // ... rest of code
}
*/