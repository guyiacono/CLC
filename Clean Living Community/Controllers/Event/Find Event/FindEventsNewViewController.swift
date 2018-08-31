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
        eventTable.dataSource = self
        eventTable.delegate = self
        eventModel.returnAllEvents { (list) in
            if (list.count > 0)
            {
                self.listOfEventsNoCategory = list
                for event in self.listOfEventsNoCategory
                {
                    if(event["Category"] == self.category!)
                    {
                        self.listOfEvents.append(event)
                    }
                }
                self.sortEvents(completion: { (success) in
                    if(success)
                    {
                        self.eventTable.reloadData()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toEventDetail")
        {
            let destinationVC = segue.destination as! EventDetailViewController
            let event = eventsSorted[(sender as? Int)!]
            destinationVC.eventID = event["key"] as? String
            destinationVC.dateTimeString = event["DateTimeString"] as? String
        }
    }
  
    func sortEvents(completion : @escaping (Bool) -> Void)
    {
        let myGroup1 = DispatchGroup()
        let myGroup2 = DispatchGroup()
        var eventsUnder25 = [[String : String]]()
        var eventsOver25 = [[String : String]]()
        for event in listOfEvents
        {
            myGroup1.enter()
            eventModel.getDistanceToEvent(eventUID: event["key"]!, eventDateTimeString: event["DateTimeString"]!, userUID: currentID!) { (distance) in
                
                print(event["key"]! + " : " + String(distance))
                
                if(distance < 25)
                {
                    eventsUnder25.append(event)
                }
                else
                {
                    eventsOver25.append(event)
                }
                myGroup1.leave()
            }
        }
        myGroup1.notify(queue: DispatchQueue.main, execute:
            {
                for event in eventsUnder25
                {
                    self.eventsSorted.append(event)
                }
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
