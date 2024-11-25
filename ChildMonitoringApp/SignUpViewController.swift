//
//  SignUpViewController.swift
//  ChildMonitoringApp
//
//  Created by Benitha Sri Panchagiri on 11/11/24.
//

import UIKit
import SQLite3

class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    let dbHelper = DatabaseHelper()
    
//    if DatabaseHelper.shared.insertUser(username: "example", password: "password") {
//        print("User registered successfully")
//    } else {
//        print("Failed to register user")
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

            passwordTextField.isSecureTextEntry = true
            confirmPasswordTextField.isSecureTextEntry = true
        registerButton.isEnabled = false // Initial state is disabled
    }
    
    let appDelegate = UIApplication  .shared.delegate as! AppDelegate
    
    
    @IBAction func textFieldsChanged(_ sender: Any) {
        // Retrieve the text values entered by the user in the password fields
            let password = passwordTextField.text ?? ""
            let confirmPassword = confirmPasswordTextField.text ?? ""

            // Check if both fields are non-empty and the passwords match
            if !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword {
                registerButton.isEnabled = true // Enable the register button if both passwords match
            } else {
                registerButton.isEnabled = false // Disable the button if passwords don't match or fields are empty
            }
        }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
           let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
           let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

           // Double-check passwords match (extra safety)
           guard password == confirmPassword else {
               showAlert(title: "Error", message: "Passwords do not match!")
               return
           }

           // Attempt to register the user
           if dbHelper.insertUser(username: username, password: password) {
               showAlert(title: "Success", message: "User registered successfully!") {
                   self.navigateToLoginView()
               }
           } else {
               showAlert(title: "Error", message: "Failed to register user.")
           }
    }
    
    func registerUser(username: String, password: String) -> Bool {
        var stmt: OpaquePointer?
                let insertQuery = "INSERT INTO Users (username, password) VALUES (?, ?);"

                if sqlite3_prepare_v2(appDelegate.db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
                    sqlite3_bind_text(stmt, 1, (username as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(stmt, 2, (password as NSString).utf8String, -1, nil)

                    if sqlite3_step(stmt) == SQLITE_DONE {
                        print("Data inserted successfully")
                        sqlite3_finalize(stmt)
                        return true
                    } else {
                        print("Error inserting data")
                    }
                } else {
                    print("Error preparing statement")
                }
                
                sqlite3_finalize(stmt)
                return false
            
        }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            })
            present(alert, animated: true, completion: nil)
        }
    
    func navigateToLoginView() {
            // Assuming you have a segue setup with identifier "goToLogin"
            performSegue(withIdentifier: "goToLogin", sender: self)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
