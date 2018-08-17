//
//  ConnectionsTableViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/5/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConnectionsTableViewController: UITableViewController{
    
    let usermodel = UserModel.sharedInstance
    let currentUserID = Auth.auth().currentUser?.uid
    var list: [User] = []
    var selectedIndex = 0
    var currentConnections: [[String : String]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "findCon2")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        list = usermodel.users
        usermodel.getUnderConnectionsSnapshot(withUID: currentUserID, completion: {(connectionList)
            in
            if (connectionList.count > 0)
            {
                print("connection list greater than zero")
                self.currentConnections = connectionList
                for person in self.currentConnections!
                {
                    for (index,user) in self.list.enumerated()
                    {
                        if(user.key == person["UID"]!)
                        {
                            self.list.remove(at: index)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            
            
        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        for (index,person) in list.enumerated()
        {
            if(person.key == currentUserID)
            {
                list.remove(at: index)
            }
        }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        for (index,person) in list.enumerated()
        {
            if(person.key == currentUserID)
            {
                list.remove(at: index)
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionscell", for: indexPath) as! ConnectionsTableViewCell
        
        // Configure the cell...
        cell.backgroundColor = .clear
        
        let person = list[indexPath.row]
        cell.datalabel.font = cell.datalabel.font.withSize(14)
        
        let userInfo = "\(person.first) \(person.last) / \(indexPath.row) MI Away"
        cell.datalabel.text = userInfo.uppercased()
        
        
        setImageFromURl(stringImageUrl: (person.url1)!, forImage: cell.photo)
        cell.photo.layer.masksToBounds = true
        cell.photo.clipsToBounds = true
        cell.photo.layer.cornerRadius = cell.photo.frame.height/2
        cell.photo.layer.borderColor = UIColor(red:0.13, green:0.89, blue:0.73, alpha:1.0).cgColor
        cell.photo.layer.borderWidth = 2.0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        for (index,person) in list.enumerated()
        {
            if(person.key == currentUserID)
            {
                list.remove(at: index)
            }
        }
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "profileInfoSegue", sender: list[selectedIndex])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "profileInfoSegue")
        {
            let destinationVC = segue.destination as! StrangerProfileViewController
            destinationVC.thisUser = sender as? User
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

