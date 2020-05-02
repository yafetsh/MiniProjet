//
//  ArticleViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 27/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleViewController: UIViewController{
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var venteContainer: UIView!
    @IBOutlet weak var locationContainer: UIView!
    
   
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
   
    
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
                           locationContainer.isHidden = false
                           venteContainer.isHidden = true
                           print("location clicked")
                       }
                      else {
                                locationContainer.isHidden = true
                                  venteContainer.isHidden = false
                           print("vente clicked")

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
