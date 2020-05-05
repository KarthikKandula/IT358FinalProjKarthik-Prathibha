//
//  Restaurants_Detail_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/29/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit
import CoreData

class Restaurants_Detail_ViewController: UIViewController {
    
    @IBOutlet weak var restaurantsImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    
    @IBOutlet weak var restaurantFavoriteSwitch: UISwitch!
    
    var restaurantID: String?
    var calledFrom: String?
    var restaurantName: String?
    
    
    var coreRestFavArray: [NSManagedObject] = []
    var userLoggedIn: String?
    
    var restReviews: [String] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        // function call to know if this restaurant is a favorite
        knowIfFavorite()
        
        // function call to know the restaurant data
        knowAPIData()
        
        // function call to know reviews
        getReviews()
    }
    
    // MARK: - viewRestClicked
    @IBAction func viewRestClicked(_ sender: Any) {
        performSegue(withIdentifier: "reviewDisplay", sender: self)
    }
    
    
    // MARK: - switchClicked
    @IBAction func switchClicked(_ sender: Any) {
        if restaurantFavoriteSwitch.isOn {
            print("isOn triggered")
            restaurantFavoriteSwitch.setOn(true, animated: true)
            modifyRestaurantFavorite(modifyType: "add")
        } else {
            print("else triggered")
            restaurantFavoriteSwitch.setOn(false, animated: true)
            modifyRestaurantFavorite(modifyType: "remove")
        }
    }
    
    // MARK: - modifyRestaurantFavorite
    func modifyRestaurantFavorite(modifyType: String) {
        var coreCurrentData: [NSManagedObject] = [] // To know which user logged in
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // MARK: - addRestaurantFavorite
        if modifyType == "add" {
            let entity = NSEntityDescription.entity(forEntityName: "RestaurantFavorites", in: managedContext)!
            
            // NSManagedObject for creating new object
            let coreNewRestFav: NSManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
            
            coreNewRestFav.setValue(userLoggedIn, forKey: "userSaved")
            coreNewRestFav.setValue(restaurantID, forKey: "restaurantID")
            coreNewRestFav.setValue(restaurantName, forKey: "title")
            
            coreRestFavArray.insert(coreNewRestFav, at: 0)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        // MARK: - removeRestaurantFavorite
        } else if modifyType == "remove" {
            var indexToRemove:Int?
            var i = 0
            
            for eachFav in coreRestFavArray {
                if (eachFav as! RestaurantFavorites).restaurantID == restaurantID && (eachFav as! RestaurantFavorites).userSaved == userLoggedIn {
                    print("Condition Satisfied")
                    print(i)
                    indexToRemove = i
                }
                i += 1
            }
            var deleteObject: NSManagedObject = coreRestFavArray[indexToRemove!]
            coreRestFavArray.remove(at: indexToRemove!)

            managedContext.delete(deleteObject)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - getReviews
    func getReviews() {
        let headers = [
            "Authorization": "Bearer Rh8RFDCpZaxFBvs32bGz85Ia_3ovzNnzEXUpoNnyK7BI5EirpdIgLT-u28R06UGblMo_HeD4EnOnfX8cAJYQkztTGEHqGpeMImWhH8myf9NXIgqu-KZ6VCnhV0enXnYx" ]
            
        let urlString: String = "https://api.yelp.com/v3/businesses/" + restaurantID! + "/reviews"
            
        var request = URLRequest(url: URL(string: urlString )! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if (error != nil) {
                print("error")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                    print(json)
                    
                    for i in json {
                        if i.key == "reviews" {
                            for eachReview in i.value as! [AnyObject] {
                                let processedReview: [String: Any] = (eachReview as? [String: Any])!
                                for j in processedReview {
                                    if j.key == "text" {
                                        DispatchQueue.main.async { // Correct
                                            self.restReviews.append((j.value as? String)!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    print("Error")
                }
            }
        })
        dataTask.resume()
    }
    
    // MARK: - knowAPIData
    func knowAPIData() {
        let headers = [
            "Authorization": "Bearer Rh8RFDCpZaxFBvs32bGz85Ia_3ovzNnzEXUpoNnyK7BI5EirpdIgLT-u28R06UGblMo_HeD4EnOnfX8cAJYQkztTGEHqGpeMImWhH8myf9NXIgqu-KZ6VCnhV0enXnYx" ]
            
        let urlString: String = "https://api.yelp.com/v3/businesses/" + restaurantID!
            
        var request = URLRequest(url: URL(string: urlString )! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    
            if (error != nil) {
                print("error")
            } else {
                print("Do it")
                        
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
//                    print(json)
                            
                   for i in json {
                        if i.key == "name" {
                            self.restaurantName = i.value as? String
                            DispatchQueue.main.async { // Correct
                                self.nameLabel.text = "Business Name: " + ((i.value as? String)!)
//                        self.nameLabel.lineBreakMode = .byWordWrapping
//                        self.nameLabel.numberOfLines = 0
                        self.nameLabel.sizeToFit()
                            }
                        } else if i.key == "location" {
//                            print(i.value)
                            let temp: [String: Any] = (i.value as? [String: Any])!
                            for j in temp {
                                if j.key == "display_address" {
                                    var abc:[String] = j.value as! [String]
                                    DispatchQueue.main.async { // Correct
                                        self.addressLabel.text = "Address: " + abc[0] + " " + abc[1]
                                        self.addressLabel.lineBreakMode = .byWordWrapping
                                        self.addressLabel.numberOfLines = 0
                                        self.addressLabel.sizeToFit()
                                    }
                                }
                            }
                        } else if i.key == "display_phone" {
                            DispatchQueue.main.async { // Correct
                                self.phoneLabel.text = "Phone Number: +1 " + String ((i.value as? String)!)
                                self.phoneLabel.sizeToFit()
                            }
                        } else if i.key == "rating" {
                            DispatchQueue.main.async { // Correct
                                self.ratingLabel.text = "Rating: 4.5" // (i.value as? String)
                                self.ratingLabel.sizeToFit()
                            }
                        } else if i.key == "price" {
                            DispatchQueue.main.async { // Correct
                                self.priceLabel.text = "Price Range: " + ((i.value as? String)!)
                                self.priceLabel.sizeToFit()
                            }
                        } else if i.key == "image_url" {
                            DispatchQueue.main.async { // Correct
                                let url = URL(string: ((i.value as? String)!))
                                let data = try? Data(contentsOf: url!)
                                self.restaurantsImageView.image = UIImage(data: data!)
                            }
                        } else if i.key == "transactions" {
                            let abc:[String] = i.value as! [String]
                            DispatchQueue.main.async { // Correct
                                for i in abc {
                                    self.servicesLabel.text! +=  i + " "
                                }
                                self.servicesLabel.sizeToFit()
                            }
                        } else if i.key == "categories" {
                            for j in (i.value as? [Any])! {
                                let temp: [String: Any] = (j as? [String: Any])!
                                print(temp)
                                for k in temp {
                                    if k.key == "title" {
                                        DispatchQueue.main.async { // Correct
                                        self.categoriesLabel.text! += ((k.value as? String)!) + ", "
                                        self.categoriesLabel.sizeToFit()
                                        }
                                    }
                                }
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
                   
        var justAVar = coreCurrentData[0]
        userLoggedIn = (justAVar as! CurrentSessionData).userLoggedIn
        print(userLoggedIn)
        // Fetching Restaurant Favorites Entity data
        let fetchRequestRestFavs = NSFetchRequest<NSManagedObject>(entityName: "RestaurantFavorites")
        
        // Saving Fetched UserData in a NSManagedObject Array
        do {
            coreRestFavArray = try managedContext.fetch(fetchRequestRestFavs)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for eachFav in coreRestFavArray {
            if (eachFav as! RestaurantFavorites).restaurantID == restaurantID && (eachFav as! RestaurantFavorites).userSaved == userLoggedIn {
                restaurantFavoriteSwitch.setOn(true, animated: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Reviews_Restaurant_Details_ViewController {
            destination.reviews = restReviews
        }
    }
    

}
