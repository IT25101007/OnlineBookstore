package com.bookstore.model;

public class BookInventory {
    private String bookID;
    private int stock;
    private int reorderLevel;

    public BookInventory() {
    }

    public BookInventory(String bookID, int stock, int reorderLevel) {
        this.bookID = bookID;
        this.stock = stock;
        this.reorderLevel = reorderLevel;
    }

    public String getBookID() {
        return bookID;
    }

    public void setBookID(String bookID) {
        this.bookID = bookID;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = reorderLevel;
    }

    public boolean isOutOfStock() {
        return stock <= 0;
    }

    public boolean isLowStock() {
        return stock > 0 && stock < reorderLevel;
    }

    public String getStatus() {
        if (isOutOfStock()) {
            return "OUT_OF_STOCK";
        }
        if (isLowStock()) {
            return "LOW_STOCK";
        }
        return "AVAILABLE";
    }
}
