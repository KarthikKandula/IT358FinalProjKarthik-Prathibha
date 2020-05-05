//
//  Favorites_Display_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 5/5/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit
import CoreData

class Favorites_Display_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var restaurantFavoriteTableView: UITableView!
    @IBOutlet weak var recipeFavoriteTableView: UITableView!
    
    var userLoggedIn:String?
    
    var coreRestFavArray: [NSManagedObject] = []
    var coreRecipeFavArray: [NSManagedObject] = []
    
    var restFavs: [String] = []
    var recipeFavs: [String] = []
    
    var restFavIDs: [String] = []
    var recipeFavIDs: [String] = []
    
    var sampleData: [String] = ["Hey", "Hello", "HRU"]
    var sampleData1: [String] = ["Hey", "Hello", "HRU"]
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        restaurantFavoriteTableView.dataSource = self
        restaurantFavoriteTableView.delegate = self
        
        recipeFavoriteTableView.dataSource = self
        recipeFavoriteTableView.delegate = self
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        getFavorites()
        
    }

    // MARK: - getFavorites
    func getFavorites() {
        restFavs = []
        recipeFavs = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        /* Getting Restaurant Favorites */
        // Fetching Restaurant Favorites Entity data
        let fetchRequestRestFavs = NSFetchRequest<NSManagedObject>(entityName: "RestaurantFavorites")
        
        // Saving Fetched UserData in a NSManagedObject Array
        do {
            coreRestFavArray = try managedContext.fetch(fetchRequestRestFavs)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for eachFav in coreRestFavArray {
            if (eachFav as! RestaurantFavorites).userSaved == userLoggedIn {
                restFavs.append((eachFav as! RestaurantFavorites).title!)
                restFavIDs.append((eachFav as! RestaurantFavorites).restaurantID!)
            }
        }
        
        
        /* Getting Recipe Favorites */
        let fetchRequestRecipeFavs = NSFetchRequest<NSManagedObject>(entityName: "RecipeFavorites")
        
        // Saving Fetched UserData in a NSManagedObject Array
        do {
            coreRecipeFavArray = try managedContext.fetch(fetchRequestRecipeFavs)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for eachFav in coreRecipeFavArray {
            if (eachFav as! RecipeFavorites).userSaved == userLoggedIn {
                recipeFavs.append((eachFav as! RecipeFavorites).title!)
                recipeFavIDs.append((eachFav as! RecipeFavorites).recipeID!)
            }
        }
        
    }
    
    // MARK: - tableView numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?

        if tableView == self.restaurantFavoriteTableView {
            count = restFavs.count
        }
        
        if tableView == self.recipeFavoriteTableView {
            count =  recipeFavs.count
        }
        
        return count!
    }
    
    // MARK: - tableView cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.restaurantFavoriteTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "favRestaurant", for: indexPath)
            let previewDetail = sampleData[indexPath.row]
            cell!.textLabel!.text = restFavs[indexPath.row]
        }
        
        if tableView == self.recipeFavoriteTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "favRecipe", for: indexPath)
            let previewDetail = sampleData1[indexPath.row]
            cell!.textLabel!.text = recipeFavs[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.restaurantFavoriteTableView {
            performSegue(withIdentifier: "favRestDetailsSegue", sender: self)
        }
        
        if tableView == self.recipeFavoriteTableView {
            performSegue(withIdentifier: "favRecipeDetailsSegue", sender: self)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Restaurants_Detail_ViewController {
            destination.restaurantID = restFavIDs[restaurantFavoriteTableView.indexPathForSelectedRow!.row]
        }
        if let destination = segue.destination as? Nutrition_Detail_ViewController {
            let temp = recipeFavIDs[recipeFavoriteTableView.indexPathForSelectedRow!.row]
            destination.receipeID = Int(temp)
        }
    }


}
