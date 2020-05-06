//
//  Account_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/22/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit
import CoreData

class Account_ViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var viewFavsButton: UIButton!
    @IBOutlet weak var editInfoButton: UIButton!
    
    @IBOutlet weak var testAccountLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var userLoggedIn: String = ""
    
    var coreUserDataArray: [NSManagedObject] = []
    
    var firstNameText: String?
    var lastNameText: String?
    var usernameText: String?
    var passwordText: String?
    var confirmPasswordText: String?
    
    var userExists: Bool = false;
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        determineUserLoggedIn(operation: "determine")
        
        if userLoggedIn != "" {
            knowUserDetails()
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        determineUserLoggedIn(operation: "logout")
    }
    
    // MARK: - knowUserDetails
    func knowUserDetails() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // FetchRequest to get existing UserData
        let fetchRequestUserData = NSFetchRequest<NSManagedObject>(entityName: "UserLoginInfo")
        
        // Saving Fetched UserData in a NSManagedObject Array
        do {
            coreUserDataArray = try managedContext.fetch(fetchRequestUserData)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(coreUserDataArray)
        
        // Checking if the user exists
        for eachUser in coreUserDataArray {
            if userLoggedIn == (eachUser as! UserLoginInfo).username {
                userExists = true;
                firstNameTextField.text = (eachUser as! UserLoginInfo).firstName
                lastNameTextField.text = (eachUser as! UserLoginInfo).lastName
                userNameTextField.text = (eachUser as! UserLoginInfo).username
            }
        }
    }
    
    // MARK: - editInfoClicked
    @IBAction func editInfoClicked(_ sender: Any) {
        firstNameText = firstNameTextField.text
        lastNameText = lastNameTextField.text
        usernameText = userNameTextField.text
        passwordText = passwordTextField.text
        confirmPasswordText = confirmPasswordTextField.text
        
        if firstNameText != "" && lastNameText != "" && passwordText != "" && passwordText == confirmPasswordText {
            editUserInfo()
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter all Details (or) Password and Confirm password does not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - editUserInfo
    func editUserInfo() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // FetchRequest to get existing UserData
        let fetchRequestUserData = NSFetchRequest<NSManagedObject>(entityName: "UserLoginInfo")
        
        // Saving Fetched UserData in a NSManagedObject Array
        do {
            coreUserDataArray = try managedContext.fetch(fetchRequestUserData)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // Checking if the user exists
        for eachUser in coreUserDataArray {
            if userLoggedIn == (eachUser as! UserLoginInfo).username {
                userExists = true;
                (eachUser as! UserLoginInfo).firstName = firstNameTextField.text
                (eachUser as! UserLoginInfo).lastName = lastNameTextField.text
                (eachUser as! UserLoginInfo).username = userNameTextField.text
                (eachUser as! UserLoginInfo).password = passwordText
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        let alert = UIAlertController(title: "Success!", message: "Account Details successfully updated!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - viewFavsClicked
    @IBAction func viewFavsClicked(_ sender: Any) {
        performSegue(withIdentifier: "viewFavsSegue", sender: self)
    }
    
    // MARK: - determineUserLoggedIn
    func determineUserLoggedIn(operation: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var coreCurrentData: [NSManagedObject] = []

        // FetchRequest to get current data
        let fetchRequestCurrentData = NSFetchRequest<NSManagedObject>(entityName: "CurrentSessionData")
                   
        // Saving Fetched CurrentData in NSManagedObject Array
        do {
            coreCurrentData = try managedContext.fetch(fetchRequestCurrentData)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if coreCurrentData.count == 0 {
            testAccountLabel.text = "User not logged in"
        } else {
            let justAVar = coreCurrentData[0]
            
            if operation == "determine" {
                
                if (justAVar as! CurrentSessionData).userLoggedIn == "" {
                    testAccountLabel.text = "User not logged in"
                } else {
                    userLoggedIn = (justAVar as! CurrentSessionData).userLoggedIn!
                    testAccountLabel.text = "Welcome, " + (justAVar as! CurrentSessionData).userLoggedIn!
                }
            } else if operation == "logout" {
                (justAVar as! CurrentSessionData).userLoggedIn = ""
                testAccountLabel.text = "User logged out!"
                firstNameTextField.text = ""
                lastNameTextField.text = ""
                userNameTextField.text = ""
                
                let alert = UIAlertController(title: "User logged out", message: "Go to Login page to login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Favorites_Display_ViewController {
            destination.userLoggedIn = userLoggedIn
        }
    }
}
