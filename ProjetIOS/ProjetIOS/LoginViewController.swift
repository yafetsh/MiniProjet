//
//  LoginViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FacebookCore
import FacebookLogin
import CoreData

class LoginViewController: UIViewController {
    var names:NSArray = []
    var arr_user_name = [String]()
    var arr_user_id = [String]()
    var arr_user_prenom = [String]()
    var arr_user_email = [String]()
    let defaults = UserDefaults.standard
    
    var users : [NSManagedObject] = []

    
    
    
    @IBOutlet weak var passwordtf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBLoginButton(permissions: [.publicProfile])
        loginButton.center = view.center
        //        self.view.addSubview(loginButton)
        //        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
        //            let homevc = self.storyboard?.instantiateViewController(withIdentifier: "AcceuilViewController") as! AcceuilViewController
        //                 self.navigationController?.pushViewController(homevc, animated: false)
        
        //        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func btn_login(_ sender: Any) {
        
        
        
//        let serverUrl = "http://localhost:1337/login"
        let serverUrl = "http://41.226.11.252:11888/login"

        guard let email = emailtf.text, !email.isEmpty else {return}
        guard let password = passwordtf.text, !password.isEmpty else {return}
        
        
        let loginRequest = [
            "email" : email,
            "password" : password
        ]
        print(loginRequest)
        Alamofire.request(serverUrl, method: .post, parameters: loginRequest, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                print(resJson)
                if (resJson != "Vérifiez votre mot de passe") && (resJson != "Utilisateur introuvable") {
                    
                    let myresult = try? JSON(data: responseObject.data!)
                    
                    let resultArray = myresult!["user"]
                    
                    for i in resultArray.arrayValue {
                        let user_id = i["id"].stringValue
                        self.defaults.set(user_id, forKey: "user_id")
                        
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                          let coreContext = appDelegate?.persistentContainer.viewContext
                          let itemEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: coreContext!)
                          let item = NSManagedObject(entity: itemEntityDescription!, insertInto: coreContext)
                          item.setValue(Int(user_id) , forKey: "id_user")
                          
                          do {
                              try coreContext?.save()
                              
                              
                              print("saved")
                              
                          } catch let error as NSError {
                              print(error.userInfo)
                          }
                        print(user_id)
                        let user_name = i["name"].stringValue
                        self.defaults.set(user_name, forKey: "user_name")
                        
                        print(user_name)
                        
                        let user_prenom = i["prenom"].stringValue
                        self.defaults.set(user_prenom, forKey: "user_prenom")
                        
                        print(user_prenom)
                        
                        let user_mail = i["email"].stringValue
                        
                        self.defaults.set(user_mail, forKey: "user_mail")
                        let age = self.defaults.object(forKey: "user_name")
                        print(age!)
                        let user_phone = i["tel_user"].stringValue
                        self.defaults.set(user_phone, forKey: "user_phone")
                        
                        
                        
                        print(user_mail)
                        
                    }
                    
                    
                    self.performSegue(withIdentifier: "goToHome", sender: nil)
               
                }
                if (resJson == "Vérifiez votre mot de passe") {
                    let myalert = UIAlertController(title: " CAMP WITH US", message: "Vérifiez votre mot de passe", preferredStyle: UIAlertController.Style.alert)
                    
                    myalert.addAction(UIAlertAction(title: "Réessayez", style: .default) { (action:UIAlertAction!) in
                    })
                    self.present(myalert, animated: true)
                }
                if (resJson == "Utilisateur introuvable") {
                    let myalert = UIAlertController(title: " CAMP WITH US", message: "Utilisateur introuvable", preferredStyle: UIAlertController.Style.alert)
                    
                    myalert.addAction(UIAlertAction(title: "Inscrivez vous", style: .default) { (action:UIAlertAction!) in
                        print("retry")
                        self.performSegue(withIdentifier: "toRegister", sender: nil)
                        
                    })
                    self.present(myalert, animated: true)
                    
                }
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print(error)
            }
            
        }
    }
    func retrieveUser(eventId: Int) -> Bool {
         //        let eventId =  defaults.integer(forKey: "event_id")
         
         
         //As we know that container is set up in the AppDelegates so we need to refer that container.
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         
         //We need to create a context from this container
         let managedContext = appDelegate.persistentContainer.viewContext
         
         //Prepare the request of type NSFetchRequest  for the entity
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
         fetchRequest.predicate = NSPredicate(format: "id_user = %d", eventId)
         do {
             return try !managedContext.fetch(fetchRequest).isEmpty
         } catch {
             print("No User", error)
             return false
         }
     }

     func loadUser() {
         let appDelegate = UIApplication.shared.delegate as? AppDelegate
         let coreContext = appDelegate?.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
         do {
             users = try coreContext!.fetch(fetchRequest)
             print(users)
         } catch let error as NSError {
             print(error.userInfo)
         }
     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToHome"){
            
            
            // pour passer des paramétres à votre prochaine uiview controller
            
            let vc = segue.destination as! UITabBarController
//            vc.usr = emailtf.text!
            
            
            
            
            
            
        }
    }
}
