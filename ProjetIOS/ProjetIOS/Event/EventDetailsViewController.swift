//
//  toEventDetailsViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 10/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import AlamofireImage

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btn_details: UIButton!
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var favoris_btn: UIButton!
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var btn_participate: UIButton!
    var idEvent:Int?
    var nameEvent:String?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var participatebtn: UIButton!
    
    var arr_event_id = [String]()
    var arr_user_id = [String]()
    var arr_user_name = [String]()
    var arr_user_prenom = [String]()
    var arr_user_image = [String]()

    
    let defaults = UserDefaults.standard
    
    var lists : [NSManagedObject] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //            if(segue.identifier == "toArticleDetails"){
        
        let eventId = idEvent
        let eventName = nameEvent
        let detailsViewController = segue.destination as! DetailsEventContainerViewController
        detailsViewController.id = eventId
        detailsViewController.name = eventName
        
        
        //            }
        
    }
    
    override func viewDidLoad() {
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage?.clipsToBounds = true
        profileImage?.layer.borderWidth = 3.0
        profileImage?.layer.borderColor = UIColor.white.cgColor
        let serverUrl = "http://41.226.11.252:11888/participant/verify"
        
        let eventId =  defaults.integer(forKey: "event_id")
        let userId =  defaults.integer(forKey: "user_id")
        
        let addParticipantRequest = [
            "id_user" : userId,
            "id_evenement" : idEvent!
            
        ]
        
        Alamofire.request(serverUrl, method: .post, parameters: addParticipantRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson1 = JSON(responseObject.result.value!)
                print(resJson1)
                if (resJson1 == "participated already")
                {
                    self.btn_participate.setTitle("Annuler", for: .normal)
                    self.btn_participate.backgroundColor = .red
                    if #available(iOS 13.0, *) {
                        self.btn_participate.setImage(UIImage(systemName: "xmark.seal.fill"), for: .normal)
                        self.btn_participate.tintColor = .white
                    }
                    
                    
                }
                
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print(error)
            }
        }
        let id =  defaults.integer(forKey: "event_id")
        //        let name =  defaults.integer(forKey: "event_name")
        nom.text = nameEvent
        
        
        let url = "http://41.226.11.252:11888/profile/event/\(idEvent!)"
        
        Alamofire.request(url, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                print(myresponse.result)
                let myresult = try? JSON(data: myresponse.data!)
                print(myresult!["evenements"])
                
                let resultArray = myresult!["evenements"]
                
                self.arr_event_id.removeAll()
                self.arr_user_id.removeAll()
                self.arr_user_name.removeAll()
                self.arr_user_prenom.removeAll()
                self.arr_user_image.removeAll()

                
                for i in resultArray.arrayValue {
                    //                    print(i)
                    let event_id = i["id_evenement"].stringValue
                    self.arr_event_id.append(event_id)
                    let user_id = i["id"].stringValue
                    print("id following: \(user_id)")
                    self.defaults.set(user_id, forKey: "profil_id")
                    self.arr_user_id.append(user_id)
                    let user_name = i["name"].stringValue
                    self.arr_user_name.append(user_name)
                    let user_prenom = i["prenom"].stringValue
                    self.arr_user_prenom.append(user_prenom)
                    let user_image = i["image_user"].stringValue
                                   self.arr_user_image.append(user_image)
                    self.namelabel.text = "\(i["name"].stringValue) \(i["prenom"].stringValue)"
                    //                    let profil = "\(i["name"].stringValue) \(i["prenom"].stringValue)"
                    self.defaults.set(("\(i["name"].stringValue) \(i["prenom"].stringValue)"), forKey: "profil")
                    self.profileImage.af_setImage(withURL: URL(string: "http://localhost:1337/upload/"+i["image_user"].stringValue)!)

                    
                    
                    
                    
                }
                break
                
            case .failure:
                print(myresponse.error!)
                break
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(EventDetailsViewController.tapFunction))
        namelabel.isUserInteractionEnabled = true
        namelabel.addGestureRecognizer(tap)
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            if (retrieveFavoris(eventId: id) == true)
            {
                favoris_btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }
    }
    
    @objc func tapFunction(gestureRecognizer: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "profilEvent")
        self.present(vc, animated: true, completion: nil)
    }
    func retrieveFavoris(eventId: Int) -> Bool {
        //        let eventId =  defaults.integer(forKey: "event_id")
        
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        fetchRequest.predicate = NSPredicate(format: "id_event = %d", eventId)
        do {
            return try !managedContext.fetch(fetchRequest).isEmpty
        } catch {
            print("No Favoris", error)
            return false
        }
    }
    func addToFavoris(){
        let eventId =  defaults.integer(forKey: "event_id")
        let eventName =  defaults.object(forKey: "event_name") as? String
        let eventType =  defaults.object(forKey: "event_type") as? String
        let eventDebut =  defaults.object(forKey: "event_debut") as? String
        let eventFin =  defaults.object(forKey: "event_fin") as? String
        let eventDistance =  defaults.integer(forKey: "event_distance")
        let eventPhoto =  defaults.object(forKey: "event_photo") as? String
        let eventLieux =  defaults.object(forKey: "event_lieux") as? String
        let eventInfoline =  defaults.object(forKey: "event_infoline") as? String
        let eventDifficulte =  defaults.integer(forKey: "event_difficulte")
        let eventPrix =  defaults.integer(forKey: "event_prix")
        let eventDescription =  defaults.object(forKey: "event_description") as? String
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let coreContext = appDelegate?.persistentContainer.viewContext
        let itemEntityDescription = NSEntityDescription.entity(forEntityName: "Favoris", in: coreContext!)
        let item = NSManagedObject(entity: itemEntityDescription!, insertInto: coreContext)
        item.setValue(eventId , forKey: "id_event")
        item.setValue(eventName , forKey: "nom")
        item.setValue(eventType , forKey: "type")
        item.setValue(eventDebut , forKey: "debut")
        item.setValue(eventFin , forKey: "fin")
        item.setValue(eventDistance , forKey: "distance")
        item.setValue(eventPhoto , forKey: "photo")
        item.setValue(eventLieux , forKey: "lieux")
        item.setValue(eventInfoline , forKey: "infoline")
        item.setValue(eventDifficulte , forKey: "difficulte")
        item.setValue(eventPrix , forKey: "prix")
        item.setValue(eventDescription , forKey: "desc")
        
        
        
        
        
        do {
            try coreContext?.save()
            print("saved")
            loadFavoris()
            
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func deleteFavoris(eventId: Int){
        let eventId =  defaults.integer(forKey: "event_id")
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        fetchRequest.predicate = NSPredicate(format: "id_event = %d", eventId)
        
        
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favoris")
        do {
            lists = try coreContext!.fetch(fetchRequest)
            print(lists)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    //********************************** BOUTON PARTICIPER ********************************************
    @IBAction func btn_participate(_ sender: Any) {
        let serverUrl = "http://41.226.11.252:11888/participant/add"
        let serverUrl2 = "http://41.226.11.252:11888/participant/delete"
        
        //        let eventId =  defaults.integer(forKey: "event_id")
        let userId =  defaults.integer(forKey: "user_id")
        
        let addParticipantRequest = [
            "id_user" : userId,
            "id_evenement" : idEvent!
            
        ]
        print(addParticipantRequest)
        
        let url = "http://41.226.11.252:11888/participate/\(idEvent!)"
        let url2 = "http://41.226.11.252:11888/annuler/\(idEvent!)"
        
        if (btn_participate.currentTitle == "Participer")
        {
            Alamofire.request(url, method: .put,encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    print(resJson)
                    Alamofire.request(serverUrl, method: .post, parameters: addParticipantRequest as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                        if responseObject.result.isSuccess {
                            let resJson1 = JSON(responseObject.result.value!)
                            print(resJson1)
                            if (resJson == "decremented successfully" && resJson1 == "Participant ajouté avec succés"  )
                            {
                                self.btn_participate.setTitle("Annuler", for: .normal)
                                self.btn_participate.backgroundColor = .red
                                if #available(iOS 13.0, *) {
                                    self.btn_participate.setImage(UIImage(systemName: "xmark.seal.fill"), for: .normal)
                                    self.btn_participate.tintColor = .white
                                }
                                
                            }
                            else if (resJson == "no more places" && resJson1 == "Participant ajouté avec succés")
                            {
                                let myalert = UIAlertController(title: " CAMP WITH US", message: "Pas de places disponibles", preferredStyle: UIAlertController.Style.alert)
                                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                })
                                self.present(myalert, animated: true)
                                
                            }
                            else if (resJson == "decremented successfully" && resJson1 == "participated already")
                            {
                                let myalert = UIAlertController(title: " CAMP WITH US", message: "Vous etes déjà participé", preferredStyle: UIAlertController.Style.alert)
                                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                })
                                self.present(myalert, animated: true)
                                self.btn_participate.setTitle("Annuler", for: .normal)
                                self.btn_participate.backgroundColor = .red
                                if #available(iOS 13.0, *) {
                                    self.btn_participate.setImage(UIImage(systemName: "xmark.seal.fill"), for: .normal)
                                    self.btn_participate.tintColor = .white
                                }
                            }
                            else if (resJson == "no more places" && resJson1 == "participated already")
                            {
                                let myalert = UIAlertController(title: " CAMP WITH US", message: "Pas de places disponibles", preferredStyle: UIAlertController.Style.alert)
                                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
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
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    print(error)
                }
            }
        }
        else {
            Alamofire.request(serverUrl2, method: .delete, parameters: addParticipantRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJson1 = JSON(responseObject.result.value!)
                    print(resJson1)
                    self.btn_participate.setTitle("Participer", for: .normal)
                    self.btn_participate.backgroundColor = .green
                    if #available(iOS 13.0, *) {
                        self.btn_participate.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
                        self.btn_participate.tintColor = .white
                    }
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    print(error)
                }
            }
            
            Alamofire.request(url2, method: .put,encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    print(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    print(error)
                }
            }
        }
    }
    
    @IBAction func addFavoris(_ sender: Any) {
        let id =  defaults.integer(forKey: "event_id")
        
        if #available(iOS 13.0, *) {
            if (retrieveFavoris(eventId: id) == true)
                
            {
                favoris_btn.setImage(UIImage(systemName: "star"), for: .normal)
                deleteFavoris(eventId: id)
                
            }
            else {
                favoris_btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                addToFavoris()
            }
            
        }
        
    }
    
    
    
    @IBAction func display_details(_ sender: Any) {
        if btn_details.titleLabel!.text!  == "Cacher Détails >" as String   {
            containerView.isHidden = true
            btn_details.setTitle("Afficher Détails >", for: .normal)
        }
        else   {
            containerView.isHidden = false
            btn_details.setTitle("Cacher Détails >", for: .normal)
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
