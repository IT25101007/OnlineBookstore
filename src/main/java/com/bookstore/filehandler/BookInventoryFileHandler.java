package com.bookstore.filehandler;

import com.bookstore.model.Book;
import com.bookstore.model.BookInventory;

import java.util.ArrayList;
import java.util.List;

public class BookInventoryFileHandler {
    private static final int REORDER_LEVEL = 5;

    public static List<BookInventory> getAllInventory(String filePath) {
        List<Book> books = BookFileHandler.getAllBooks(filePath);
        List<BookInventory> inventoryList = new ArrayList<>();

        for (Book book : books) {
            inventoryList.add(new BookInventory(book.getBookID(), book.getStock(), REORDER_LEVEL));
        }
        return inventoryList;
    }

    public static BookInventory getInventoryByBookID(String bookID, String filePath) {
        Book book = BookFileHandler.getBookByID(bookID, filePath);
        if (book == null) {
            return null;
        }
        return new BookInventory(book.getBookID(), book.getStock(), REORDER_LEVEL);
    }

    public static int getStock(String bookID, String filePath) {
        BookInventory inventory = getInventoryByBookID(bookID, filePath);
        if (inventory == null) {
            return 0;
        }
        return inventory.getStock();
    }

    public static boolean hasEnoughStock(String bookID, int quantity, String filePath) {
        BookInventory inventory = getInventoryByBookID(bookID, filePath);
        return inventory != null && quantity > 0 && inventory.getStock() >= quantity;
    }

    public static boolean setStock(String bookID, int stock, String filePath) {
        if (stock < 0) {
            return false;
        }

        Book book = BookFileHandler.getBookByID(bookID, filePath);
        if (book == null) {
            return false;
        }

        book.setStock(stock);
        return BookFileHandler.updateBook(book, filePath);
    }

    public static boolean reduceStock(String bookID, int quantity, String filePath) {
        if (!hasEnoughStock(bookID, quantity, filePath)) {
            return false;
        }

        Book book = BookFileHandler.getBookByID(bookID, filePath);
        int newStock = book.getStock() - quantity;
        book.setStock(newStock);
        return BookFileHandler.updateBook(book, filePath);
    }

    public static long countLowStockBooks(String filePath) {
        return getAllInventory(filePath).stream()
                .filter(BookInventory::isLowStock)
                .count();
    }

    public static long countOutOfStockBooks(String filePath) {
        return getAllInventory(filePath).stream()
                .filter(BookInventory::isOutOfStock)
                .count();
    }
}
