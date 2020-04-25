//
//  Login_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/22/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit

class Login_ViewController: UIViewController {

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - loginButtonClicked
    @IBAction func loginButtonClicked(_ sender: Any) {
        var loginSuccess = false
        
        if loginSuccess == true {
            print("Login")
            performSegue(withIdentifier: "loginSuccess", sender: self)
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
