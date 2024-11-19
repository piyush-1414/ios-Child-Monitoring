import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db: OpaquePointer?

    /// Opens or creates the SQLite database
    func openDatabase() -> OpaquePointer? {
        do {
            // Locate the path for the database in the Documents directory
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("UserDatabase.sqlite")

            // Print database location (useful for debugging)
            print("Database path: \(fileURL.path)")

            // Open database connection
            if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
                print("Database opened successfully")
                return db
            } else {
                if let error = sqlite3_errmsg(db) {
                    print("Error opening database: \(String(cString: error))")
                }
                return nil
            }
        } catch {
            print("Error getting file URL: \(error)")
            return nil
        }
    }

    /// Creates required tables in the database
    func createTables() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
        );
        """
        
        // Execute the query and check for errors
        let result = sqlite3_exec(db, createTableQuery, nil, nil, nil)
        
        if result != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error creating table: \(errorMessage)")
        } else {
            print("User table created successfully.")
        }
    }


    /// Closes the SQLite database when the application is terminated
    func closeDatabase() {
        if sqlite3_close(db) == SQLITE_OK {
            print("Database closed successfully")
        } else {
            if let error = sqlite3_errmsg(db) {
                print("Error closing database: \(String(cString: error))")
            }
        }
    }

    // MARK: - UIApplication Lifecycle

    /// Called when the app finishes launching
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Open the database
        db = openDatabase()
        
        // Create tables
        if db != nil {
            createTables()
        }
        
        return true
    }

    /// Called when the app is about to terminate
    func applicationWillTerminate(_ application: UIApplication) {
        // Close the database
        closeDatabase()
    }

    /// Called when the app enters the background (optional, for data safety)
    func applicationDidEnterBackground(_ application: UIApplication) {
        closeDatabase()
    }

    /// Called when the app becomes active again (optional, for data safety)
    func applicationWillEnterForeground(_ application: UIApplication) {
        db = openDatabase()
    }
}

