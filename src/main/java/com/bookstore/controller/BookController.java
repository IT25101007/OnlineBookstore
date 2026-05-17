package com.bookstore.controller;

import com.bookstore.filehandler.BookFileHandler;
import com.bookstore.model.Book;
import com.bookstore.model.EBook;
import com.bookstore.model.PrintedBook;
import com.bookstore.model.User;
import com.bookstore.util.IDGenerator;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class BookController {

    private static final String DATA_FOLDER = "data/";

    private String getDataPath(String fileName) {
        String projectPath = System.getProperty("user.dir");
        return projectPath + "/" + DATA_FOLDER + fileName;
    }

    @GetMapping("/books")
    public String listBooks(@RequestParam(required = false) String search, Model model) {
        String booksPath = getDataPath("books.txt");
        List<Book> books;
        if (search != null && !search.trim().isEmpty()) {
            books = BookFileHandler.searchBooks(search, booksPath);
        } else {
            books = BookFileHandler.getAllBooks(booksPath);
        }
        model.addAttribute("books", books);
        return "bookList";
    }

    @GetMapping("/book/detail")
    public String bookDetail(@RequestParam String bookID, Model model) {
        String booksPath = getDataPath("books.txt");
        Book book = BookFileHandler.getBookByID(bookID, booksPath);
        model.addAttribute("book", book);
        return "bookDetail";
    }

    @GetMapping("/book/add")
    public String showAddBookForm(Model model) {
        model.addAttribute("action", "add");
        return "addEditBook";
    }

    @PostMapping("/book/add")
    public String addBook(@RequestParam String title,
                          @RequestParam String author,
                          @RequestParam String category,
                          @RequestParam double price,
                          @RequestParam int stock,
                          @RequestParam String type,
                          @RequestParam(required = false) String downloadURL,
                          @RequestParam(required = false) Integer pageCount) {
        String booksPath = getDataPath("books.txt");
        String bookID = IDGenerator.generateBookID();

        Book newBook;
        if ("EBOOK".equals(type)) {
            newBook = new EBook(bookID, title, author, category, price, stock, downloadURL != null ? downloadURL : "");
        } else {
            newBook = new PrintedBook(bookID, title, author, category, price, stock, pageCount != null ? pageCount : 0);
        }
        BookFileHandler.addBook(newBook, booksPath);
        return "redirect:/books";
    }

    @GetMapping("/book/edit")
    public String showEditBookForm(@RequestParam String bookID, Model model) {
        String booksPath = getDataPath("books.txt");
        Book book = BookFileHandler.getBookByID(bookID, booksPath);
        model.addAttribute("action", "edit");
        model.addAttribute("book", book);
        return "addEditBook";
    }

    @PostMapping("/book/edit")
    public String editBook(@RequestParam String bookID,
                           @RequestParam String title,
                           @RequestParam String author,
                           @RequestParam String category,
                           @RequestParam double price,
                           @RequestParam int stock,
                           @RequestParam String type,
                           @RequestParam(required = false) String downloadURL,
                           @RequestParam(required = false) Integer pageCount) {
        String booksPath = getDataPath("books.txt");

        if ("EBOOK".equals(type)) {
            EBook ebook = new EBook(bookID, title, author, category, price, stock, downloadURL != null ? downloadURL : "");
            BookFileHandler.updateBook(ebook, booksPath);
        } else {
            PrintedBook printedBook = new PrintedBook(bookID, title, author, category, price, stock, pageCount != null ? pageCount : 0);
            BookFileHandler.updateBook(printedBook, booksPath);
        }
        return "redirect:/books";
    }

    @PostMapping("/book/delete")
    public String deleteBook(@RequestParam String bookID) {
        String booksPath = getDataPath("books.txt");
        BookFileHandler.deleteBook(bookID, booksPath);
        return "redirect:/books";
    }
}