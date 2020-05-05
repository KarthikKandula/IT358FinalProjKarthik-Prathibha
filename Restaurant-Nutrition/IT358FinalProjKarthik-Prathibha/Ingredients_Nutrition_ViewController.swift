//
//  Ingredients_Nutrition_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 5/4/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit

class Ingredients_Nutrition_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var goodNutritionTableView: UITableView!
    @IBOutlet weak var badNutritionTableView: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    
    var recipeID: Int?
    
    var goodNutritionData: [previewDetail] = []
    var badNutritionData: [previewDetail] = []
    var ingredientsData: [previewDetail] = []
    
    // MARK: - struct previewDetail
    struct previewDetail {
        let title: String
        let subTitle: String
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        goodNutritionTableView.dataSource = self
        goodNutritionTableView.delegate = self

        badNutritionTableView.dataSource = self
        badNutritionTableView.delegate = self

        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        // function call to get Nutrition value of recipe
        getNutrition()
        
        // function call to get Ingredients value of recipe
        getIngredients()
    }

    // MARK: - tableView numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == self.badNutritionTableView {
            count = badNutritionData.count
        } else if tableView == self.goodNutritionTableView {
            count = goodNutritionData.count
        } else if tableView == self.ingredientsTableView {
            count = ingredientsData.count
        }
        
        return count!
    }

    // MARK: - tableView cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if tableView == self.badNutritionTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "badNutritionCell", for: indexPath)
            cell?.textLabel?.text = badNutritionData[indexPath.row].title
            cell?.detailTextLabel?.text = " % of Daily Needs: " +  badNutritionData[indexPath.row].subTitle + " %"
        } else if tableView == self.goodNutritionTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "goodNutritionCell", for: indexPath)
            cell?.textLabel?.text = goodNutritionData[indexPath.row].title
            cell?.detailTextLabel?.text = " % of Daily Needs: " +  goodNutritionData[indexPath.row].subTitle + " %"
        } else if tableView == self.ingredientsTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
            cell?.textLabel?.text = ingredientsData[indexPath.row].title
            cell?.detailTextLabel?.text = " Amount: " +  ingredientsData[indexPath.row].subTitle
        }
        
        return cell!
    }
    
    // MARK: - getNutrition
    func getNutrition() {
        let headers = [
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
            "x-rapidapi-key": "c55ebec9f1mshc8e82a2242e7117p1c869fjsnf8e892a5661d"
        ]
        
        let urlString: String = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + String(recipeID!) + "/nutritionWidget.json"
            
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
                        if i.key == "bad" {
                            for eachBad in i.value as! [AnyObject] {
                                let processedBad: [String:Any] = (eachBad as? [String: Any])!
//                                print(processedBad)
                                var temp1 = ""
                                var temp2 = "" // :Int = 0
                                var temp3 = ""
                                for j in processedBad {
                                    
                                    if j.key == "title" {
                                        temp1 += j.value as! String + " - "
                                    } else if j.key == "amount" {
                                        temp3 += j.value as! String
                                    } else if j.key == "percentOfDailyNeeds" {
                                        temp2 += "\(j.value)"
                                    }
                                }
                                if temp1 != "" && temp2 != "" {
                                    let eachArray =  previewDetail(title: temp1 + temp3, subTitle: String(temp2))
                                    self.badNutritionData.append(eachArray)
                                }
                                DispatchQueue.main.async { // Correct
                                    self.badNutritionTableView.reloadData()
                                }
                            }
                        } else if i.key == "good" {
                            for eachBad in i.value as! [AnyObject] {
                                let processedBad: [String:Any] = (eachBad as? [String: Any])!
                            //  print(processedBad)
                                var temp1 = ""
                                var temp2 = "" // :Int = 0
                                var temp3 = ""
                                for j in processedBad {
                                                                
                                    if j.key == "title" {
                                        print("1")
                                        temp1 += j.value as! String + " - "
                                    } else if j.key == "amount" {
                                        print("2")
                                        temp3 += j.value as! String
                                    } else if j.key == "percentOfDailyNeeds" {
                                        print("3")
                                        temp2 += "\(j.value)"
                                    }
                                }
                                if temp1 != "" && temp2 != "" {
                                    let eachArray =  previewDetail(title: temp1 + temp3, subTitle: String(temp2))
                                    self.goodNutritionData.append(eachArray)
                                }
                                DispatchQueue.main.async { // Correct
                                    self.goodNutritionTableView.reloadData()
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
        badNutritionTableView.reloadData()
        goodNutritionTableView.reloadData()
    }

    // MARK: - getIngredients
    func getIngredients() {
       let headers = [
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
            "x-rapidapi-key": "c55ebec9f1mshc8e82a2242e7117p1c869fjsnf8e892a5661d"
        ]
        
        let urlString: String = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + String(recipeID!) + "/ingredientWidget.json"
            
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
                        if i.key == "ingredients" {
                            for eachIng in i.value as! [AnyObject] {
                                let processedIng: [String:Any] = (eachIng as? [String: Any])!
                                print(processedIng)
                                var temp1 = ""
                                var metricTemp1 = ""
                                var metricTemp2 = ""
                                var usTemp1 = ""
                                var usTemp2 = ""
                                for j in processedIng {
                                    if j.key == "name" {
                                        temp1 += j.value as! String
                                    } else if j.key == "amount" {
                                        for eachAmount in j.value as! [String:Any] {
                                            if eachAmount.key == "metric" {
                                                for eachMetric in eachAmount.value as! [String:Any] {
                                                    if eachMetric.key == "unit" {
                                                        metricTemp1 += "\(eachMetric.value)"
                                                    } else if eachMetric.key == "value" {
                                                        metricTemp2 += "\(eachMetric.value)"
                                                    }
                                                }
                                            } else if eachAmount.key == "us" {
                                                for eachMetric in eachAmount.value as! [String:Any] {
                                                    if eachMetric.key == "unit" {
                                                        usTemp1 += "\(eachMetric.value)"
                                                    } else if eachMetric.key == "value" {
                                                        usTemp2 += "\(eachMetric.value)"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if temp1 != "" && metricTemp1 != "" && metricTemp2 != "" && usTemp1 != "" && usTemp2 != "" {
                                    let subTitleString = metricTemp2 + " " + metricTemp1 + " or " + usTemp2 + " " + usTemp1
                                    let eachArray =  previewDetail(title: temp1, subTitle: subTitleString )
                                    self.ingredientsData.append(eachArray)
                                }
                                print(self.ingredientsData)
                                DispatchQueue.main.async { // Correct
                                    self.ingredientsTableView.reloadData()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
