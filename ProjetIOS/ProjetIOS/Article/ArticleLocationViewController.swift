//
//  ArticleLocationViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 08/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleLocationViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

      
    @IBOutlet weak var articleTableView: UITableView!
    
    var arr_article_titre = [String]()
    var arr_article_id = [Int]()
    var arr_article_type = [String]()
    var arr_article_location = [String]()
    var arr_article_categorie = [String]()
    var arr_article_sous_categorie = [String]()
    var arr_article_prix = [String]()
    var arr_article_description = [String]()
    let defaults = UserDefaults.standard
    
    var nom:String?
    override func viewDidLoad() {
        
        self.articleTableView.delegate = self
        self.articleTableView.dataSource = self
        let myapiurl = "http://41.226.11.252:11888/article/louer"
        Alamofire.request(myapiurl, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                print(myresponse.result)
                let myresult = try? JSON(data: myresponse.data!)
                print(myresult!["articles"])
                
                let resultArray = myresult!["articles"]
                
                self.arr_article_id.removeAll()
                self.arr_article_titre.removeAll()
                self.arr_article_type.removeAll()
                self.arr_article_location.removeAll()
                self.arr_article_categorie.removeAll()
                self.arr_article_sous_categorie.removeAll()
                self.arr_article_prix.removeAll()
                self.arr_article_description.removeAll()

                
                
                
                
                
                for i in resultArray.arrayValue {
                    //                    print(i)
                    let article_id = Int(i["id_article"].stringValue)
                    self.arr_article_id.append(article_id!)
                    let article_titre = i["titre_article"].stringValue
                    self.arr_article_titre.append(article_titre)
                    let article_type = i["type_article"].stringValue
                    self.arr_article_type.append(article_type)
                    let article_location = i["location_article"].stringValue
                    self.arr_article_location.append(article_location)
                    let article_categorie = i["categorie_article"].stringValue
                    self.arr_article_categorie.append(article_categorie)
                    let article_sous_categorie = i["sous_categorie_article"].stringValue
                    self.arr_article_sous_categorie.append(article_sous_categorie)
                    let article_prix = i["prix_article"].stringValue
                    self.arr_article_prix.append(article_prix)
                    let article_description = i["description_article"].stringValue
                    self.arr_article_description.append(article_description)
                    
                }
                self.articleTableView.reloadData()
                break
                
            case .failure:
                print(myresponse.error!)
                break
            }
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return arr_article_id.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = articleTableView.dequeueReusableCell(withIdentifier: "articleCell")
           let contentView = cell?.viewWithTag(0)
           let articleId = contentView?.viewWithTag(4) as! UILabel
           
           let articleTitre = contentView?.viewWithTag(1) as! UILabel
           
           let articleCategorie = contentView?.viewWithTag(2) as! UILabel
        let articleSousCategorie = contentView?.viewWithTag(5) as! UILabel
        let articleLieux = contentView?.viewWithTag(6) as! UILabel


//           let articleDescription = contentView?.viewWithTag(3) as! UITextView
           articleId.text = String(arr_article_id[indexPath.row])
           articleTitre.text = arr_article_titre[indexPath.row]
           articleCategorie.text = arr_article_categorie[indexPath.row]
           articleSousCategorie.text = arr_article_sous_categorie[indexPath.row]
articleLieux.text = arr_article_location[indexPath.row]

           
           
           return cell!
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            performSegue(withIdentifier: "toArticleDetails", sender: indexPath)
            
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if(segue.identifier == "toArticleDetails"){
                
            
            let indexPath = sender as! IndexPath

            let indice = indexPath.row

            let articleId = arr_article_id[indice]
                let articleTitre = arr_article_titre[indice]

            print("event clicked \(articleId)")
                print("event name \(articleTitre)")

            self.defaults.set(articleId, forKey: "article_id")
    //        self.defaults.set(eventName, forKey: "event_name")



            //        let imgCandidat = imagesCandidats[indice]

            let detailsViewController = segue.destination as! ArticleDetailsViewController

            //        detailsViewController.img = imgCandidat

                detailsViewController.idArticle = articleId
                detailsViewController.nomArticle = articleTitre


    }

}
}
