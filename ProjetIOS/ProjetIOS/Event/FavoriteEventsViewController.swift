//
//  FavoriteEventsViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 16/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import CoreData

class FavoriteEventsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    var lists : [NSManagedObject] = [] {
        didSet {
            self.favorisEventTableView.reloadData()
        }
    }
    @IBOutlet weak var favorisEventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorisEventTableView.dataSource = self
        favorisEventTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadFavoris()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favorisEventTableView.dequeueReusableCell(withIdentifier: "FavorisCell")
        let contentView = cell?.viewWithTag(0)
        let eventId = contentView?.viewWithTag(4) as! UILabel
        let eventName = contentView?.viewWithTag(1) as! UILabel
        let eventDate = contentView?.viewWithTag(2) as! UILabel
        let eventDescription = contentView?.viewWithTag(3) as! UITextView
        let item = lists[indexPath.row]
        print(item)
        eventId.text = String((item.value(forKey: "id_event") as! Int))
        eventName.text = item.value(forKey: "nom") as? String
        eventDate.text = item.value(forKey: "debut") as? String
        eventDescription.text = item.value(forKey: "desc") as? String
        
        
        
        return cell!
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toEventDetails", sender: indexPath)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toEventDetails"){
            
            
            let indexPath = sender as! IndexPath
            
            let item = lists[indexPath.row]
            
            let eventId = item.value(forKey: "id_event") as! Int
            let eventName = item.value(forKey: "nom") as? String
            
            print("event clicked \(eventId)")
            print("event name \(eventName!)")
            
            
            let detailsViewController = segue.destination as! EventDetailsViewController
            
            
            detailsViewController.idEvent = eventId
            detailsViewController.nameEvent = eventName
            
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

