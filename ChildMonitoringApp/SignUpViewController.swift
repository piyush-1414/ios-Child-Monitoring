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
    
    
    @IBOutlet weak var registerButton: UIButton!
    
    let dbHelper = DatabaseHelper()
    
//    if DatabaseHelper.shared.insertUser(username: "example", password: "password") {
//        print("User registered successfully")
//    } else {
//        print("Failed to register user")
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let appDelegate = UIApplication  .shared.delegate as! AppDelegate
    
    @IBAction func textFieldsChanged(_ sender: UITextField) {
            registerButton.isEnabled = !(usernameTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
        }
    
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let username = usernameTextField.text ?? ""
               let password = passwordTextField.text ?? ""
               
               // Insert user in the database
               if DatabaseHelper.shared.insertUser(username: username, password: password) {
                   print("User registered successfully")
               } else {
                   print("Failed to register user")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
