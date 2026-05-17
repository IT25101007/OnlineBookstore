package com.bookstore.filehandler;

import com.bookstore.model.Book;
import com.bookstore.model.EBook;
import com.bookstore.model.PrintedBook;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class BookFileHandler {

    public static List<Book> getAllBooks(String filePath) {
        List<Book> books = new ArrayList<>();
        try {
            Path path = Paths.get(filePath);
            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                for (String line : lines) {
                    String trimmedLine = line.trim();
                    if (!trimmedLine.isEmpty()) {
                        Book book = Book.fromFileString(trimmedLine);
                        if (book != null) {
                            books.add(book);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading books file: " + e.getMessage());
        }
        return books;
    }

    public static void saveAllBooks(List<Book> books, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());

            List<String> lines = new ArrayList<>();
            for (Book book : books) {
                lines.add(book.toFileString());
            }
            Files.write(path, lines);
        } catch (IOException e) {
            System.err.println("Error saving books file: " + e.getMessage());
        }
    }

    public static Book getBookByID(String bookID, String filePath) {
        List<Book> books = getAllBooks(filePath);
        for (Book book : books) {
            if (book.getBookID().equals(bookID)) {
                return book;
            }
        }
        return null;
    }

    /**
     * Searches books by title, author, or category (case-insensitive contains)
     */
    public static List<Book> searchBooks(String keyword, String filePath) {
        List<Book> books = getAllBooks(filePath);
        List<Book> results = new ArrayList<>();
        String lowerKeyword = keyword.toLowerCase();

        for (Book book : books) {
            if (book.getTitle().toLowerCase().contains(lowerKeyword) ||
                    book.getAuthor().toLowerCase().contains(lowerKeyword) ||
                    book.getCategory().toLowerCase().contains(lowerKeyword)) {
                results.add(book);
            }
        }
        return results;
    }

    public static boolean addBook(Book book, String filePath) {
        try {
            Path path = Paths.get(filePath);
            Files.createDirectories(path.getParent());
            Files.write(path, (book.toFileString() + System.lineSeparator()).getBytes(),
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);
            return true;
        } catch (IOException e) {
            System.err.println("Error adding book: " + e.getMessage());
            return false;
        }
    }

    public static boolean updateBook(Book updatedBook, String filePath) {
        List<Book> books = getAllBooks(filePath);
        boolean found = false;

        for (int i = 0; i < books.size(); i++) {
            if (books.get(i).getBookID().equals(updatedBook.getBookID())) {
                books.set(i, updatedBook);
                found = true;
                break;
            }
        }

        if (found) {
            saveAllBooks(books, filePath);
            return true;
        }
        return false;
    }

    public static boolean deleteBook(String bookID, String filePath) {
        List<Book> books = getAllBooks(filePath);
        boolean removed = books.removeIf(book -> book.getBookID().equals(bookID));

        if (removed) {
            saveAllBooks(books, filePath);
            return true;
        }
        return false;
    }

}
