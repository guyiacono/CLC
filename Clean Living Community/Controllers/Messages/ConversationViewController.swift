//
//  ConversationViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/30/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var thisMessageUID: String?
    var userModel = UserModel.sharedInstance
    var messageModel = MessageModel.sharedInstance
    let signedInUserID = Auth.auth().currentUser?.uid
    var messageText : [[String : String]]?
    
    var textContents: String?
    
    var otherUser : User?
    
    @IBOutlet weak var table: UITableView!
    
    
    
    @IBOutlet weak var entryField: UITextField!
    
    @IBAction func entryFieldChanged(_ sender: UITextField)
    {
        textContents = sender.text
    }
    
    
    
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendAction(_ sender: UIButton)
    {
        if (textContents != "")
        {
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMddyyyyHHmmss"
            let printDate = formatter.string(from: today)
           
            
            
            messageModel.sendNewText(messageID: thisMessageUID!, dateTime: printDate, senderUID: signedInUserID!, text: textContents!, completion: {(success)
                in
                    if (success)
                    {
                        //self.viewDidLoad()
                        self.entryField.text = ""
                    }
                })
        }
    }
    
   

    override func viewDidLoad()
    {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        messageModel.listAllMessages(completion: {(success)
        in
            if (success)
            {
                self.messageModel.getMessageData(messageID: self.thisMessageUID!, completion: {(list)
                    in
                    if (list.count >= 0)
                    {
                        self.messageText = list
                        self.table.reloadData()
                    }
                    })
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(messageText != nil)
        {
            return messageText!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = table.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! ConversationTableViewCell
        let temp = messageText![indexPath.row]
        
        print(messageText![indexPath.row])
        if(temp[(signedInUserID)!] != nil)
        {
            cell.messageText.text = temp[signedInUserID!]
            print(temp[signedInUserID!]!)
            
            
        }
        else
        {
            cell.messageText.text = temp[(otherUser?.key)!]
            print(temp[(otherUser?.key)!]!)
         
        }
        
        return cell
        
    }

    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
