//
//  ProfileInfoViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 30/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileInfoViewController: UIViewController {

    @IBOutlet weak var emailbl: UILabel!
    @IBOutlet weak var telephonelbl: UILabel!
    let defaults = UserDefaults.standard

       var arr_user_id = [String]()
       var arr_user_mail = [String]()
       var arr_user_phone = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let id =  defaults.integer(forKey: "profil_id")

                      print(id)
                      let url = "http://41.226.11.252:11888/profil/info/\(id)"
                
                        Alamofire.request(url, method: .get).responseJSON { (myresponse) in
                       switch myresponse.result{
                       case .success:
                           print(myresponse.result)
                           let myresult = try? JSON(data: myresponse.data!)
                           print(myresult!["users"])
                           
                           let resultArray = myresult!["users"]
                           
                           self.arr_user_id.removeAll()
                           self.arr_user_mail.removeAll()
                           self.arr_user_phone.removeAll()
                       
                           for i in resultArray.arrayValue {
                               //                    print(i)
                               let profil_id = i["id"].stringValue
                               self.arr_user_id.append(profil_id)
                               let profil_mail = i["email"].stringValue
                               self.arr_user_mail.append(profil_mail)
                               let profil_phone = i["tel_user"].stringValue
                               self.arr_user_phone.append(profil_phone)
                               self.emailbl.text = "Adresse mail:  \(i["email"].stringValue)"
                            self.telephonelbl.text = "Numéro téléphone:  \(i["tel_user"].stringValue)"


                               
                           }
                           break
                           
                       case .failure:
                           print(myresponse.error!)
                           break
                       }
                   }

        // Do any additional setup after loading the view.
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
