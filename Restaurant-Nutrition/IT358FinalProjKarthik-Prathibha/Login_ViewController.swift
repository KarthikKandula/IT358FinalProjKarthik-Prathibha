//
//  Login_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/22/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginSuccess: Bool?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // This is a test to see if this works?
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loginSuccess = false
    }
    
    // MARK: - loginButtonClicked
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        if usernameTextField.text == "test" && passwordTextField.text == "test1" {
            loginSuccess = true
        }
        
        if loginSuccess == true {
            print("Login")
            performSegue(withIdentifier: "loginSuccess", sender: self)
        } else {
            let alert = UIAlertController(title: "Incorrect Details", message: "Username or Password Incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
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
