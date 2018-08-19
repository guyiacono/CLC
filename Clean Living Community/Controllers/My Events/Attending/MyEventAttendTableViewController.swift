//
//  MyEventAttendTableViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/17/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//
import FirebaseAuth
import UIKit


class MyEventAttendTableViewController: UITableViewController
{

    var userModel = UserModel.sharedInstance
    var eventModel = EventModel.sharedInstance
    
    var stringDate = [String : Date]()
    var stringDateSorted = [(key : String , value : Date)]()
    var eventList = [[String : String]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userModel.getEventListObserve(userUID: (Auth.auth().currentUser?.uid)!) { (userList) in
            
            let dateformatter = DateFormatter()
           
            self.stringDate.removeAll()
            
            dateformatter.dateFormat = "MM/dd/yyyy"
            let today = Date()
            dateformatter.dateFormat = "MMddyyyyHHmm"
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
            
            
            for (key, value) in userList
            {
                let valueDate = dateformatter.date(from: value)
                if(Calendar.current.dateComponents(components, from: today, to: valueDate!).day!  >= 0)
                {
                    self.stringDate[key] = dateformatter.date(from: value)
                }
                
            }
            self.stringDateSorted = (Array(self.stringDate).sorted {$0.1 < $1.1})
            for set in self.stringDateSorted
            {
                dateformatter.dateFormat = "MMddyyyyHHmm"
                self.eventModel.getEventDict(uid: set.key, dateTime: dateformatter.string(from: set.value), completion: { (eventDict) in
                    self.eventList.append(eventDict)
                    self.tableView.reloadData()
                })
            }
        }

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
        return eventList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! EventHistoryTableViewCell

        let event = eventList[indexPath.row]
        print("hi")
       
        cell.name.text = event["Event Name"] as! String
        cell.date.text = event["Date"] as! String
        cell.subtitle.text = event["Subtitle"] as! String
        cell.time.text = event["Time"] as! String
        /*
        for (key , value) in event
        {
            if (key == "Event Name")
            {
                cell.name.text = value
            }
            else if (key == "Date")
            {
                cell.date.text = value
            }
            else if (key == "Subtitle")
            {
                cell.subtitle.text = value
            }
            else if (key == "Time")
            {
                cell.time.text = value
            }
                /*
            else if (key == "Photo1")
            {
                setImageFromURl(stringImageUrl: key, forImage: cell.eventImage )
            }
 */
        }
 
 */
        print(cell.name.text)
        print(cell.date.text)

        
        // Configure the cell...
        print("hi")
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
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
