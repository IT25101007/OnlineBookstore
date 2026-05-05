package com.bookstore.filehandler;

import com.bookstore.model.Admin;
import com.bookstore.model.Payment;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class AdminFileHandler {

    public static List<Admin> getAllAdmins(String filePath) {
        List<Admin> admins = new ArrayList<>();
        try {
            Path path = Paths.get(filePath);
            System.out.println("Looking for admins file at: " + path.toAbsolutePath());

            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                System.out.println("Found " + lines.size() + " lines in admins file");

                for (String line : lines) {
                    String trimmedLine = line.trim();
                    if (!trimmedLine.isEmpty()) {
                        Admin admin = Admin.fromFileString(trimmedLine);
                        if (admin != null) {
                            admins.add(admin);
                            System.out.println("Loaded admin: " + admin.getEmail());
                        }
                    }
                }
            } else {
                System.out.println("Admins file does not exist at: " + path.toAbsolutePath());
                // Create the file with default admin if it doesn't exist
                createDefaultAdminsFile(filePath);
                return getAllAdmins(filePath); // Recursive call to read the newly created file
            }
        } catch (IOException e) {
            System.err.println("Error reading admins file: " + e.getMessage());
            e.printStackTrace();
        }
        return admins;
    }

    private static void createDefaultAdminsFile(String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());

            List<String> defaultAdmins = Arrays.asList(
                    "ADM1001 | Super Admin | super@bookstore.com | super123 | SUPER_ADMIN",
                    "ADM1002 | Report Admin | report@bookstore.com | report123 | REPORT_ADMIN"
            );

            Files.write(path, defaultAdmins);
            System.out.println("Created default admins file at: " + path.toAbsolutePath());
        } catch (IOException e) {
            System.err.println("Error creating default admins file: " + e.getMessage());
        }
    }

    public static void saveAllAdmins(List<Admin> admins, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());

            List<String> lines = new ArrayList<>();
            for (Admin admin : admins) {
                lines.add(admin.toFileString());
            }
            Files.write(path, lines);
            System.out.println("Saved " + admins.size() + " admins to file");
        } catch (IOException e) {
            System.err.println("Error saving admins file: " + e.getMessage());
        }
    }

    public static Admin getAdminByEmail(String email, String filePath) {
        List<Admin> admins = getAllAdmins(filePath);
        for (Admin admin : admins) {
            if (admin.getEmail().equalsIgnoreCase(email)) {
                return admin;
            }
        }
        return null;
    }

    public static Admin getAdminByID(String adminID, String filePath) {
        List<Admin> admins = getAllAdmins(filePath);
        for (Admin admin : admins) {
            if (admin.getAdminID().equals(adminID)) {
                return admin;
            }
        }
        return null;
    }

    public static boolean addAdmin(Admin admin, String filePath) {
        try {
            List<Admin> admins = getAllAdmins(filePath);
            admins.add(admin);
            saveAllAdmins(admins, filePath);
            System.out.println("Added new admin: " + admin.getEmail());
            return true;
        } catch (Exception e) {
            System.err.println("Error adding admin: " + e.getMessage());
            return false;
        }
    }

    public static boolean updateAdmin(Admin updatedAdmin, String filePath) {
        List<Admin> admins = getAllAdmins(filePath);
        boolean found = false;

        for (int i = 0; i < admins.size(); i++) {
            if (admins.get(i).getAdminID().equals(updatedAdmin.getAdminID())) {
                admins.set(i, updatedAdmin);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllAdmins(admins, filePath);
            return true;
        }
        return false;
    }

    public static boolean deleteAdmin(String adminID, String filePath) {
        List<Admin> admins = getAllAdmins(filePath);
        boolean removed = admins.removeIf(admin -> admin.getAdminID().equals(adminID));

        if (removed) {
            saveAllAdmins(admins, filePath);
            System.out.println("Deleted admin with ID: " + adminID);
            return true;
        }
        return false;
    }

    public static long countAllUsers(String usersFilePath) {
        return UserFileHandler.getAllUsers(usersFilePath).size();
    }

    public static long countAllOrders(String ordersFilePath) {
        return OrderFileHandler.getAllOrders(ordersFilePath).size();
    }

    public static double sumAllRevenue(String paymentsFilePath) {
        List<Payment> payments = PaymentFileHandler.getAllPayments(paymentsFilePath);
        double total = 0.0;
        for (Payment payment : payments) {
            if ("COMPLETED".equalsIgnoreCase(payment.getStatus())) {
                total += payment.getAmount();
            }
        }
        return total;
    }
}