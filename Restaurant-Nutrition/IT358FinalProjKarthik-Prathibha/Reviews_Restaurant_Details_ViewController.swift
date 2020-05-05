//
//  Reviews_Restaurant_Details_ViewController.swift
//  IT358FinalProjKarthik-Prathibha
//
//  Created by Karthik Kandula on 5/4/20.
//  Copyright © 2020 Karthik Kandula. All rights reserved.
//

import UIKit

class Reviews_Restaurant_Details_ViewController: UIViewController {

    @IBOutlet weak var reviewLabel: UILabel!
    
    var reviews: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reviewLabel.text = ""
        var j = 1
        for i in reviews {
            self.reviewLabel.text! += "Review \(j): \n" + i + "\n \n"
            j+=1
        }
        
        self.reviewLabel.lineBreakMode = .byWordWrapping
        self.reviewLabel.numberOfLines = 0
        self.reviewLabel.sizeToFit()
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
