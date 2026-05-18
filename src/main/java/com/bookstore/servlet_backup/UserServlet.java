package com.bookstore.servlet_backup;

import com.bookstore.filehandler.UserFileHandler;
import com.bookstore.model.User;
import com.bookstore.model.CustomerUser;
import com.bookstore.model.AdminUser;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/register", "/login", "/profile", "/users", "/logout"})
public class UserServlet extends HttpServlet {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName, HttpServletRequest request) {
        String realPath = request.getServletContext().getRealPath("/");
        if (realPath == null) {
            return DATA_FOLDER + fileName;
        }
        return realPath + "../../" + DATA_FOLDER + fileName;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/register":
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                break;
            case "/login":
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                break;
            case "/profile":
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect("/login");
                } else {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
                }
                break;
            case "/users":
                // Check admin session
                User adminUser = (User) request.getSession().getAttribute("user");
                if (adminUser == null || !"ADMIN".equals(adminUser.getRole())) {
                    response.sendRedirect("/books");
                    return;
                }
                String usersPath = getDataPath("users.txt", request);
                List<User> allUsers = UserFileHandler.getAllUsers(usersPath);
                request.setAttribute("users", allUsers);
                request.getRequestDispatcher("/WEB-INF/views/userList.jsp").forward(request, response);
                break;
            case "/logout":
                request.getSession().invalidate();
                response.sendRedirect("/login");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/register":
                handleRegister(request, response);
                break;
            case "/login":
                handleLogin(request, response);
                break;
            case "/profile":
                handleUpdateProfile(request, response);
                break;
            case "/users":
                String action = request.getParameter("action");
                if ("delete".equals(action)) {
                    String userID = request.getParameter("userID");
                    String usersPath = getDataPath("users.txt", request);
                    UserFileHandler.deleteUser(userID, usersPath);
                }
                response.sendRedirect("/users");
                break;
            default:
                response.sendRedirect("/");
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        String userID = IDGenerator.generateUserID();
        User newUser;

        if ("ADMIN".equals(role)) {
            newUser = new AdminUser(userID, name, email, password, phone, "REGULAR");
        } else {
            newUser = new CustomerUser(userID, name, email, password, phone, "BASIC");
        }

        String usersPath = getDataPath("users.txt", request);
        boolean success = UserFileHandler.addUser(newUser, usersPath);

        if (success) {
            response.sendRedirect("/login");
        } else {
            response.sendRedirect("/register?error=true");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String usersPath = getDataPath("users.txt", request);
        User user = UserFileHandler.getUserByEmail(email, usersPath);

        if (user != null && user.getPassword().equals(password)) {
            request.getSession().setAttribute("user", user);
            response.sendRedirect("/profile");
        } else {
            response.sendRedirect("/login?error=true");
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.sendRedirect("/login");
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        sessionUser.setName(name);
        sessionUser.setPhone(phone);
        sessionUser.setEmail(email);

        String usersPath = getDataPath("users.txt", request);
        UserFileHandler.updateUser(sessionUser, usersPath);

        request.getSession().setAttribute("user", sessionUser);
        response.sendRedirect("/profile");
    }
}