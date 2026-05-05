package com.bookstore.model;

public class Admin {
    // Encapsulated fields
    private String adminID;
    private String name;
    private String email;
    private String password;
    private String role; // SUPER_ADMIN, REPORT_ADMIN, etc.

    // No-args constructor
    public Admin() {
    }

    // Full constructor
    public Admin(String adminID, String name, String email, String password, String role) {
        this.adminID = adminID;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // Getters and Setters
    public String getAdminID() {
        return adminID;
    }

    public void setAdminID(String adminID) {
        this.adminID = adminID;
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Convert to file string
    public String toFileString() {
        return adminID + " | " + name + " | " + email + " | " + password + " | " + role;
    }

    // Parse from file string
    public static Admin fromFileString(String line) {
        String[] parts = line.split(" \\| ");
        if (parts.length == 5) {
            return new Admin(parts[0], parts[1], parts[2], parts[3], parts[4]);
        }
        return null;
    }

    @Override
    public String toString() {
        return "Admin{" +
                "adminID='" + adminID + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}