//
//  RegisterViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var nametf: UITextField!
    
    @IBOutlet weak var telephonetf: UITextField!
    @IBOutlet weak var prenomtf: UITextField!
    @IBOutlet weak var passwordtf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_register(_ sender: Any) {
        let serverUrl = "http://41.226.11.252:11888/register"
        
        guard let email = emailtf.text, !email.isEmpty else {return}
        guard let password = passwordtf.text, !password.isEmpty else {return}
        guard let name = nametf.text, !name.isEmpty else {return}
        guard let prenom = prenomtf.text, !prenom.isEmpty else {return}
        guard let telephone = telephonetf.text, !telephone.isEmpty else {return}
        
        let registerRequest = [
            "name" : name,
            "email" : email,
            "password" : password,
            "prenom" : prenom,
            "tel_user" : telephone,
        ]
        
        print(registerRequest)
        
        
        
        Alamofire.request(serverUrl, method: .post, parameters: registerRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                print(resJson)
                
                if (resJson == "Cette adresse mail est déjà utilisé")
                {
                    let myalert = UIAlertController(title: " CAMP WITH US", message: "Vous avez déjà un compte", preferredStyle: UIAlertController.Style.alert)
                    
                    myalert.addAction(UIAlertAction(title: "Connectez vous", style: .default) { (action:UIAlertAction!) in
                    })
                    self.present(myalert, animated: true)
                    //                            self.performSegue(withIdentifier: "toLogin", sender: nil)
                }
                if (resJson == "Vous ètes inscrit avec succés")
                {
                    
                    self.performSegue(withIdentifier: "toLogin", sender: nil)
                }
                
                
                
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print(error)
            }
            
            
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
