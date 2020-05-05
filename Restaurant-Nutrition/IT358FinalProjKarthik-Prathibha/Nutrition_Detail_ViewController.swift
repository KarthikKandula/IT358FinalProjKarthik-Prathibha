//
//  Nutrition_Detail_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/29/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit
import CoreData

class Nutrition_Detail_ViewController: UIViewController {

    @IBOutlet weak var nutritionDetailInstructionsLabel: UILabel!
    @IBOutlet weak var recipeFavSwitch: UISwitch!
    
    var receipeID: Int?
    
    var coreRecipeFavArray: [NSManagedObject] = []
    var userLoggedIn: String?
    
    var tableDisplayData: [String] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        print(receipeID!)
        knowIfFavorite()
        
        knowAPIData()
    }
    
    // MARK: - switchClicked
    @IBAction func switchClicked(_ sender: Any) {
        if recipeFavSwitch.isOn {
            print("isOn triggered")
            recipeFavSwitch.setOn(true, animated: true)
            modifyRecipeFavorite(modifyType: "add")
        } else {
            print("else triggered")
            recipeFavSwitch.setOn(false, animated: true)
            modifyRecipeFavorite(modifyType: "remove")
        }
    }
    
    func modifyRecipeFavorite(modifyType: String) {
        var coreCurrentData: [NSManagedObject] = [] // To know which user logged in
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if modifyType == "add" {
            let entity = NSEntityDescription.entity(forEntityName: "RecipeFavorites", in: managedContext)!
            
            // NSManagedObject for creating new object
            let coreNewRecipeFav: NSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
            
            coreNewRecipeFav.setValue(userLoggedIn, forKey: "userSaved")
            coreNewRecipeFav.setValue("\(String(describing: receipeID!))", forKey: "recipeID")
            
            coreRecipeFavArray.insert(coreNewRecipeFav, at: 0)
            
            print(coreRecipeFavArray)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else if modifyType == "remove" {
            var indexToRemove:Int?
            var i = 0
            
            for eachFav in coreRecipeFavArray {
                if (eachFav as! RecipeFavorites).recipeID == "\(String(describing: receipeID!))" && (eachFav as! RecipeFavorites).userSaved == userLoggedIn {
                    print("Condition Satisfied")
                    print(i)
                    indexToRemove = i
                }
                i += 1
            }
            let deleteObject: NSManagedObject = coreRecipeFavArray[indexToRemove!]
            coreRecipeFavArray.remove(at: indexToRemove!)
            
            print(coreRecipeFavArray)
            
            managedContext.delete(deleteObject)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - knowIfFavorite
    func knowIfFavorite() {
        var coreCurrentData: [NSManagedObject] = [] // To know which user logged in
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // FetchRequest to get which user loggedIN
        let fetchRequestCurrentData = NSFetchRequest<NSManagedObject>(entityName: "CurrentSessionData")
                   
        // Saving Fetched CurrentData in NSManagedObject Array
        do {
            coreCurrentData = try managedContext.fetch(fetchRequestCurrentData)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
                   
        let justAVar = coreCurrentData[0]
        userLoggedIn = (justAVar as! CurrentSessionData).userLoggedIn
        print(userLoggedIn!)
        // Fetching Restaurant Favorites Entity data
        let fetchRequestRestFavs = NSFetchRequest<NSManagedObject>(entityName: "RecipeFavorites")
        
        // Saving Fetched UserData in a NSManagedObject Array
        do {
            coreRecipeFavArray = try managedContext.fetch(fetchRequestRestFavs)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for eachFav in coreRecipeFavArray {
            if (eachFav as! RecipeFavorites).recipeID == "\(String(describing: receipeID!))" && (eachFav as! RecipeFavorites).userSaved == userLoggedIn {
                recipeFavSwitch.setOn(true, animated: true)
            }
        }
    }
    
    // MARK: - ingredientsClicked
    @IBAction func ingredientsClicked(_ sender: Any) {
        performSegue(withIdentifier: "RecipeMoreDetailsSegue", sender: self)
    }
    
    // MARK: - knowAPIData
    func knowAPIData() {
        tableDisplayData = []
        let APIKeys = ["results", "menuItems", "products"]
            
        let headers = ["x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
            "x-rapidapi-key": "c55ebec9f1mshc8e82a2242e7117p1c869fjsnf8e892a5661d"
            ]
            
        let urlString: String = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + String(receipeID!) + "/information"
            
        var request = URLRequest(url: URL(string: urlString )! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    
            if (error != nil) {
                print("error")
            } else {
                print("Do it")
                        
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any] // Dictionary<String, AnyObject>
                    print(json)
                            
                   for i in json {
                        if i.key == "instructions" {
                            
                            DispatchQueue.main.async { // Correct
                            self.nutritionDetailInstructionsLabel.text = i.value as? String
                        self.nutritionDetailInstructionsLabel.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
                        self.nutritionDetailInstructionsLabel.numberOfLines = 0
                        self.nutritionDetailInstructionsLabel.sizeToFit()
                            }
                        }
                    }
                } catch {
                        print("error")
                }
            }
        })
        dataTask.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Ingredients_Nutrition_ViewController {
            destination.recipeID = receipeID!
        }
    }
    

}
