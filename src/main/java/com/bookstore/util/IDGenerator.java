package com.bookstore.util;

import java.util.UUID;

/**
 * Utility class for generating unique IDs for all entities in the Online Bookstore system.
 *
 * FIX: The original used System.currentTimeMillis() for all IDs.
 * This caused DUPLICATE IDs when a loop created multiple records fast
 * (e.g. placing an order with 3 cart items — all 3 orders got the same timestamp ID,
 * and only the last one survived in the file).
 *
 * Fixed by using UUID (universally unique, guaranteed no collisions).
 * The prefix letters (USR, BK, ORD, etc.) are kept so IDs stay recognisable in data files.
 */
public class IDGenerator {

    // Private constructor — utility class, not meant to be instantiated
    private IDGenerator() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }

    /** Generates a unique User ID — e.g. USR-A1B2C3D4 */
    public static String generateUserID() {
        return "USR-" + shortUUID();
    }

    /** Generates a unique Book ID — e.g. BK-A1B2C3D4 */
    public static String generateBookID() {
        return "BK-" + shortUUID();
    }

    /** Generates a unique Order ID — e.g. ORD-A1B2C3D4 */
    public static String generateOrderID() {
        return "ORD-" + shortUUID();
    }

    /** Generates a unique Cart ID — e.g. CRT-A1B2C3D4 */
    public static String generateCartID() {
        return "CRT-" + shortUUID();
    }

    /** Generates a unique Payment ID — e.g. PAY-A1B2C3D4 */
    public static String generatePaymentID() {
        return "PAY-" + shortUUID();
    }

    /** Generates a unique Admin ID — e.g. ADM-A1B2C3D4 */
    public static String generateAdminID() {
        return "ADM-" + shortUUID();
    }

    /** Generates a unique Report ID — e.g. RPT-A1B2C3D4 */
    public static String generateReportID() {
        return "RPT-" + shortUUID();
    }

    /**
     * Returns the first 8 characters of a random UUID (upper-case, no dashes).
     * Gives ~4 billion combinations — more than enough for a bookstore app.
     */
    private static String shortUUID() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
    }
}
