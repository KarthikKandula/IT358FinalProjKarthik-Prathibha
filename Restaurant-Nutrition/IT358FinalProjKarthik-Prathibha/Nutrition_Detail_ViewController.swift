//
//  Nutrition_Detail_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 4/29/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit

class Nutrition_Detail_ViewController: UIViewController {

    @IBOutlet weak var nutritionDetailInstructionsLabel: UILabel!
    
    var receipeID: Int?
    
    var tableDisplayData: [String] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        print(receipeID!)
        
        knowAPIData()
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
