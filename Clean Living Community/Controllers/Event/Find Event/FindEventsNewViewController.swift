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
    var listOfEventsNoCategory = [[String : String]]()
    var listOfEvents = [[String : String]]()
    
    let currentID = Auth.auth().currentUser?.uid
    var eventsSorted = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapButton.isEnabled = false
        eventTable.dataSource = self
        eventTable.delegate = self
        // get all the events in the database that haven't happened yet
        eventModel.returnAllEvents { (list) in
            if (list.count > 0)
            {
                self.listOfEventsNoCategory = list
                // check to see they have the same category
                for event in self.listOfEventsNoCategory
                {
                    if(event["Category"] == self.category!)
                    {
                        // append them to the list
                        self.listOfEvents.append(event)
                    }
                }
                self.sortEvents(completion: { (success) in
                    if(success)
                    {
                        self.eventTable.reloadData()
                        self.mapButton.isEnabled = true
                    }
                })
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var mapButton: UIButton!
    @IBAction func mapAction(_ sender: UIButton)
    {
        // send to events to the map view
        performSegue(withIdentifier: "toMap", sender: eventsSorted)
    }
    
    
    
    
    
    @IBOutlet weak var eventTable: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return eventsSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // for eeach event, populate cell data with that event
         let cell = eventTable.dequeueReusableCell(withIdentifier: "foundEventCell", for: indexPath) as! FindEventsTableViewCell
        let thisEvent = eventsSorted[indexPath.row]
        
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
    
// send event date to other screens that need it when segues triggered
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toEventDetail")
        {
            let destinationVC = segue.destination as! EventDetailViewController
            let event = eventsSorted[(sender as? Int)!]
            destinationVC.eventID = event["key"] as? String
            destinationVC.dateTimeString = event["DateTimeString"] as? String
        }
        if(segue.identifier == "toMap")
        {
            let destinationVC = segue.destination as! EventMapViewController
            let eventList = eventsSorted
            destinationVC.listOfEvents = eventList
            
        }
    }
    
    // sort the events by date for events under 25 miles away
    // then sort events by distance for over 25 miles
    func sortEvents(completion : @escaping (Bool) -> Void)
    {
        let myGroup1 = DispatchGroup()
        let myGroup2 = DispatchGroup()
        var eventsUnder25 = [[String : String]]()
        var eventsOver25 = [[String : String]]()
        // for each event
        for event in listOfEvents
        {
            myGroup1.enter()
            // get the distance to the event
            eventModel.getDistanceToEvent(eventUID: event["key"]!, eventDateTimeString: event["DateTimeString"]!, userUID: currentID!) { (distance) in
                
                print(event["key"]! + " : " + String(distance))
                
                // if greater than 25
                if(distance < 25)
                {
                    //append to resepctive array
                    eventsUnder25.append(event)
                }
                else
                {
                    // append to respective array
                    eventsOver25.append(event)
                }
                myGroup1.leave()
            }
        }
        myGroup1.notify(queue: DispatchQueue.main, execute:
            {
                // for each event under 25 miles away
                for event in eventsUnder25
                {
                    // put them first
                    self.eventsSorted.append(event)
                }
                // then stick the rest at the end
                for events in eventsOver25
                {
                    self.eventsSorted.append(events)
                }
                completion(true)
        })
        
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
