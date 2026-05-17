package com.bookstore.filehandler;

import com.bookstore.model.Cart;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class CartFileHandler {

    public static List<Cart> getAllCartItems(String filePath) {
        List<Cart> cartItems = new ArrayList<>();
        try {
            Path path = Paths.get(filePath);
            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                for (String line : lines) {
                    String trimmedLine = line.trim();
                    if (!trimmedLine.isEmpty()) {
                        Cart cart = Cart.fromFileString(trimmedLine);
                        if (cart != null) {
                            cartItems.add(cart);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading cart file: " + e.getMessage());
        }
        return cartItems;
    }

    public static void saveAllCartItems(List<Cart> items, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());

            List<String> lines = new ArrayList<>();
            for (Cart item : items) {
                lines.add(item.toFileString());
            }
            Files.write(path, lines);
        } catch (IOException e) {
            System.err.println("Error saving cart file: " + e.getMessage());
        }
    }

    public static List<Cart> getCartByUserID(String userID, String filePath) {
        List<Cart> allItems = getAllCartItems(filePath);
        List<Cart> userCart = new ArrayList<>();
        for (Cart item : allItems) {
            if (item.getUserID().equals(userID)) {
                userCart.add(item);
            }
        }
        return userCart;
    }

    public static boolean addToCart(Cart cart, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());
            Files.write(path, (cart.toFileString() + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);
            return true;
        } catch (IOException e) {
            System.err.println("Error adding to cart: " + e.getMessage());
            return false;
        }
    }

    public static boolean updateCartQuantity(String cartID, int newQuantity, String filePath) {
        List<Cart> items = getAllCartItems(filePath);
        boolean found = false;

        for (int i = 0; i < items.size(); i++) {
            if (items.get(i).getCartID().equals(cartID)) {
                items.get(i).setQuantity(newQuantity);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllCartItems(items, filePath);
            return true;
        }
        return false;
    }

    public static boolean removeFromCart(String cartID, String filePath) {
        List<Cart> items = getAllCartItems(filePath);
        boolean removed = items.removeIf(item -> item.getCartID().equals(cartID));

        if (removed) {
            saveAllCartItems(items, filePath);
            return true;
        }
        return false;
    }

    public static boolean clearCartForUser(String userID, String filePath) {
        List<Cart> items = getAllCartItems(filePath);
        boolean removed = items.removeIf(item -> item.getUserID().equals(userID));

        if (removed) {
            saveAllCartItems(items, filePath);
            return true;
        }
        return false;
    }
}
// updated