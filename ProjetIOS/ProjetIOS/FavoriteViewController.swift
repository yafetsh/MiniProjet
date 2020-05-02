//
//  FavoriteViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 16/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var eventView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        
                if sender.selectedSegmentIndex == 0 {
                    eventView.isHidden = false
                    articleView.isHidden = true
                    print("event clicked")
                }
               else {
                         eventView.isHidden = true
                           articleView.isHidden = false
                    print("article clicked")

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
