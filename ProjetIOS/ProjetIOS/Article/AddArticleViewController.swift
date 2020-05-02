//
//  AddArticleViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 08/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddArticleViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    

    @IBOutlet weak var sousCategorie: UITextField!
    @IBOutlet weak var titretf: UITextField!
    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var prixtf: UITextField!
    @IBOutlet weak var locationtf: UITextField!
    @IBOutlet weak var categorietf: UITextField!
    @IBOutlet weak var descriptiontf: UITextView!
    let defaults = UserDefaults.standard
    var type = [String]()
    let categories =  ["BOIRE ET MANGER", "COUCHAGE", "Fourniture et Hygiène", "Tente et Abris"]
    let boire =  ["Gourdes et poches d'eau", "Glacières", "Bouteilles et boites isothermiques", "Popotes, couverts et accessoires repas"]
    let couchage =  ["Sac de couchage et draps", "Matelas", "Lits de camping", "Pompes","Hamacs","Oreillers et couvertes","Piéces détaché et accessoires"]
    let fourniture =  ["Tables de camping", "Chaises de camping", "Eclairage et recharge", "Hygiène","Protection de peau"]
    let tentes =  ["Tentes de camping", "Couchage", "Pompes et gonflables", "Accessoires de camping"]
    
    
    override func viewDidLoad() {
        prixtf.delegate = self
        prixtf.keyboardType = .numberPad
        let thePicker1 = UIPickerView()
        categorietf.inputView = thePicker1
        thePicker1.delegate = self
        thePicker1.tag = 1
        let thePicker2 = UIPickerView()
        sousCategorie.inputView = thePicker2
        thePicker2.delegate = self
        thePicker2.tag = 2
        stateSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
//        if categorietf.text == "BOIRE ET MANGER"{
//            type = boire
//
//        }
//        else if categorietf.text == "COUCHAGE" {
//            type = couchage
//
//        }
//        else if categorietf.text == "Fourniture et Hygiène" {
//            type = fourniture
//
//        }
//        else {
//            type = fourniture
//
//        }
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1
        {
            return categories[row]

        
        }
        else if pickerView.tag == 2{
            if categorietf.text == "BOIRE ET MANGER"{
            return boire[row]
                       }
                       else if categorietf.text == "COUCHAGE" {
                           return couchage[row]

                       }
                       else if categorietf.text == "Fourniture et Hygiène" {
                           return fourniture[row]

                       }
                       else {
                           return tentes[row]

                       }

        }
        else {return ""}
     
          
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
        return categories.count
        }
        else {
            return tentes.count

        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            categorietf.text = categories[row]
            sousCategorie.text = ""

            
        }
        else {
            if categorietf.text == "BOIRE ET MANGER"{
 sousCategorie.text = boire[row]
            }
            else if categorietf.text == "COUCHAGE" {
                sousCategorie.text = couchage[row]

            }
            else if categorietf.text == "Fourniture et Hygiène" {
                sousCategorie.text = fourniture[row]

            }
            else {
                sousCategorie.text = tentes[row]

            }
            
        }
    }
    

    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            typelbl.text = "vente"
        } else {
            typelbl.text = "location"
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharachters = "0123456789"
        let allowedCharachterSet = CharacterSet(charactersIn: allowedCharachters)
        let typedCharachterSet = CharacterSet(charactersIn: string)
        
        
        return allowedCharachterSet.isSuperset(of: typedCharachterSet)
        
    }
    
    
    
    @IBAction func add_btn(_ sender: Any) {
        let serverUrl = "http://41.226.11.252:11888/article/add"
        let connectedUserId =  defaults.integer(forKey: "user_id")
        
        guard let titre = titretf.text, !titre.isEmpty else {return}
        guard let type = typelbl.text, !type.isEmpty else {return}
        guard let categorie = categorietf.text, !categorie.isEmpty else {return}
        guard let sous_categorie = sousCategorie.text, !sous_categorie.isEmpty else {return}
        guard let location = locationtf.text, !location.isEmpty else {return}
        guard let prix = prixtf.text, !prix.isEmpty else {return}
        guard let description = descriptiontf.text, !description.isEmpty else {return}
        
        let addArticleRequest = [
            "titre_article" : titre,
            "type_article" : type,
            "categorie_article" : categorie,
            "sous_categorie_article" : sous_categorie,
            "location_article" : location,
            "prix_article" : prix,
            "description_article" : description,
            "user_id" : connectedUserId
            
            ] as [String : Any]
        
        print(addArticleRequest)
        

        Alamofire.request(serverUrl, method: .post, parameters: addArticleRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                print(resJson)
                let myalert = UIAlertController(title: "CAMP WITH US", message: "Votre article est ajouté avec succés", preferredStyle: UIAlertController.Style.alert)
                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                })
                self.present(myalert, animated: true)
                
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
