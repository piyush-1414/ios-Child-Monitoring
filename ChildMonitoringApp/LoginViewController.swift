//
//  LoginViewController.swift
//  ChildMonitoringApp
//
//  Created by Benitha Sri Panchagiri on 11/11/24.
//  Updated

import UIKit
import SQLite3

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    let dbHelper = DatabaseHelper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
//    if DatabaseHelper.shared.insertUser(username: username, password: password) {
//               print("User registered successfully")
//           } else {
//               print("Failed to register user")
//           }

        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginButton.isEnabled = true
        insertTestUser()
    }
    
    
    @IBAction func textFieldsChanged(_ sender: Any) {
        
        loginButton.isEnabled = !(usernameTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    }
    
    func insertTestUser() {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        // Call the insert function from the DatabaseHelper
        let success = DatabaseHelper.shared.insertUser(username: username, password: password)
        
        if success {
            print("User registered successfully")
            

        } else {
            print("Failed to register user")
        }
    }


    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let username = usernameTextField.text ?? ""
                let password = passwordTextField.text ?? ""
                
                if validateLogin(username: username, password: password) {
                    print("Login successful")
                    //showAlert(title: "Alert", message: "Login Successful ", viewController: self)
                } else {
                    print("Invalid username or password")
                    showAlert(title: "Alert", message: "Invalid username or password ", viewController: self)
                }
    }
    
    func validateLogin(username: String, password: String) -> Bool {
            var stmt: OpaquePointer?
            let selectQuery = "SELECT * FROM Users WHERE username = ? AND password = ?;"
            
            if sqlite3_prepare_v2(appDelegate.db, selectQuery, -1, &stmt, nil) == SQLITE_OK {
                sqlite3_bind_text(stmt, 1, (username as NSString).utf8String, -1, nil)
                sqlite3_bind_text(stmt, 2, (password as NSString).utf8String, -1, nil)
                
                if sqlite3_step(stmt) == SQLITE_ROW {
                    sqlite3_finalize(stmt)
                    return true
                } else {
                    print("User not found")
                }
            }
            
            sqlite3_finalize(stmt)
            return false
        }
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        // Create the alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an OK action
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Present the alert on the given view controller
        viewController.present(alert, animated: true, completion: nil)
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
