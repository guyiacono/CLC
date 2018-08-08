//
//  MessagesViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/4/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseCore

class MessagesViewController: UITableViewController
{
    var userModel = UserModel.sharedInstance
    let currentUserID = Auth.auth().currentUser?.uid
    var message : [String: String]?
    var messagesSorted: [(key: String, value: String)]?
    var sortedMessageUIDS: [String] = []
    
    var sentMessageUID : String?
    var otherUser : User?
   
    @IBOutlet weak var new: UIButton!
    @IBAction func newPressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toConnectionsWithoutMessage", sender: Any?.self)
    }
    
    
    override func viewDidLoad()
    {
        userModel.listAllMessages(withUID: currentUserID, completion: {(list)
            in
            if (list.count >= 0)
            {
                self.message = list
                self.messagesSorted = (self.message?.sorted(by: {$0.value < $1.value}))!
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       return(1)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(messagesSorted != nil)
        {
            return (messagesSorted?.count)!
        }
        else
        {
            return(0)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listofmessages", for: indexPath) as! ListofMessagesTableViewCell
        
        var tempUser = userModel.findUser(uid: messagesSorted![indexPath.row].key)
        setImageFromURl(stringImageUrl: (tempUser?.url1)!, forImage: cell.photo)
        cell.name.text = (tempUser?.first)! + " " + (tempUser?.last)!
        cell.preview.text = "sample text"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = Date()
        let stringDate: String = formatter.string(from: date)
        cell.date.font = cell.date.font.withSize(10)
        cell.date.text = "\(stringDate)"
        
        sortedMessageUIDS.append(messagesSorted![indexPath.row].value)
        
        // Configure the cell...
        return cell
    }
 
    
    func setImageFromURl(stringImageUrl url: String, forImage image: UIImageView)
    {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                image.image = UIImage(data: data as Data)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        for uid in sortedMessageUIDS
        {
            if(uid == sortedMessageUIDS[indexPath.row])
            {
                sentMessageUID = uid
                otherUser = userModel.findUser(uid: messagesSorted![indexPath.row].key)
                
            }
        }
        performSegue(withIdentifier: "toConversation", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toConversation"
        {
            let destinationVC = segue.destination as! ConversationViewController
            destinationVC.thisMessageUID = sentMessageUID
            destinationVC.otherUser = otherUser
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
