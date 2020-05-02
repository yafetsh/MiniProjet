//
//  DetailsContainerViewController.swift
//  Alamofire
//
//  Created by Yafet Shil on 17/12/2019.
//

import UIKit
import Alamofire
import SwiftyJSON
class DetailsContainerViewController: UIViewController {
    
    @IBOutlet weak var difficulte: UILabel!
      @IBOutlet weak var lieux: UILabel!
      @IBOutlet weak var distance: UILabel!
      @IBOutlet weak var fin: UILabel!
      @IBOutlet weak var debut: UILabel!
      @IBOutlet weak var type: UILabel!
    @IBOutlet weak var prix: UILabel!
    @IBOutlet weak var infoline: UILabel!
    @IBOutlet weak var descriptionlbl: UITextView!
    var nameEvent:String = ""
    var typeEvent:String = ""
    var debutEvent:String = ""
    var finEvent:String = ""
    var distanceEvent:String = ""
    var lieuxEvent:String = ""
    var infolineEvent:String = ""
    var difficulteEvent:String = ""
    var prixEvent:String = ""
    var descriptionEvent:String = ""
    var arr_event_lieux = [String]()
    var arr_event_distance = [String]()
    var arr_event_type = [String]()
    var arr_event_datedebut = [String]()
    var arr_event_description = [String]()
    var idEvent:String?
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventId =  defaults.integer(forKey: "event_id")
          let myapiurl = "http://localhost:1337/evenement/show/\(eventId)"
          
          Alamofire.request(myapiurl).responseJSON { (myresponse) in
              switch myresponse.result{
              case .success:
                  print("response: \(myresponse.result)")
                  let myresult = try? JSON(data: myresponse.data!)
                  print(myresult!["evenement"])
                  
                  let resultArray = myresult!["evenement"]
                  
                  for i in resultArray.arrayValue {
                      self.nom.text = i["nom_evenement"].stringValue
                      self.prix.text = i["prix_evenement"].stringValue
                      self.infoline.text = i["infoline"].stringValue
                      self.difficulte.text = i["difficulte_evenement"].stringValue
                      self.lieux.text = i["lieux_evenement"].stringValue
                      self.distance.text = i["distance_evenement"].stringValue
                      self.type.text = i["type_evenement"].stringValue
                      self.debut.text = i["date_debut_evenement"].stringValue
                      self.fin.text = i["date_fin_evenement"].stringValue
                      self.descriptionlbl.text = i["description_evenement"].stringValue
                      
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
