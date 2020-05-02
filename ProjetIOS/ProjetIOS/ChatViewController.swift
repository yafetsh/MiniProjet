//
//  ChatViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 10/01/2020.
//  Copyright © 2020 4SIM4. All rights reserved.
//

import UIKit
import PubNub
import Alamofire
import SwiftyJSON

class ChatViewController: UIViewController,PNObjectEventListener, UITableViewDataSource, UITableViewDelegate {

    var messages: [String] = []
    let defaults = UserDefaults.standard
    var arr_message = [String]()
       var arr_message_id = [Int]()
       var arr_message_date = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
//        let point = CGPoint(x: 0, y: self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.frame.height)
//              if point.y >= 0{
//                self.tableView.setContentOffset(point, animated: true)
//              }
//        let numberOfSections = self.tableView.numberOfSections
//        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
//
//        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
//        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        let senderId =  defaults.integer(forKey: "user_id")

        let myapiurl = "http://41.226.11.252:11888/message/show/\(senderId)"
          Alamofire.request(myapiurl, method: .get).responseJSON { (myresponse) in
              switch myresponse.result{
              case .success:
                  print(myresponse.result)
                  let myresult = try? JSON(data: myresponse.data!)
                  print(myresult!["messages"])
                  
                  let resultArray = myresult!["messages"]
//                  self.arr_message_id.removeAll()
//                                               self.arr_message.removeAll()
//                                               self.arr_message_date.removeAll()
                  for i in resultArray.arrayValue {
                      //                    print(i)
                      let message_id = Int(i["id"].stringValue)
                      self.arr_message_id.append(message_id!)
                      let message = i["message"].stringValue
                      self.arr_message.append(message)
//                    print(self.arr_message)
                      let message_date = i["date_message"].stringValue
                      self.arr_message_date.append(message_date)
                     
                  }
                 
                             
                  self.tableView.reloadData()
                  break
                  
              case .failure:
                  print(myresponse.error!)
                  break
              }
          }
    }

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_message_id.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell")
                   let contentView = cell?.viewWithTag(0)
                   let username = contentView?.viewWithTag(1) as! UILabel
                   
                   let message = contentView?.viewWithTag(2) as! UITextView
        let date = contentView?.viewWithTag(3) as! UILabel

                   let nom = defaults.object(forKey: "user_name") as? String
                   let prenom_connected = defaults.object(forKey: "user_prenom") as? String

        username.text = "\(String(prenom_connected!)) \(String(nom!))"
        message.text = arr_message[indexPath.row]
        date.text = arr_message_date[indexPath.row]

                   
                   
                   return cell!

    }
    
//    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
//    //Whenever we receive a new message, we add it to the end of our messages array and
//    //reload the table so that it shows at thebottom.
//    if(channelName == message.data.channel)
//    {
//        let m = message.data.message as! [String:String]
//        self.messages.append(Message(message: m["message"]!, username: m["username"]!, uuid: m["uuid"]!))
//        tableView.reloadData()
//        let indexPath = IndexPath(row: messages.count-1, section: 0)
//        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//    }
//    print("Received message in Channel:",message.data.message!)
//
//
//
//}
    
    //This method allows users to query for more messages by dragging down from the top.
//    func scrollViewDidScroll(_ scrollView: UIScrollView){
//        //If we are not loading more messages already
//        if(!loadingMore){
//            //-40 is when you have dragged down from the top of all the messages
//            if(scrollView.contentOffset.y < -40 ) {
//                loadingMore = true
//                addHistory(start: earliestMessageTime, end: nil, limit: 10)
//            }
//        }
//    }
//    func publishMessage() {
//        if(messageTextField.text != "" || messageTextField.text != nil){
//            let messageString: String = messageTextField.text!
//            let messageObject : [String:Any] =
//                [
//                    "message" : messageString,
//                    "username" : username,
//                    "uuid": client.uuid()
//            ]
//            client.publish(messageObject, toChannel: channelName) { (status) in
//                print(status.data.information)
//            }
//            messageTextField.text = ""
//        }
//    }
    //When the send button is clicked, the message will send
    @IBAction func sendMessage(_ sender: UIButton) {
        let serverUrl = "http://41.226.11.252:11888/message/send"
        
        let connectedUserId =  defaults.integer(forKey: "user_id")
        let profileId =  defaults.integer(forKey: "profil_id")

        
        guard let message = messageTextField.text, !message.isEmpty else {return}
    
        
        
        let addMessageRequest = [
            "id_sender" : connectedUserId,

            "id_receiver" : profileId,
            "message" : message
            
            ] as [String : Any]
        
        print(addMessageRequest)
        

        
        Alamofire.request(serverUrl, method: .post, parameters: addMessageRequest, encoding: JSONEncoding.default, headers: nil).responseString { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                print(resJson)
             
                let senderId =  self.defaults.integer(forKey: "user_id")

                        let myapiurl = "http://41.226.11.252:11888/message/show/\(senderId)"
                          Alamofire.request(myapiurl, method: .get).responseJSON { (myresponse) in
                              switch myresponse.result{
                              case .success:
                                  print(myresponse.result)
                                  let myresult = try? JSON(data: myresponse.data!)
//                                  print(myresult!["messages"])
//
//                                  let resultArray = myresult!["messages"]
//
//                                  for i in resultArray.arrayValue {
//                                      //                    print(i)
//                                      let message_id = Int(i["id"].stringValue)
//                                      self.arr_message_id.append(message_id!)
//                                      let message = i["message"].stringValue
//                                      self.arr_message.append(message)
//                //                    print(self.arr_message)
//                                      let message_date = i["date_message"].stringValue
//                                      self.arr_message_date.append(message_date)
//
//                                  }
                                  self.tableView.reloadData()
//                                  let numberOfSections = self.tableView.numberOfSections
//                                  let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
//
//                                  let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
//                                  self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                                  // First figure out how many sections there are
//                                  let lastSectionIndex = self.tableView.numberOfSections-1
//
//                                  // Then grab the number of rows in the last section
//                                  let lastRowIndex = self.tableView!.numberOfRows(inSection: lastSectionIndex) - 1
//
//                                  // Now just construct the index path
//                                  let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
//
//                                  // Make the last row visible
//                                  self.tableView?.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.none, animated: true)
                                  break

                              case .failure:
                                  print(myresponse.error!)
                                  break
                              }
                }
                
                self.arr_message.append(message)
                print(self.arr_message)
                self.tableView.reloadData()
                self.messageTextField.text = ""


            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print(error)
            }
            
            
        }
//        publishMessage()
    }
}
