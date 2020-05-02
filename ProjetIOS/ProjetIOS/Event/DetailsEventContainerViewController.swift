//
//  DetailsEventContainerViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 17/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsEventContainerViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var difficulte: UILabel!
    @IBOutlet weak var lieux: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var fin: UILabel!
    @IBOutlet weak var debut: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var prix: UILabel!
    @IBOutlet weak var idlbl: UILabel!
    @IBOutlet weak var nomlbl: UILabel!

    @IBOutlet weak var infoline: UILabel!
    @IBOutlet weak var descriptionlbl: UITextView!
    var arr_event_lieux = [String]()
    var arr_event_distance = [String]()
    var arr_event_type = [String]()
    var arr_event_datedebut = [String]()
    var arr_event_description = [String]()
    var id:Int?
    var name:String?
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width ?? 0.0) / 2
        profileImage?.clipsToBounds = true
        profileImage?.layer.borderWidth = 3.0
        profileImage?.layer.borderColor = UIColor.white.cgColor
        
        //        let eventId =  defaults.integer(forKey: "event_id")
        let myapiurl = "http://41.226.11.252:11888/evenement/show/\(id!)"
        
        Alamofire.request(myapiurl).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                print("response: \(myresponse.result)")
                let myresult = try? JSON(data: myresponse.data!)
                print(myresult!["evenement"])

                let resultArray = myresult!["evenement"]
                
                for i in resultArray.arrayValue {
                    self.prix.text = "\(i["prix_evenement"].stringValue) DT"
                    self.idlbl.text = "\(i["id_evenement"].stringValue) DT"
                    self.nomlbl.text = i["nom_evenement"].stringValue
                    self.infoline.text = i["infoline"].stringValue
                    self.difficulte.text = "\(i["difficulte_evenement"].stringValue)/10"
                    self.lieux.text = "\(i["lieux_evenement"].stringValue)"
                    self.distance.text = "\(i["distance_evenement"].stringValue) KM"
                    self.type.text = i["type_evenement"].stringValue
                    self.debut.text = " De \(i["date_debut_evenement"].stringValue) à "
                    self.fin.text = i["date_fin_evenement"].stringValue
                    self.descriptionlbl.text = i["description_evenement"].stringValue
                    
                }
                self.defaults.set(self.idlbl.text, forKey: "event_id")
                             self.defaults.set(self.nomlbl.text, forKey: "event_nom")
                self.defaults.set(self.prix.text, forKey: "event_prix")
                self.defaults.set(self.infoline.text, forKey: "event_infoline")
                self.defaults.set(Int(self.difficulte.text!), forKey: "event_difficulte")
                self.defaults.set(self.lieux.text, forKey: "event_lieux")
                self.defaults.set(Int(self.distance.text!), forKey: "event_distance")
                self.defaults.set(self.type.text, forKey: "event_type")
                self.defaults.set(self.debut.text, forKey: "event_debut")
                self.defaults.set(self.fin.text, forKey: "event_fin")
                self.defaults.set(self.descriptionlbl.text, forKey: "event_description")
 
                break
                
            case .failure:
                print(myresponse.error!)
                break
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
