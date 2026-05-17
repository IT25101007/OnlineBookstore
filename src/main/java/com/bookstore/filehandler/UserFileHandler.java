package com.bookstore.filehandler;

import com.bookstore.model.User;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class UserFileHandler {

    /**
     * Reads all users from the file
     */
    public static List<User> getAllUsers(String filePath) {
        List<User> users = new ArrayList<>();
        try {
            Path path = Paths.get(filePath);
            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                for (String line : lines) {
                    String trimmedLine = line.trim();
                    if (!trimmedLine.isEmpty()) {
                        User user = User.fromFileString(trimmedLine);
                        if (user != null) {
                            users.add(user);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading users file: " + e.getMessage());
        }
        return users;
    }

    /**
     * Writes all users back to file (overwrites file)
     */
    public static void saveAllUsers(List<User> users, String filePath) {
        try {
            Path path = Paths.get(filePath);
            // Ensure parent directory exists
            Files.createDirectories(path.getParent());

            List<String> lines = new ArrayList<>();
            for (User user : users) {
                lines.add(user.toFileString());
            }
            Files.write(path, lines);
        } catch (IOException e) {
            System.err.println("Error saving users file: " + e.getMessage());
        }
    }

    /**
     * Finds and returns user with matching ID
     */
    public static User getUserByID(String userID, String filePath) {
        List<User> users = getAllUsers(filePath);
        for (User user : users) {
            if (user.getUserID().equals(userID)) {
                return user;
            }
        }
        return null;
    }

    /**
     * Finds and returns user with matching email (for login authentication)
     */
    public static User getUserByEmail(String email, String filePath) {
        List<User> users = getAllUsers(filePath);
        for (User user : users) {
            if (user.getEmail().equalsIgnoreCase(email)) {
                return user;
            }
        }
        return null;
    }

    /**
     * Appends a new user to the file
     */
    public static boolean addUser(User user, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());
            // Append to file
            Files.write(path, (user.toFileString() + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);
            return true;
        } catch (IOException e) {
            System.err.println("Error adding user: " + e.getMessage());
            return false;
        }
    }

    /**
     * Updates an existing user
     */
    public static boolean updateUser(User updatedUser, String filePath) {
        List<User> users = getAllUsers(filePath);
        boolean found = false;

        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserID().equals(updatedUser.getUserID())) {
                users.set(i, updatedUser);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllUsers(users, filePath);
            return true;
        }
        return false;
    }

    /**
     * Deletes a user by ID
     */
    public static boolean deleteUser(String userID, String filePath) {
        List<User> users = getAllUsers(filePath);
        boolean removed = users.removeIf(user -> user.getUserID().equals(userID));

        if (removed) {
            saveAllUsers(users, filePath);
            return true;
        }
        return false;
    }
}