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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = usermodel.users
        
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
        
        let person = list[indexPath.row]
        cell.photo.image = UIImage(named: "No Photo.png")
        cell.datalabel.font = cell.datalabel.font.withSize(14)
        cell.datalabel.text = "\(person.first) \(person.last) / \(indexPath.row)% Compatible / \(indexPath.row) MI Away"
        
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

