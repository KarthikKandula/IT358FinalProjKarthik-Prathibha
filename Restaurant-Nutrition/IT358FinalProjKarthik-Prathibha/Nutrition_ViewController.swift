//
//  Nutrition_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/22/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit

class Nutrition_ViewController: UIViewController, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nutritionTextField: UITextField!
    @IBOutlet weak var nutritionTableView: UITableView!
    @IBOutlet weak var displayLabel: UILabel!
    
    var pickerData: [String] = [String]()
    var pickedSearchCriteria: String?
    var pickedSearchCount: Int?
    
    var endPointInUse:String?
    
    var IDsinUse: [Int] = []
    var rowClickedOn: Int?
    
    var tableDisplayData: [String] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        nutritionTableView.dataSource = self
        nutritionTableView.delegate = self
        
        pickerData = ["Search Recipes using keyword", "Get a Random Food Joke", "Get a Random Food Trivia"] // "Search MenuItems in Restaurants", "Search Grocery Products",
        
        // Loading onClick picker for search criteria
        createPickerView()
        dismissPickerView()
        
    }
    
    // MARK: - tableView numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDisplayData.count
    }

    // MARK: - tableView cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionCell", for: indexPath)
        
        cell.textLabel?.text = tableDisplayData[indexPath.row]
        cell.detailTextLabel?.text = "Click to see more details"
        
        return cell
    }
    
    // MARK: - tableView didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowClickedOn = IDsinUse[indexPath.row]
        
        performSegue(withIdentifier: "nutritionDisplaySegue", sender: self)
    }
    
    // MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Nutrition_Detail_ViewController {
            destination.receipeID = rowClickedOn!
            destination.recipeName = tableDisplayData[nutritionTableView.indexPathForSelectedRow!.row] // "h"
        }
    }
    
    // MARK: - determineEndPoints
    func determineEndPoints() {
        if pickedSearchCriteria == "Search Recipes using keyword" {
            endPointInUse = "/recipes/search?query="
        }/* else if pickedSearchCriteria == "Search MenuItems in Restaurants" {
            endPointInUse = "/food/menuItems/search?query="
        } else if pickedSearchCriteria == "Search Grocery Products" {
            endPointInUse = "/food/products/search?query="
        } */ else if pickedSearchCriteria == "Get a Random Food Joke" {
            endPointInUse = "/food/jokes/random"
        } else if pickedSearchCriteria == "Get a Random Food Trivia" {
            endPointInUse = "/food/trivia/random"
        }
    }
    
    // MARK: - jokesAndTrivia
    func jokesAndTrivia() {
        tableDisplayData = []
        let headers = [
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
            "x-rapidapi-key": "c55ebec9f1mshc8e82a2242e7117p1c869fjsnf8e892a5661d"
        ]
        
        let urlString: String = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com" + endPointInUse!
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString )! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if (error != nil) {
                print("error")
            } else {
                print("Do it")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any] // Dictionary<String, AnyObject>
                    print(json)
                    
                    for i in json {
                        if i.key == "text" {
                            self.tableDisplayData.append( i.value as! String)
                            
                            DispatchQueue.main.async { // Correct
                                print("Dispatching")
                                self.displayLabel.text = i.value as? String
                                self.displayLabel.sizeToFit()
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
    
    // MARK: - processAPIResponseData
    func processAPIResponseData() {
        tableDisplayData = []
        let APIKeys = ["results"] // , "menuItems", "products"
        
        let headers = [
                "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
                "x-rapidapi-key": "c55ebec9f1mshc8e82a2242e7117p1c869fjsnf8e892a5661d"
            ]
        
        let urlString: String = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com" + endPointInUse! + searchBar.text!.replacingOccurrences(of: " ", with: "+") + "&number=15"
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString )! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
            
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
            if (error != nil) {
                print("error")
            } else {
                print("Do it")
                    
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any] // Dictionary<String, AnyObject>
//                    print(json)
                        
                    for i in json {
                        if i.key == APIKeys[self.pickedSearchCount!] {
                                
                            for eachRecipe in i.value as! [AnyObject] {
                                let processedEachRecipe: [String: Any] = (eachRecipe as? [String: Any])!
                                for j in processedEachRecipe {
                                    if j.key == "title" {
                                        self.tableDisplayData.append( j.value as! String)
                                            
                                        DispatchQueue.main.async { // Correct
                                            self.displayLabel.text = ""
                                            self.nutritionTableView.reloadData()
                                        }
                                    } else if j.key == "id" {
                                        self.IDsinUse.append( j.value as! Int)
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
    
    // MARK: - searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("Searching")
        
        if pickedSearchCount == 0 { // || pickedSearchCount == 1 || pickedSearchCount == 2
            processAPIResponseData()
        }
        
        self.nutritionTableView.reloadData()
    }
    
    // MARK: - searchBarCancelButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: - searchBar textDidChange
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // MARK: - pickerView numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - pickerView numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // MARK: - pickerView titleForRow
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // MARK: - pickerView didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // determining which search criteria has been picked
        pickedSearchCriteria = pickerData[row] // The String
        pickedSearchCount = row // The Int
        
        nutritionTextField.text = pickedSearchCriteria
        determineEndPoints() // determinig EndPoints
    }
    
    // MARK: - createPickerView
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        nutritionTextField.inputView = pickerView
    }
    
    // MARK: - dismissPickerView
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditing))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       nutritionTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - endEditing
    @objc func endEditing() {
        view.endEditing(true)
        if pickedSearchCount == 1 || pickedSearchCount == 2 {
            jokesAndTrivia()
        }
    }
    
    
}
