//
//  AddEventViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 05/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GooglePlaces
import MapKit

class AddEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tblSearchResult: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    let myPickerData =  ["Family Camps", "Art Camps", "Education Camps", "Sport Camps", "Overnight Camps"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typetf.text = myPickerData[row]
        
    }
    
    
    @IBOutlet weak var nomtf: UITextField!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var typetf: UITextField!
    @IBOutlet weak var fintf: UITextField!
    @IBOutlet weak var descriptiontf: UITextView!
    @IBOutlet weak var lieuxtf: UITextField!
    @IBOutlet weak var infolinetf: UITextField!
    @IBOutlet weak var prixtf: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var distancetf: UITextField!
    @IBOutlet weak var difficultetf: UITextField!
    @IBOutlet weak var nbrplacetf: UITextField!
    @IBOutlet weak var stepperplace: UIStepper!
    @IBOutlet weak var debutf: UITextField!
    let defaults = UserDefaults.standard
    
    lazy var datePicker: UIDatePicker = {
        
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    lazy var datePicker2: UIDatePicker = {
        
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        
        picker.addTarget(self, action: #selector(datePickerChanged2(_:)), for: .valueChanged)
        
        return picker
    }()
    lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    
    @IBAction func stepperPlaceChanged(_ sender: UIStepper) {
        nbrplacetf.text = Int(sender.value).description
        
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        difficultetf.text = Int(sender.value).description
        
    }

  
    @IBAction func locationAgain(_ sender: Any) {
        locationView.isHidden = true

    }
    @IBAction func locationClick(_ sender: Any) {
        locationView.isHidden = false

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //type picker
        let thePicker = UIPickerView()
        typetf.inputView = thePicker
        thePicker.delegate = self
        debutf.inputView = datePicker
        fintf.inputView = datePicker2
        difficultetf.isEnabled = false
        prixtf.delegate = self
        prixtf.keyboardType = .numberPad
      
        
        
        
        //date debut picker
        //        let datePicker = UIDatePicker()
        //        datePicker.datePickerMode = UIDatePicker.Mode.date
        //        datePicker.addTarget(self, action: #selector(AddEventViewControlle), for: <#T##UIControl.Event#>)
        
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharachters = "0123456789"
        let allowedCharachterSet = CharacterSet(charactersIn: allowedCharachters)
        let typedCharachterSet = CharacterSet(charactersIn: string)
        
        
        return allowedCharachterSet.isSuperset(of: typedCharachterSet)
        
    }
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        
        debutf.text = dateFormatter.string(from: sender.date)
        
    }
    @objc func datePickerChanged2(_ sender: UIDatePicker) {
        
        fintf.text = dateFormatter.string(from: sender.date)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
  
    
    
    
    @IBAction func add_event_btn(_ sender: Any) {
        
        let serverUrl = "http://41.226.11.252:11888/evenement/add"
        
        let connectedUserId =  defaults.integer(forKey: "user_id")
        
        
        guard let nom = nomtf.text, !nom.isEmpty else {return}
        guard let type = typetf.text, !type.isEmpty else {return}
        guard let date_debut = debutf.text, !date_debut.isEmpty else {return}
        guard let date_fin = fintf.text, !date_fin.isEmpty else {return}
        guard let distance = distancetf.text, !distance.isEmpty else {return}
        guard let lieux = lieuxtf.text, !lieux.isEmpty else {return}
        guard let infoline = infolinetf.text, !infoline.isEmpty else {return}
        guard let difficulte = difficultetf.text, !difficulte.isEmpty else {return}
        guard let prix = prixtf.text, !prix.isEmpty else {return}
        guard let nbrplace = nbrplacetf.text, !nbrplace.isEmpty else {return}
        
        guard let description = descriptiontf.text, !description.isEmpty else {return}
        
        
        let addEventRequest = [
            "nom_evenement" : nom,
            "type_evenement" : type,
            "date_debut_evenement" : date_debut,
            "date_fin_evenement" : date_fin,
            "distance_evenement" : distance,
            "lieux_evenement" : lieux,
            "infoline" : infoline,
            "difficulte_evenement" : difficulte,
            "prix_evenement" : prix,
            "nbr_place" : nbrplace,
            "description_evenement" : description,
            "id_user" : connectedUserId
            
            ] as [String : Any]
        
        print(addEventRequest)
        
        
        
        Alamofire.request(serverUrl, method: .post, parameters: addEventRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                print(resJson)
                let myalert = UIAlertController(title: " CAMP WITH US", message: "Votre évènement est ajouté avec succés", preferredStyle: UIAlertController.Style.alert)
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
extension AddEventViewController: GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // Get the place name from 'GMSAutocompleteViewController'
    // Then display the name in textField
    lieuxtf.text = place.name
// Dismiss the GMSAutocompleteViewController when something is selected
    dismiss(animated: true, completion: nil)
  }
func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // Handle the error
    print("Error: ", error.localizedDescription)
  }
func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    // Dismiss when the user canceled the action
    dismiss(animated: true, completion: nil)
  }
}
