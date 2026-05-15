package com.bookstore.filehandler;

import com.bookstore.model.Order;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class OrderFileHandler {

    public static List<Order> getAllOrders(String filePath) {
        List<Order> orders = new ArrayList<>();
        try {
            Path path = Paths.get(filePath);
            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                for (String line : lines) {
                    String trimmedLine = line.trim();
                    if (!trimmedLine.isEmpty()) {
                        Order order = Order.fromFileString(trimmedLine);
                        if (order != null) {
                            orders.add(order);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading orders file: " + e.getMessage());
        }
        return orders;
    }

    public static void saveAllOrders(List<Order> orders, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());

            List<String> lines = new ArrayList<>();
            for (Order order : orders) {
                lines.add(order.toFileString());
            }
            Files.write(path, lines);
        } catch (IOException e) {
            System.err.println("Error saving orders file: " + e.getMessage());
        }
    }

    public static Order getOrderByID(String orderID, String filePath) {
        List<Order> orders = getAllOrders(filePath);
        for (Order order : orders) {
            if (order.getOrderID().equals(orderID)) {
                return order;
            }
        }
        return null;
    }

    public static List<Order> getOrdersByUserID(String userID, String filePath) {
        List<Order> orders = getAllOrders(filePath);
        List<Order> userOrders = new ArrayList<>();
        for (Order order : orders) {
            if (order.getUserID().equals(userID)) {
                userOrders.add(order);
            }
        }
        return userOrders;
    }

    public static boolean addOrder(Order order, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());
            Files.write(path, (order.toFileString() + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);
            return true;
        } catch (IOException e) {
            System.err.println("Error adding order: " + e.getMessage());
            return false;
        }
    }

    public static boolean updateOrderStatus(String orderID, String newStatus, String filePath) {
        Order order = getOrderByID(orderID, filePath);
        if (order != null) {
            order.setStatus(newStatus);
            return updateOrder(order, filePath);
        }
        return false;
    }

    private static boolean updateOrder(Order updatedOrder, String filePath) {
        List<Order> orders = getAllOrders(filePath);
        boolean found = false;

        for (int i = 0; i < orders.size(); i++) {
            if (orders.get(i).getOrderID().equals(updatedOrder.getOrderID())) {
                orders.set(i, updatedOrder);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllOrders(orders, filePath);
            return true;
        }
        return false;
    }

    public static boolean deleteOrder(String orderID, String filePath) {
        List<Order> orders = getAllOrders(filePath);
        boolean removed = orders.removeIf(order -> order.getOrderID().equals(orderID));

        if (removed) {
            saveAllOrders(orders, filePath);
            return true;
        }
        return false;
    }
}
// updated
