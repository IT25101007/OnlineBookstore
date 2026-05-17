package com.bookstore.controller;

import com.bookstore.filehandler.UserFileHandler;
import com.bookstore.model.User;
import com.bookstore.model.CustomerUser;
import com.bookstore.model.AdminUser;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class UserController {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName) {
        String projectPath = System.getProperty("user.dir");
        return projectPath + "/" + DATA_FOLDER + fileName;
    }

    @GetMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session) {
        String usersPath = getDataPath("users.txt");
        User user = UserFileHandler.getUserByEmail(email, usersPath);

        if (user != null && user.getPassword().equals(password)) {
            session.setAttribute("user", user);
            if ("ADMIN".equals(user.getRole())) {
                return "redirect:/admin/dashboard";
            }
            return "redirect:/";
        }
        return "redirect:/login?error=true";
    }

    @GetMapping("/register")
    public String registerForm() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String name,
                           @RequestParam String email,
                           @RequestParam String password,
                           @RequestParam(required = false) String phone,
                           @RequestParam String role) {
        String usersPath = getDataPath("users.txt");
        String userID = IDGenerator.generateUserID();

        User newUser;
        if ("ADMIN".equals(role)) {
            newUser = new AdminUser(userID, name, email, password, phone, "REGULAR");
        } else {
            newUser = new CustomerUser(userID, name, email, password, phone, "BASIC");
        }

        UserFileHandler.addUser(newUser, usersPath);
        return "redirect:/login";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/profile")
    public String updateProfile(@RequestParam String name,
                                @RequestParam String email,
                                @RequestParam String phone,
                                HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);

        String usersPath = getDataPath("users.txt");
        UserFileHandler.updateUser(user, usersPath);
        session.setAttribute("user", user);
        return "redirect:/profile";
    }

    @GetMapping("/users")
    public String listUsers(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            return "redirect:/books";
        }

        String usersPath = getDataPath("users.txt");
        List<User> users = UserFileHandler.getAllUsers(usersPath);
        model.addAttribute("users", users);
        return "userList";
    }

    @PostMapping("/users")
    public String deleteUser(@RequestParam String action,
                             @RequestParam String userID,
                             HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            return "redirect:/books";
        }

        if ("delete".equals(action) && !userID.equals(currentUser.getUserID())) {
            String usersPath = getDataPath("users.txt");
            UserFileHandler.deleteUser(userID, usersPath);
        }
        return "redirect:/users";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}