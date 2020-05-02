//
//  FavoriteArticlesViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 16/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import CoreData

class FavoriteArticlesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var lists : [NSManagedObject] = [] {
          didSet {
              self.articleTableView.reloadData()
          }
      }
    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.dataSource = self
        articleTableView.delegate = self
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
       let cell = articleTableView.dequeueReusableCell(withIdentifier: "articleCell")
                      let contentView = cell?.viewWithTag(0)
                      let articleId = contentView?.viewWithTag(4) as! UILabel
                      
                      let articleTitre = contentView?.viewWithTag(1) as! UILabel
                      
                      let articleCategorie = contentView?.viewWithTag(2) as! UILabel
                   let articleSousCategorie = contentView?.viewWithTag(5) as! UILabel
        let item = lists[indexPath.row]
               print(item)
           //           let articleDescription = contentView?.viewWithTag(3) as! UITextView
                      articleId.text = String((item.value(forKey: "id_article") as! Int))
                     
                      articleTitre.text = item.value(forKey: "titre") as? String
                      articleCategorie.text = item.value(forKey: "categorie") as? String
                      articleSousCategorie.text = item.value(forKey: "sous_categorie") as? String
       




        return cell!
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
