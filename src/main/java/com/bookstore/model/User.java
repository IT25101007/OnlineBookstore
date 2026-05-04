package com.bookstore.model;

public class User {
    // Encapsulated fields
    private String userID;
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role;

    // No-args constructor
    public User() {
    }

    // Full constructor
    public User(String userID, String name, String email, String password, String phone, String role) {
        this.userID = userID;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
    }

    // Getters and Setters
    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Convert to file string format: userID | name | email | password | phone | role
    public String toFileString() {
        return userID + " | " + name + " | " + email + " | " + password + " | " + phone + " | " + role;
    }

    // Parse from file string
    public static User fromFileString(String line) {
        String[] parts = line.split(" \\| ");
        if (parts.length == 6) {
            return new User(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
        }
        return null;
    }

    // Display info - to be overridden by subclasses (polymorphism)
    public void displayInfo() {
        System.out.println("User: " + name + " | Email: " + email);
    }

    @Override
    public String toString() {
        return "User{" +
                "userID='" + userID + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}