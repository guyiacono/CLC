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
    
    var stringDate = [String : Date]()
    var stringDateSorted = [(key : String , value : Date)]()
    
    var stringDateHost = [String : Date]()
    var stringDateSortedHost = [(key : String , value : Date)]()
    var eventList = [[String : String]]()
    var eventListHost = [[String : String]]()
    
    
    @IBOutlet weak var typeofevent: UISegmentedControl!
    
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
        
        
        userModel.getEventListObserve(userUID: (Auth.auth().currentUser?.uid)!) { (userList) in
            
            let dateformatter = DateFormatter()
            
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
            for (key, value) in userList
            {
                let valueDate = dateformatter.date(from: value)
                if(Calendar.current.dateComponents(components, from: today, to: valueDate!).day!  >= 0)
                {
                    self.stringDate[key] = dateformatter.date(from: value)
                    myGroup.enter()
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
                    self.stringDateSorted = (Array(self.stringDate).sorted {$0.1 < $1.1})
                    self.stringDateSortedHost = (Array(self.stringDateHost).sorted {$0.1 < $1.1})
                    let myGroup2 = DispatchGroup()
                    
                    for set in self.stringDateSorted
                    {
                        dateformatter.dateFormat = "MMddyyyyHHmm"
                        myGroup2.enter()
                        self.eventModel.getEventDict(uid: set.key, dateTime: dateformatter.string(from: set.value), completion: { (eventDict) in
                            self.eventList.append(eventDict)
                            myGroup2.leave()
                        })
                    }
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
