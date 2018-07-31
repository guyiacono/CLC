//
//  MyConnectionsViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/30/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class MyConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let userModel = UserModel.sharedInstance
    let currentUserID = Auth.auth().currentUser?.uid
    var connections : [[String: String]]?
    var connectionsSorted: [[String : String]]?
    var sortedConnectionUIDS: [String] = []
    
    @IBOutlet weak var connectionsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionsTable.delegate = self
        connectionsTable.dataSource = self
        
        userModel.getUnderConnections(withUID: currentUserID,completion: {(list)
            in
            if (list.count >= 0)
            {
                self.connections = list
                self.connectionsSorted = self.connections
                
                /*
                 self.connectionsSorted = (self.connections?.sorted(by: {,<#arg#> $0 as String: String["Name"] as! String < $1 as String: String["Name"] as! String}))!
                 
                 let connectionsSorted = connections.sort { left, right -> Bool in
                 guard let rightKey = right["Name"] as? String else { return true }
                 guard let leftKey = left["Name"] as? String else { return false }
                 return leftKey < rightKey
                 }
                 
                 */
                self.connectionsTable.reloadData()
                
                
            }
        })
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(connections != nil)
        {
            return (connections!.count)
        }
        else
        {
            return(0)
        }
        
        
        /*
         
         if(connectionsSorted != nil)
         {
         return (connectionsSorted?.count)!
         }
         else
         {
         return(0)
         }
         
         */
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = connectionsTable.dequeueReusableCell(withIdentifier: "connectionscell", for: indexPath) as! ConnectionsTableViewCell
        
        // Configure the cell...
        setImageFromURl(stringImageUrl: connectionsSorted![indexPath.row]["MainPhoto"]!, forImage: cell.photo)
        
        cell.datalabel.text = connectionsSorted![indexPath.row]["Name"]
        sortedConnectionUIDS.append((connectionsSorted![indexPath.row]["UID"])!)
        print(sortedConnectionUIDS)
        return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var sentUser : User?
        print(sortedConnectionUIDS)
        for uid in sortedConnectionUIDS
        {
            if(uid == sortedConnectionUIDS[indexPath.row])
            {
                sentUser = userModel.findUser(uid: uid)
            }
        }
        
        performSegue(withIdentifier: "toFriendProfile", sender: sentUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toFriendProfile")
        {
            let destinationVC = segue.destination as! FriendProfileViewController
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

}
