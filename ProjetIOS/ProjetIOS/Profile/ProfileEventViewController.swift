//
//  ProfileEventViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 30/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileEventViewController: UIViewController {

    
    @IBOutlet weak var abonner_btn: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var articleView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var infoView: UIView!
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
                profileImage?.clipsToBounds = true
                profileImage?.layer.borderWidth = 3.0
                profileImage?.layer.borderColor = UIColor.white.cgColor
        let followingId =  defaults.integer(forKey: "profil_id")
               let followerId =  defaults.integer(forKey: "user_id")
               let serverUrl = "http://41.226.11.252:11888/follow/verify"
        let addFollowerRequest = [
                   "id_follower" : followerId,
                   "id_following" : followingId
                   
               ]
             Alamofire.request(serverUrl, method: .post, parameters: addFollowerRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                                   if responseObject.result.isSuccess {
                                       let resJson1 = JSON(responseObject.result.value!)
                                       print(resJson1)
                                       if (resJson1 == "abonné déjà")
                                       {
                                           self.abonner_btn.setTitle(" Se désabonner", for: .normal)
                                           if #available(iOS 13.0, *) {
                                               self.abonner_btn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
                                               self.abonner_btn.tintColor = .white
                                           }
                                       
                                           
                                       }
                                    
                                   }
                if responseObject.result.isFailure {
                                           let error : Error = responseObject.result.error!
                                           print(error)
                                       }
                                   }
        super.viewDidLoad()
                let profilName =  defaults.object(forKey: "profil")

        namelbl.text = profilName as? String


        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
                           eventView.isHidden = true
                           articleView.isHidden = true
            infoView.isHidden = false

                           print("info clicked")
                       }
                      else if sender.selectedSegmentIndex == 1 {
                                eventView.isHidden = false
                                  articleView.isHidden = true
            infoView.isHidden = true

                           print("event clicked")

                              }
        else {
            eventView.isHidden = true
                                  articleView.isHidden = false
            infoView.isHidden = true

                           print("article clicked")
        }
    }
    @IBAction func abonner_btn(_ sender: Any) {
        let followingId =  defaults.integer(forKey: "profil_id")
        let followerId =  defaults.integer(forKey: "user_id")
        let serverUrl = "http://41.226.11.252:11888/follow/add"
        let serverUrl2 = "http://41.226.11.252:11888/follow/delete"

        let addFollowerRequest = [
            "id_follower" : followerId,
            "id_following" : followingId
            
        ]
        print(addFollowerRequest)

        if (abonner_btn.currentTitle == " S'abonner")
           {
                       Alamofire.request(serverUrl, method: .post, parameters: addFollowerRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                           if responseObject.result.isSuccess {
                               let resJson1 = JSON(responseObject.result.value!)
                               print(resJson1)
                               if (resJson1 == "abonné avec succés")
                               {
                                   self.abonner_btn.setTitle(" Se désabonner", for: .normal)
//                                self.abonner_btn.backgroundColor = .white
                                   if #available(iOS 13.0, *) {
                                       self.abonner_btn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
                                       self.abonner_btn.tintColor = .white
                                   }
                                   
                               }
                            
                           }
                           if responseObject.result.isFailure {
                               let error : Error = responseObject.result.error!
                               print(error)
                           }
                       }
                   }
        else if (abonner_btn.currentTitle == " Se désabonner"){
              Alamofire.request(serverUrl2, method: .delete, parameters: addFollowerRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                                       if responseObject.result.isSuccess {
                                           let resJson1 = JSON(responseObject.result.value!)
                                           print(resJson1)
                                           if (resJson1 == "désabonné avec succés")
                                           {
                                               self.abonner_btn.setTitle(" S'abonner", for: .normal)
            //                                self.abonner_btn.backgroundColor = .white
                                               if #available(iOS 13.0, *) {
                                                   self.abonner_btn.setImage(UIImage(systemName: "heart.circle"), for: .normal)
                                                   self.abonner_btn.tintColor = .white
                                               }
                                               
                                           }
                                       }
                                       if responseObject.result.isFailure {
                                           let error : Error = responseObject.result.error!
                                           print(error)
                                       }
                                   }
            
        }
        
//                   if responseObject.result.isFailure {
//                       let error : Error = responseObject.result.error!
//                       print(error)
//                   }
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
