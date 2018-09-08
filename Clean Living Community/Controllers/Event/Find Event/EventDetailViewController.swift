//
//  EventDetailViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/16/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EventDetailViewController: UIViewController
{

    var eventModel = EventModel.sharedInstance
    var userModel = UserModel.sharedInstance
    let signedInID = Auth.auth().currentUser?.uid
    var eventID: String?
    var dateTimeString: String?
    var thisEvent = [String : String]()
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var totalAddress: UILabel!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    
    @IBAction func photosAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toPhotos", sender: self)
    }
    // if user attempts to rsvp
    @IBAction func rsvpAction(_ sender: UIButton)
    {
        print("RSVP Button pressed")
        // check if they're already rsvp'd
        userModel.checkIfRSVP(userUID: signedInID!, eventUID: eventID!) { (dateTime) in
            if(dateTime == "")
            {
                print("found datetime = nil")
                // if not, rsvp them
                self.userModel.findUserProfileInfo(uid: self.signedInID!) { (user) in
                    
                    let name = user["First Name"]! + " " + user["Last Name"]!
                    self.eventModel.rsvp(personUID: self.signedInID!, personName: name, eventUID: self.eventID!, dateTime: self.dateTimeString!, completion: { (success) in
                        // create an alert informing about the rsvp status
                        if(success)
                        {
                            self.createAlert(title: "RSVP Status", message: "RSVP Success!")
                        }
                        else
                        {
                            self.createAlert(title: "RSVP Status", message: "RSVP Failed!")
                        }
                    })
                    
                }
            }
            else
            {
                self.createAlert(title: "RSVP Status", message: "RSVP Already Sent!")
            }
            
        }
        
        
        
    }
    @IBAction func goingAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toGoing", sender: self)
    }
    
    // send required data to other screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toPhotos")
        {
            var destinationVC = segue.destination as? FindEventPhotosViewController
            destinationVC?.thisEvent = self.thisEvent
        }
        if(segue.identifier == "toGoing")
        {
            var destinationVC = segue.destination as? PeopleGoingTableViewController
            destinationVC?.thisEvent = self.thisEvent
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // get the event data
        eventModel.getEventDict(uid: eventID!, dateTime: dateTimeString!) { (dict) in
            // populate all the fields
            self.thisEvent = dict
            self.eventName.text = self.thisEvent["Event Name"]!
            self.date.text = "Date: " + self.thisEvent["Date"]!
            self.subtitle.text = self.thisEvent["Subtitle"]!
            let totalAddress1 = self.thisEvent["Address"]! + ","
            let totalAddress2 = " " + self.thisEvent["City_Town"]! + ","
            let totalAddress3 = " " + self.thisEvent["State"]!
            let totalAddress4 = " " + self.thisEvent["Zip"]!
            self.totalAddress.text = "Address : " + totalAddress1 + totalAddress2 + totalAddress3 + totalAddress4
            self.time.text = "time: " + self.thisEvent["Time"]!
            self.location.text = "location: " + self.thisEvent["Location_Title"]!

        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // generic alert method with a custom title, message, and an ok button that dismisses the alert
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
