package com.bookstore.controller;

import com.bookstore.filehandler.CartFileHandler;
import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.model.Cart;
import com.bookstore.model.Book;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class CartController {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName) {
        String projectPath = System.getProperty("user.dir");
        return projectPath + "/" + DATA_FOLDER + fileName;
    }

    @GetMapping("/cart")
    public String viewCart(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        String cartPath = getDataPath("cart.txt");
        String booksPath = getDataPath("books.txt");

        List<Cart> cartItems = CartFileHandler.getCartByUserID(user.getUserID(), cartPath);
        List<CartItemDisplay> displayItems = new ArrayList<>();
        double cartTotal = 0.0;

        for (Cart item : cartItems) {
            Book book = BookFileHandler.getBookByID(item.getBookID(), booksPath);
            if (book != null) {
                double subtotal = book.getPrice() * item.getQuantity();
                cartTotal += subtotal;
                displayItems.add(new CartItemDisplay(item, book, subtotal));
            }
        }

        model.addAttribute("cartItems", displayItems);
        model.addAttribute("cartTotal", String.format("%.2f", cartTotal));
        return "cart";
    }

    @PostMapping("/cart/add")
    public String addToCart(@RequestParam String bookID,
                            @RequestParam(defaultValue = "1") int quantity,
                            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        String cartPath = getDataPath("cart.txt");
        String cartID = IDGenerator.generateCartID();
        Cart cartItem = new Cart(cartID, user.getUserID(), bookID, quantity);
        CartFileHandler.addToCart(cartItem, cartPath);

        return "redirect:/cart";
    }

    @PostMapping("/cart/update")
    public String updateCart(@RequestParam String cartID,
                             @RequestParam int quantity) {
        String cartPath = getDataPath("cart.txt");

        if (quantity <= 0) {
            CartFileHandler.removeFromCart(cartID, cartPath);
        } else {
            CartFileHandler.updateCartQuantity(cartID, quantity, cartPath);
        }
        return "redirect:/cart";
    }

    @PostMapping("/cart/remove")
    public String removeFromCart(@RequestParam String cartID) {
        String cartPath = getDataPath("cart.txt");
        CartFileHandler.removeFromCart(cartID, cartPath);
        return "redirect:/cart";
    }


    public static class CartItemDisplay {
        private Cart cart;
        private Book book;
        private double subtotal;

        public CartItemDisplay(Cart cart, Book book, double subtotal) {
            this.cart = cart;
            this.book = book;
            this.subtotal = subtotal;
        }
        public Cart getCart() { return cart; }
        public Book getBook() { return book; }
        public double getSubtotal() { return subtotal; }
    }
}
// updated