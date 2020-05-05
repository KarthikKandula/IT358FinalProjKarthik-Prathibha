//
//  Register_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/22/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit
import CoreData

class Register_ViewController: UIViewController {

    // Outlets for all TextFields
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var coreUserDataArray: [NSManagedObject] = []
    
    var firstNameText: String?
    var lastNameText: String?
    var usernameText: String?
    var passwordText: String?
    var confirmPasswordText: String?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Registration View Controller Loading")
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
    // MARK: - registerClicked
    @IBAction func registerClicked(_ sender: Any) {
        firstNameText = firstNameTextField.text
        lastNameText = lastNameTextField.text
        usernameText = usernameTextField.text
        passwordText = passwordTextField.text
        confirmPasswordText = confirmPasswordTextField.text
        
        if passwordText == confirmPasswordText {
            createCoreDataObject()
        } else {
            let alert = UIAlertController(title: "Error", message: "Password and Confirm password does not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
        
        print(firstNameText!)
        
        let alert = UIAlertController(title: "User Registered", message: "Go to Login to access more features", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - createCoreDataObject
    func createCoreDataObject() { //} -> String {
        
        var userExists: Bool = false;
        
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
        
        // Checking if the user already exists
        for eachUser in coreUserDataArray {
            if usernameText == (eachUser as! UserLoginInfo).username {
                userExists = true;
                
                let alert = UIAlertController(title: "Error", message: "Username already exists", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Saving UserData if the user does not exist
        if userExists == false {
            // EntityDescription for UserLoginInfo to create a new array element
            let entity = NSEntityDescription.entity(forEntityName: "UserLoginInfo", in: managedContext)!

            var coreUserData: NSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)

            coreUserData.setValue(firstNameText, forKey: "firstName")
            coreUserData.setValue(lastNameText, forKey: "lastName")
            coreUserData.setValue(passwordText, forKey: "password")
            coreUserData.setValue(usernameText, forKey: "username")
            
            coreUserDataArray.insert(coreUserData, at: 0)
       
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        print(coreUserDataArray)
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
