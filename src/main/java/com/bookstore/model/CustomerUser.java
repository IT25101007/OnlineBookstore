package com.bookstore.model;

public class CustomerUser extends User {
    private String membershipType;

    public CustomerUser() {
        super();
        setRole("CUSTOMER");
        this.membershipType = "BASIC";
    }

    public CustomerUser(String userID, String name, String email, String password, String phone, String membershipType) {
        super(userID, name, email, password, phone, "CUSTOMER");
        this.membershipType = membershipType;
    }

    public String getMembershipType() {
        return membershipType;
    }

    public void setMembershipType(String membershipType) {
        this.membershipType = membershipType;
    }

    // Polymorphism - getDiscount based on membership type
    public double getDiscount() {
        if ("PREMIUM".equalsIgnoreCase(membershipType)) {
            return 0.10;
        }
        return 0.0;
    }

    @Override
    public void displayInfo() {
        System.out.println("Customer: " + getName() + " | Membership: " + membershipType + " | Discount: " + (getDiscount() * 100) + "%");
    }

    @Override
    public String toString() {
        return "CustomerUser{" +
                "userID='" + getUserID() + '\'' +
                ", name='" + getName() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", membershipType='" + membershipType + '\'' +
                '}';
    }
}