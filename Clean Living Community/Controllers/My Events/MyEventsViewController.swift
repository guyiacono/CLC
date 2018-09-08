//
//  MyEventsViewController.swift
//  Pods-Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//

import UIKit
import FirebaseAuth

class MyEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var userModel = UserModel.sharedInstance
    var eventModel = EventModel.sharedInstance
    
    // events in the form [EventUID : DateTime]
    var stringDate = [String : Date]()
    // events forted by datetime
    var stringDateSorted = [(key : String , value : Date)]()
    
    // events the user is hosting
    var stringDateHost = [String : Date]()
    //events the user is hosting sorted by date
    var stringDateSortedHost = [(key : String , value : Date)]()
    // events the user is attending
    var eventList = [[String : String]]()
    var eventListHost = [[String : String]]()
    
    
    @IBOutlet weak var typeofevent: UISegmentedControl!
    
    // repopulate the tabel based on which index is selected
    @IBAction func typechanged(_ sender: UISegmentedControl)
    {
        switch typeofevent.selectedSegmentIndex{
        case 0:
            tableView.reloadData()
        case 1:
            tableView.reloadData()
            
        default:
            break
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        // events will update in real time
        // get all the events this user is attending
        userModel.getEventListObserve(userUID: (Auth.auth().currentUser?.uid)!) { (userList) in
            
            let dateformatter = DateFormatter()
            
            // clear the arrays to eliminate repeats
            self.stringDate.removeAll()
            self.stringDateSorted.removeAll()
            self.stringDateHost.removeAll()
            self.stringDateSortedHost.removeAll()
            self.eventList.removeAll()
            self.eventListHost.removeAll()
            
            dateformatter.dateFormat = "MM/dd/yyyy"
            let today = Date()
            dateformatter.dateFormat = "MMddyyyyHHmm"
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
            
            let myGroup = DispatchGroup()
            // userlist is the events in this user's event section
            for (key, value) in userList
            {
                let valueDate = dateformatter.date(from: value)
                // if the date of the event is today or later
                if(Calendar.current.dateComponents(components, from: today, to: valueDate!).day!  >= 0)
                {
                    // set the change the event string to a date object and put it in a new array
                    self.stringDate[key] = dateformatter.date(from: value)
                    myGroup.enter()
                    // if the user is hosting the event put it in another array too
                    self.eventModel.checkIfUserIsHosting(userUID: (Auth.auth().currentUser?.uid)!, eventID: key, eventDateTimeID: value, completion: { (isHosting) in
                        if(isHosting == true)
                        {
                            self.stringDateHost[key] = dateformatter.date(from: value)
                        }
                        myGroup.leave()
                    })
                }
            }
            myGroup.notify(queue: DispatchQueue.main, execute:
                {
                    // sorst the arrays of events by date
                    self.stringDateSorted = (Array(self.stringDate).sorted {$0.1 < $1.1})
                    self.stringDateSortedHost = (Array(self.stringDateHost).sorted {$0.1 < $1.1})
                    let myGroup2 = DispatchGroup()
                    
                    // for each event the user is attending
                    for set in self.stringDateSorted
                    {
                        dateformatter.dateFormat = "MMddyyyyHHmm"
                        myGroup2.enter()
                        // get the data for the event
                        self.eventModel.getEventDict(uid: set.key, dateTime: dateformatter.string(from: set.value), completion: { (eventDict) in
                            // append the data as a dictionary to a new array
                            self.eventList.append(eventDict)
                            myGroup2.leave()
                        })
                    }
                    // do the same thing for events the user is hosting
                    myGroup2.notify(queue: DispatchQueue.main, execute:
                    {
                        let myGroup3 = DispatchGroup()
                        for set in self.stringDateSortedHost
                        {
                            dateformatter.dateFormat = "MMddyyyyHHmm"
                            myGroup3.enter()
                            self.eventModel.getEventDict(uid: set.key, dateTime: dateformatter.string(from: set.value), completion: { (eventDict) in
                                self.eventListHost.append(eventDict)
                                myGroup3.leave()
                            })
                        }
                        // reload the tables after the data is gotten and sorted
                        myGroup3.notify(queue: DispatchQueue.main, execute:
                            {
                              
                                print("reloading data")
                                self.tableView.reloadData()
                                
                            })
                    })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // number of rows depends upon number of events for the index option
        if(typeofevent.selectedSegmentIndex == 0)
        {
            return eventList.count
        }
        else
        {
            return eventListHost.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! EventHistoryTableViewCell
        
        cell.eventImage.image = nil
        // set the event data based on the selected index from the respective array
        if(typeofevent.selectedSegmentIndex == 0)
        {
            let event = eventList[indexPath.row]
            
            cell.name.text = event["Event Name"] as! String
            cell.date.text = event["Date"] as! String
            cell.subtitle.text = event["Subtitle"] as! String
            cell.time.text = event["Time"] as! String
            setImageFromURl(stringImageUrl: event["Photo1"]!, forImage: cell.eventImage)

        }
        else
        {
            let event = eventListHost[indexPath.row]
            
            cell.name.text = event["Event Name"] as! String
            cell.date.text = event["Date"] as! String
            cell.subtitle.text = event["Subtitle"] as! String
            cell.time.text = event["Time"] as! String
            setImageFromURl(stringImageUrl: event["Photo1"]!, forImage: cell.eventImage)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var sentEvent = [String : String]()
        // if an event is selected, segue to the next screen and send the event data
        if(typeofevent.selectedSegmentIndex == 0)
        {
            sentEvent = eventList[indexPath.row]
            performSegue(withIdentifier: "toMyEventDetail", sender: sentEvent)
        }
        else
        {
            sentEvent = eventListHost[indexPath.row]
            performSegue(withIdentifier: "toMyEventDetail", sender: sentEvent)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // send neccessary data for the next view showing the event's details
        if segue.identifier == "toMyEventDetail"
        {
            let destinationVC = segue.destination as! MyEventDetailViewController
            let sentEvent = sender as! [String : String]
            destinationVC.thisEvent = sentEvent
            destinationVC.dateTimeString = sentEvent["DateTimeString"]
            destinationVC.eventID = sentEvent["key"]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function to populate a UIImage view with a photo at a given url
    // used to set event pictures, whos urls are stored in the event's info
    func setImageFromURl(stringImageUrl url: String, forImage image: UIImageView)
    {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                image.image = UIImage(data: data as Data)
            }
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
