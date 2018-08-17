//
//  FindEventsNewViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/19/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class FindEventsNewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var category: String?
    var eventModel = EventModel.sharedInstance
    var listOfEvents = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTable.dataSource = self
        eventTable.delegate = self
        eventModel.returnAllEvents { (list) in
            if (list.count > 0)
            {
                self.listOfEvents = list
                self.eventTable.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var eventTable: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listOfEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell = eventTable.dequeueReusableCell(withIdentifier: "foundEventCell", for: indexPath) as! FindEventsTableViewCell
        let thisEvent = listOfEvents[indexPath.row]
        
        cell.name.text = thisEvent["Event Name"]
        cell.date.text = thisEvent["Date"]
        cell.organization.text = thisEvent["Subtitle"]
        cell.time.text = thisEvent["Time"]
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let eventNum = indexPath.row
        performSegue(withIdentifier: "toEventDetail", sender: eventNum)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toEventDetail")
        {
            let destinationVC = segue.destination as! EventDetailViewController
            let event = listOfEvents[(sender as? Int)!]
            destinationVC.eventID = event["key"] as? String
            destinationVC.dateTimeString = event["DateTimeString"] as? String
        }
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
