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
    
    @IBOutlet weak var viewFavsButton: UIButton!
    @IBOutlet weak var testAccountLabel: UILabel!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        determineUserLoggedIn()
    }
    
    // MARK: - viewFavsClicked
    @IBAction func viewFavsClicked(_ sender: Any) {
        
    }
    
    // MARK: - determineUserLoggedIn
    func determineUserLoggedIn() {
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
                   
        var justAVar = coreCurrentData[0]
        if (justAVar as! CurrentSessionData).userLoggedIn == "" {
            testAccountLabel.text = "User not logged in"
        } else {
            testAccountLabel.text = "Welcome, " + (justAVar as! CurrentSessionData).userLoggedIn!
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
