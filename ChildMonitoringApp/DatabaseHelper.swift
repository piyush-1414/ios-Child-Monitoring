//
//  DatabaseHelper.swift
//  ChildMonitoringApp
//
//  Created by Benitha Sri Panchagiri on 11/11/24.
//


import Foundation
import SQLite3

class DatabaseHelper {
    
    // Singleton instance
    static let shared = DatabaseHelper()
    
    var db: OpaquePointer?

    // Initialize database connection and create the table
    init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("UserDatabase.sqlite")
        var db: OpaquePointer? = nil

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        }
    }

    func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Users(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Username TEXT,
        Password TEXT);
        """
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table created.")
            } else {
                print("User table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    // Insert user
    func insertUser(username: String, password: String) -> Bool {
        let insertQuery = "INSERT INTO Users (Username, Password) VALUES (?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("User added successfully.")
                
                // Fetch and print the username and password
                let fetchedPassword = fetchPassword(for: username)
                print("Username: \(username), Password: \(fetchedPassword ?? "Not found")")
                
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Could not add user.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
        return false
    }

    // Fetch password
    func fetchPassword(for username: String) -> String? {
        let query = "SELECT Password FROM Users WHERE Username = ?;"
        var queryStatement: OpaquePointer?
        var password: String?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (username as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                password = String(cString: sqlite3_column_text(queryStatement, 0))
            } else {
                print("No record found")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return password
    }

    // Update user password
    func updateUser(username: String, newPassword: String) -> Bool {
        let updateQuery = "UPDATE Users SET Password = ? WHERE Username = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (newPassword as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (username as NSString).utf8String, -1, nil)
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Password updated successfully.")
                sqlite3_finalize(updateStatement)
                return true
            } else {
                print("Could not update password.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        
        sqlite3_finalize(updateStatement)
        return false
    }

    // Delete user
    func deleteUser(username: String) -> Bool {
        let deleteQuery = "DELETE FROM Users WHERE Username = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (username as NSString).utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("User deleted successfully.")
                sqlite3_finalize(deleteStatement)
                return true
            } else {
                print("Could not delete user.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        
        sqlite3_finalize(deleteStatement)
        return false
    }
}
