package com.bookstore.model;

public class AdminUser extends User {
    private String adminLevel;

    public AdminUser() {
        super();
        setRole("ADMIN");
    }

    public AdminUser(String userID, String name, String email, String password, String phone, String adminLevel) {
        super(userID, name, email, password, phone, "ADMIN");
        this.adminLevel = adminLevel;
    }

    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }

    @Override
    public void displayInfo() {
        System.out.println("Admin User: " + getName() + " | Level: " + adminLevel);
    }

    @Override
    public String toString() {
        return "AdminUser{" +
                "userID='" + getUserID() + '\'' +
                ", name='" + getName() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", adminLevel='" + adminLevel + '\'' +
                '}';
    }
}
//Updated