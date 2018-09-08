//
//  ConnectionsNoMessageTableViewController.swift
//  
//
//  Created by Michael Karolewicz on 8/8/18.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

class ConnectionsNoMessageTableViewController: UITableViewController
{
    var signedInUser = Auth.auth().currentUser
    var userModel = UserModel.sharedInstance
    var connections = [[String : String]]()
    var withMessage = [String : String]()
    var connectionsWithoutMessage = [[String : String]]()
    
    var newUser: User?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // get all the users connections
        userModel.getUnderConnections(withUID: signedInUser?.uid) { (list) in
            
            self.connections = list
            print("get under connections \(list)")
            // get all the user's messages
            self.userModel.listAllMessages(withUID: self.signedInUser?.uid, completion: { (messageList) in
                self.withMessage = messageList
                self.connectionsWithoutMessage.removeAll()
                print("messageList \(messageList)")
                
                // for each connection
                for connection in self.connections
                {
                    for message in self.withMessage
                    {
                        let uid = connection["UID"]
                        // if there is no message witht that connection
                        if(self.withMessage[uid!] == nil && connection["Request"] == "Accepted")
                        {
                            // append to the list
                            self.connectionsWithoutMessage.append(connection)
                        }
                    }
                }
                self.tableView.reloadData()
                
            })
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return connectionsWithoutMessage.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ConnectionWithNoMessageTableViewCell

        // populate the cell fields with the other user's profile data
        
        cell.profilePhoto.image = nil
        let connection = connectionsWithoutMessage[indexPath.row]
        cell.name.text = connection["Name"]
        setImageFromURl(stringImageUrl: connection["MainPhoto"]!, forImage: cell.profilePhoto)
        
        
        // Configure the cell...

        return cell
    }
    // if the user was selected, move to the conversation with that user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let newUserPair = connectionsWithoutMessage[indexPath.row]
        let newUserUID = newUserPair["UID"]
        newUser = userModel.findUser(uid: newUserUID!)
        performSegue(withIdentifier: "toNewConversation", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toNewConversation"
        {
            let destinationVC = segue.destination as! ConversationViewController
            destinationVC.otherUser = newUser
        }
    }
    func setImageFromURl(stringImageUrl url: String, forImage image: UIImageView)
    {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                image.image = UIImage(data: data as Data)
            }
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
