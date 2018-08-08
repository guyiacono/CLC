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
    
    var acceptedConnectionsSorted = [[String : String]]()
    var unacceptedConnectionsSorted = [[String : String]]()
    var sortedConnectionUIDS: [String] = []
    
    @IBOutlet weak var connectionsTable: UITableView!
    
    
    @IBOutlet weak var myConnectionsSegmentedControl: UISegmentedControl!
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl)
    {
        connectionsTable.reloadData()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionsTable.delegate = self
        connectionsTable.dataSource = self
        acceptedConnectionsSorted.removeAll()
        unacceptedConnectionsSorted.removeAll()
        connectionsSorted?.removeAll()
        
        userModel.getUnderConnections(withUID: currentUserID,completion: {(list)
            in
            if (list.count >= 0)
            {
                self.connections = list
                self.connectionsSorted = self.connections
                self.acceptedConnectionsSorted.removeAll()
                self.unacceptedConnectionsSorted.removeAll()
                self.unacceptedConnectionsSorted.removeAll()
                self.acceptedConnectionsSorted.removeAll()
                
                for pair in self.connectionsSorted!
                {
                    if(pair["Request"] == "Accepted")
                    {
                        self.acceptedConnectionsSorted.append(pair)
                    }
                    else
                    {
                        self.unacceptedConnectionsSorted.append(pair)
                    }
                }
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
        if(myConnectionsSegmentedControl.selectedSegmentIndex == 0 )
        {
            return (acceptedConnectionsSorted.count)
        }
        else
        {
            return(unacceptedConnectionsSorted.count)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = connectionsTable.dequeueReusableCell(withIdentifier: "connectionscell", for: indexPath) as! ConnectionsTableViewCell
        cell.imageView?.image = nil
        // Configure the cell...
        
        
        if(myConnectionsSegmentedControl.selectedSegmentIndex == 0)
        {
            setImageFromURl(stringImageUrl: acceptedConnectionsSorted[indexPath.row]["MainPhoto"]!, forImage: cell.photo)
            
            cell.datalabel.text = acceptedConnectionsSorted[indexPath.row]["Name"]
            return cell
        }
        else
        {
            setImageFromURl(stringImageUrl: unacceptedConnectionsSorted[indexPath.row]["MainPhoto"]!, forImage: cell.photo)
            
            cell.datalabel.text = unacceptedConnectionsSorted[indexPath.row]["Name"]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var sentUser : User?
       
        if(myConnectionsSegmentedControl.selectedSegmentIndex == 0)
        {
            let otherUserUID = acceptedConnectionsSorted[indexPath.row]["UID"]
            sentUser = userModel.findUser(uid: otherUserUID!)
        }
        else
        {
            let otherUserUID = unacceptedConnectionsSorted[indexPath.row]["UID"]
            sentUser = userModel.findUser(uid: otherUserUID!)
        }
        
        
        performSegue(withIdentifier: "toFriendProfile", sender: sentUser)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toFriendProfile")
        {
            let destinationVC = segue.destination as! FriendProfileViewController
            destinationVC.thisUser = sender as? User
            destinationVC.segmentedStatus = myConnectionsSegmentedControl.selectedSegmentIndex
            
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
