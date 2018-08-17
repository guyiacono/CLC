//
//  PeopleGoingTableViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/16/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

class PeopleGoingTableViewController: UITableViewController {

    var thisEvent = [String : String]()
    var attendees = [(key : String , value : String)]()
    var userModel = UserModel.sharedInstance
    var eventModel = EventModel.sharedInstance
    
    var attendeesUsersSorted = [[String : String]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        eventModel.ObserveAttending(eventUID: thisEvent["key"]!, dateTimeString: thisEvent["DateTimeString"]!) { (listOfAttendees) in
            let attendeesUnsorted = listOfAttendees
            let attendeesSorted = (Array(attendeesUnsorted).sorted {$0.1 < $1.1})
            self.attendees = attendeesSorted
            for person in self.attendees
            {
                self.userModel.findUserProfileInfo(uid: person.key, completion: { (user) in
                    self.attendeesUsersSorted.append(user)
                    if(self.attendeesUsersSorted.count == self.attendees.count)
                    {
                        self.tableView.reloadData()
                    }
                    
                })
            }
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return attendees.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goingCell", for: indexPath) as! PeopleGoingTableViewCell
        
        print(attendeesUsersSorted)
        
        let user = attendeesUsersSorted[indexPath.row]
        
        cell.name.text = user["First Name"]! + " " + user["Last Name"]!
        setImageFromURl(stringImageUrl: user["Photo1"]!, forImage: cell.photo)
        if(user["key"] == thisEvent["Organizer"])
        {
            cell.host.text = "Event Host"
        }
        else
        {
            cell.host.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = attendeesUsersSorted[indexPath.row]
        if(user["key"] != Auth.auth().currentUser?.uid)
        {
            let userObject = userModel.findUser(uid: user["key"]!)
            performSegue(withIdentifier: "toProfile", sender: userObject)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toProfile")
        {
            let destinationVC = segue.destination as? StrangerProfileViewController
            destinationVC?.thisUser = sender as? User
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
