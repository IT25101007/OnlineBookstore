package com.bookstore.model;

public class EBook extends Book {
    private String downloadURL;

    public EBook() {
        super();
        setType("EBOOK");
    }

    public EBook(String bookID, String title, String author, String category, double price, int stock, String downloadURL) {
        super(bookID, title, author, category, price, stock, "EBOOK");
        this.downloadURL = downloadURL;
    }

    public String getDownloadURL() {
        return downloadURL;
    }

    public void setDownloadURL(String downloadURL) {
        this.downloadURL = downloadURL;
    }

    // Polymorphism - implementing abstract method
    @Override
    public String displayFormat() {
        return "E-Book: " + getTitle() + " by " + getAuthor() + " | Download: " + downloadURL;
    }

    @Override
    public String toString() {
        return "EBook{" +
                "bookID='" + getBookID() + '\'' +
                ", title='" + getTitle() + '\'' +
                ", author='" + getAuthor() + '\'' +
                ", price=" + getPrice() +
                ", downloadURL='" + downloadURL + '\'' +
                '}';
    }
}
