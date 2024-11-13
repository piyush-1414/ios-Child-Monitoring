import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db: OpaquePointer?

    func openDatabase() -> OpaquePointer? {
        // Locate the path for the database
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("UserDatabase.sqlite")

        // Open database connection
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Database opened successfully at \(fileURL.path)")
            return db
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error opening database: \(errorMessage)")
            return nil
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        db = openDatabase()
        createTables()
        return true
    }

    func createTables() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
        );
        """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error creating table: \(errorMessage)")
        } else {
            print("Table created or already exists")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if sqlite3_close(db) == SQLITE_OK {
            print("Database closed successfully")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error closing database: \(errorMessage)")
        }
    }
}
