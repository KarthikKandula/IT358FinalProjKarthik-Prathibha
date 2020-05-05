//
//  Restaurants_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/22/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import Foundation
import UIKit

class Restaurants_ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var restaurantsCitySearch: UITextField!
    @IBOutlet weak var restaurantsTableView: UITableView!
    
    var IDsinUse: [String] = []
    var rowClickedOn: String?
    
    var tableDisplayData: [String] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        navigationItem.titleView = searchBar
        navigationItem.title = "Restaurant Search"
        searchBar.delegate = self
        restaurantsTableView.dataSource = self
        restaurantsTableView.delegate = self
        
        print("Restaurant View loading")
    }
    
    // MARK: - tableView numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDisplayData.count
    }
    
    // MARK: - tableView cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantDetailCell", for: indexPath)
        
        cell.textLabel?.text = tableDisplayData[indexPath.row]
        cell.detailTextLabel?.text = "Click to see more details"
        
        return cell
    }
    
    // MARK: - tableView didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowClickedOn = IDsinUse[indexPath.row]
        performSegue(withIdentifier: "restaurantDisplaySegue", sender: self)
    }
    
    // MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Restaurants_Detail_ViewController {
            destination.restaurantID = rowClickedOn!
        }
    }
    
    // MARK: - searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        processAPIResponseData()
    }
    
    // MARK: - searchBarCancelButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: - searchBar textDidChange
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // MARK: - processAPIResponseData
    func processAPIResponseData() {
        tableDisplayData = []
        let headers = [
                "Authorization": "Bearer Rh8RFDCpZaxFBvs32bGz85Ia_3ovzNnzEXUpoNnyK7BI5EirpdIgLT-u28R06UGblMo_HeD4EnOnfX8cAJYQkztTGEHqGpeMImWhH8myf9NXIgqu-KZ6VCnhV0enXnYx"
            ]
        
//        let urlString: String = "https://api.yelp.com/v3/businesses/search?term=restaurants&location=chicago"

        
        let urlString: String = "https://api.yelp.com/v3/businesses/search?term=" + searchBar.text!.replacingOccurrences(of: " ", with: "+") + "&location=" + restaurantsCitySearch.text!.replacingOccurrences(of: " ", with: "+")
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString )! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any] // Dictionary<String, AnyObject>
                print(json)
                
                for i in json {
                    if i.key == "businesses" {
                        
                        for eachBusiness in i.value as! [AnyObject] {
                            let processedBusiness: [String: Any] = (eachBusiness as? [String: Any])!
                            
                            for j in processedBusiness {
                                if j.key == "name" {
                                    self.tableDisplayData.append( j.value as! String)
                                    
                                    DispatchQueue.main.async { // Correct
                                    self.restaurantsTableView.reloadData()
                                    }
                                } else if j.key == "id" {
                                    self.IDsinUse.append( j.value as! String)
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
            
        }).resume()
    }
}
