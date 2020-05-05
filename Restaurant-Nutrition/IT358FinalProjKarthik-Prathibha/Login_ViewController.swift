//
//  Login_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/22/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit
import CoreData

class Login_ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var usernameText: String?
    var passwordText: String?
    
    var coreUserDataArray: [NSManagedObject] = []
    
    var loginSuccess: Bool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // This is a test to see if this works?
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        /*
        username - usertest
        password - passtest
         
         username - testuser
         password - testpass
         */
    }
    
    // MARK: - loginButtonClicked
    @IBAction func loginButtonClicked(_ sender: Any) {
        loginSuccess = false;
        verifyLoginDetails();
        
        if loginSuccess == true {
            print("Login")
            performSegue(withIdentifier: "loginSuccess", sender: self)
        } else {
            let alert = UIAlertController(title: "Incorrect Details", message: "Username or Password Incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - verifyLoginDetails
    func verifyLoginDetails() {
        usernameText = usernameTextField.text
        passwordText = passwordTextField.text
        
        var currentUserLoggedIn: String?
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequestUserData = NSFetchRequest<NSManagedObject>(entityName: "UserLoginInfo")
        
        // Saving Fetched UserData in a NSManagedObject Array
        do {
            coreUserDataArray = try managedContext.fetch(fetchRequestUserData)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for eachUser in coreUserDataArray {
            if usernameText == (eachUser as! UserLoginInfo).username && passwordText == (eachUser as! UserLoginInfo).password {
                loginSuccess = true;
                
                currentUserLoggedIn = (eachUser as! UserLoginInfo).username
            }
        }
        
        if loginSuccess == true {
            var coreCurrentData: [NSManagedObject] = []

            // FetchRequest to get current data
            let fetchRequestCurrentData = NSFetchRequest<NSManagedObject>(entityName: "CurrentSessionData")
            
            // Saving Fetched CurrentData in NSManagedObject Array
            do {
                coreCurrentData = try managedContext.fetch(fetchRequestCurrentData)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            print("Count")
            print(coreCurrentData.count)
            
            // Create a currentData array if it does not exist
            if coreCurrentData.count == 0 {
                // entity for CurrestSessionData
                let entity = NSEntityDescription.entity(forEntityName: "CurrentSessionData", in: managedContext)!
                
                // NSManagedObject for creating new object
                var coreCurrentIndiData: NSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
                
                coreCurrentIndiData.setValue(currentUserLoggedIn, forKey: "userLoggedIn")
                
                coreCurrentData.insert(coreCurrentIndiData, at: 0)
            }
            
            var justAVar = coreCurrentData[0]
            (justAVar as! CurrentSessionData).userLoggedIn = currentUserLoggedIn
            
//            do {
//                try managedContext.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
        }
        
    }
    
    // MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is Main_TabBarController {

        }
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
