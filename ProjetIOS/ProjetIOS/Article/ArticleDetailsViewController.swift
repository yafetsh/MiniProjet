//
//  ArticleDetailsViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 11/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class ArticleDetailsViewController: UIViewController {
    @IBOutlet weak var favoris_btn: UIButton!

    @IBOutlet weak var souslbl: UILabel!
    @IBOutlet weak var descriptionlbl: UITextView!
    @IBOutlet weak var prixlbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var categorielbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var titrelbl: UILabel!
     let defaults = UserDefaults.standard
    var idArticle:Int?
    var nomArticle:String?
    var lists : [NSManagedObject] = []

    var arr_article_id = [String]()
     var arr_user_id = [String]()
     var arr_user_name = [String]()
     var arr_user_prenom = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage?.clipsToBounds = true
        profileImage?.layer.borderWidth = 3.0
        profileImage?.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
        let articletId =  defaults.integer(forKey: "article_id")
        let myapiurl = "http://41.226.11.252:11888/article/show/\(articletId)"
          
          Alamofire.request(myapiurl).responseJSON { (myresponse) in
              switch myresponse.result{
              case .success:
                  print("response: \(myresponse.result)")
                  let myresult = try? JSON(data: myresponse.data!)
                  print(myresult!["article"])
                  
                  let resultArray = myresult!["article"]
                  
                  for i in resultArray.arrayValue {
                      self.prixlbl.text = "\(i["prix_article"].stringValue) DT"

                      self.locationlbl.text = i["location_article"].stringValue
                      self.categorielbl.text = "\(i["categorie_article"].stringValue) --> \(i["sous_categorie_article"].stringValue)"
                      self.titrelbl.text = "\(i["titre_article"].stringValue)"
                   self.descriptionlbl.text = i["description_article"].stringValue

                      self.souslbl.text = (i["sous_categorie_article"].stringValue)
                      
                  }
                  self.defaults.set(Int(self.prixlbl.text!), forKey: "article_prix")
                  self.defaults.set(self.locationlbl.text, forKey: "article_location")
                  self.defaults.set(self.categorielbl.text, forKey: "article_categorie")
                  self.defaults.set(self.souslbl.text, forKey: "article_sous_categorie")

                  self.defaults.set(self.titrelbl.text, forKey: "article_titre")
                  self.defaults.set(self.descriptionlbl.text, forKey: "article_description")









                  break
                  
              case .failure:
                  print(myresponse.error!)
                  break
              }
          }
        
           //        let name =  defaults.integer(forKey: "event_name")
//           nom.text = nameEvent
           
           
           let url = "http://41.226.11.252:11888/profile/article/\(articletId)"
           
           Alamofire.request(url, method: .get).responseJSON { (myresponse) in
               switch myresponse.result{
               case .success:
                   print(myresponse.result)
                   let myresult = try? JSON(data: myresponse.data!)
                   print(myresult!["articles"])
                   
                   let resultArray = myresult!["articles"]
                   
                   self.arr_article_id.removeAll()
                   self.arr_user_id.removeAll()
                   self.arr_user_name.removeAll()
                   self.arr_user_prenom.removeAll()
                   
                   for i in resultArray.arrayValue {
                       //                    print(i)
                       let article_id = i["id_article"].stringValue
                       self.arr_article_id.append(article_id)
                       let user_id = i["id"].stringValue
                       print("id following: \(user_id)")
                       self.defaults.set(user_id, forKey: "profil_id")
                       self.arr_user_id.append(user_id)
                       let user_name = i["name"].stringValue
                       self.arr_user_name.append(user_name)
                       let user_prenom = i["prenom"].stringValue
                       self.arr_user_prenom.append(user_prenom)
                       self.profileNameLbl.text = "\(i["name"].stringValue) \(i["prenom"].stringValue)"
                       //                    let profil = "\(i["name"].stringValue) \(i["prenom"].stringValue)"
                       self.defaults.set(("\(i["name"].stringValue) \(i["prenom"].stringValue)"), forKey: "profil")
                       
                       
                       
                       
                   }
                   break
                   
               case .failure:
                   print(myresponse.error!)
                   break
               }
            
           
    }
        let tap = UITapGestureRecognizer(target: self, action: #selector(ArticleDetailsViewController.tapFunction))
                          profileNameLbl.isUserInteractionEnabled = true
                          profileNameLbl.addGestureRecognizer(tap)
    let id =  defaults.integer(forKey: "article_id")

        if #available(iOS 13.0, *) {
                 if (retrieveFavoris(articleId: id) == true)
                 {
                     favoris_btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
    
    @objc func tapFunction(gestureRecognizer: UIGestureRecognizer) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let vc = storyboard.instantiateViewController(identifier: "profilEvent")
           self.present(vc, animated: true, completion: nil)
       }
    
    func retrieveFavoris(articleId: Int) -> Bool {
           //        let eventId =  defaults.integer(forKey: "event_id")
           
           
           //As we know that container is set up in the AppDelegates so we need to refer that container.
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           
           //We need to create a context from this container
           let managedContext = appDelegate.persistentContainer.viewContext
           
           //Prepare the request of type NSFetchRequest  for the entity
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
           fetchRequest.predicate = NSPredicate(format: "id_article = %d", articleId)
           do {
               return try !managedContext.fetch(fetchRequest).isEmpty
           } catch {
               print("No Favoris", error)
               return false
           }
       }
       func addToFavoris(){
           let articleId =  defaults.integer(forKey: "article_id")
           let articleTitre =  defaults.object(forKey: "article_titre") as? String
           let articleDesc =  defaults.object(forKey: "article_description") as? String
           let articleLocation =  defaults.object(forKey: "article_location") as? String
           let articleCategorie =  defaults.object(forKey: "article_categorie") as? String
           let articleSousCategorie =  defaults.object(forKey: "article_sous_categorie")
           let articlePrix =  defaults.integer(forKey: "article_prix") 
       
           
           
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           let coreContext = appDelegate?.persistentContainer.viewContext
           let itemEntityDescription = NSEntityDescription.entity(forEntityName: "Article", in: coreContext!)
           let item = NSManagedObject(entity: itemEntityDescription!, insertInto: coreContext)
           item.setValue(articleId , forKey: "id_article")
           item.setValue(articleTitre , forKey: "titre")
           item.setValue(articleCategorie , forKey: "categorie")
           item.setValue(articleSousCategorie , forKey: "sous_categorie")
           item.setValue(articlePrix , forKey: "prix")
           item.setValue(articleDesc , forKey: "desc")
        item.setValue(articleLocation , forKey: "location")

    
           
           
           
           
           
           do {
               try coreContext?.save()
               print("saved")
               loadFavoris()
               
           } catch let error as NSError {
               print(error.userInfo)
           }
       }
       
       func deleteFavoris(articleId: Int){
           let articleId =  defaults.integer(forKey: "article_id")

           //As we know that container is set up in the AppDelegates so we need to refer that container.
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           //We need to create a context from this container
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
           fetchRequest.predicate = NSPredicate(format: "id_article = %d", articleId)
           
           
           do
           {
               let test = try managedContext.fetch(fetchRequest)
               let objectToDelete = test[0] as! NSManagedObject
               managedContext.delete(objectToDelete)
               
               do{
                   try managedContext.save()
                   print("deleted")
                   loadFavoris()
               }
               catch
               {
                   print(error)
               }
               
           }
           catch
           {
               print(error)
           }
       }
       func loadFavoris() {
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           let coreContext = appDelegate?.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Article")
           do {
               lists = try coreContext!.fetch(fetchRequest)
               print(lists)
           } catch let error as NSError {
               print(error.userInfo)
           }
       }
    @IBAction func addFavoris(_ sender: Any) {
         let id =  defaults.integer(forKey: "article_id")

         if #available(iOS 13.0, *) {
             if (retrieveFavoris(articleId: id) == true)
                 
             {
                 favoris_btn.setImage(UIImage(systemName: "star"), for: .normal)
                 deleteFavoris(articleId: id)
                 
             }
             else {
                 favoris_btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                 addToFavoris()
             }
             
         }
         
     }
       
}
