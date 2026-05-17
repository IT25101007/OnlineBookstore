package com.bookstore.controller;

import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.filehandler.BookInventoryFileHandler;
import com.bookstore.model.Book;
import com.bookstore.model.BookInventory;
import com.bookstore.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class BookInventoryController {
    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName) {
        String projectPath = System.getProperty("user.dir");
        return projectPath + "/" + DATA_FOLDER + fileName;
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    @GetMapping("/admin/inventory")
    public String viewInventory(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/books";
        }

        String booksPath = getDataPath("books.txt");
        List<Book> books = BookFileHandler.getAllBooks(booksPath);
        List<BookInventory> inventoryList = BookInventoryFileHandler.getAllInventory(booksPath);

        model.addAttribute("books", books);
        model.addAttribute("inventoryList", inventoryList);
        model.addAttribute("lowStockCount", BookInventoryFileHandler.countLowStockBooks(booksPath));
        model.addAttribute("outOfStockCount", BookInventoryFileHandler.countOutOfStockBooks(booksPath));
        return "adminBooks";
    }

    @PostMapping("/inventory/update")
    public String updateInventory(@RequestParam String bookID,
                                  @RequestParam int stock,
                                  HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/books";
        }

        String booksPath = getDataPath("books.txt");
        BookInventoryFileHandler.setStock(bookID, stock, booksPath);
        return "redirect:/admin/books?saved=true";
    }
}
