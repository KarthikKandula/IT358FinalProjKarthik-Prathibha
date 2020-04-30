//
//  Restaurants_Detail_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/29/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit

class Restaurants_Detail_ViewController: UIViewController {
    
    @IBOutlet weak var restaurantsImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var restaurantID: String?
    
    var tableDisplayData: [String] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        print(restaurantID)
        knowAPIData()
    }

    // MARK: - knowAPIData
    func knowAPIData() {
        tableDisplayData = []
            
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
                    print(json)
                            
                   for i in json {
                        if i.key == "name" {
                            DispatchQueue.main.async { // Correct
                            self.nameLabel.text = i.value as? String
//                        self.nameLabel.lineBreakMode = .byWordWrapping
//                        self.nameLabel.numberOfLines = 0
                        self.nameLabel.sizeToFit()
                            }
                        } else if i.key == "location" {
                            print(i.value)
                            let temp: [String: Any] = (i.value as? [String: Any])!
                            for j in temp {
                                if j.key == "display_address" {
                                    var abc:[String] = j.value as! [String]
                                    DispatchQueue.main.async { // Correct
          self.addressLabel.text = abc[0] + " " + abc[1]
                                     self.addressLabel.sizeToFit()
                                    }
                                }
                            }
                        } else if i.key == "display_phone" {
                            DispatchQueue.main.async { // Correct
                                self.phoneLabel.text = "+1 " + String ((i.value as? String)!)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
