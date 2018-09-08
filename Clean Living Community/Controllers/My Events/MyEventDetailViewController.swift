//
//  MyEventDetailViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/31/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class MyEventDetailViewController: UIViewController
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
    
    @IBOutlet weak var rsvpButton: UIButton!
    
    // segue to screen to show large photos
    @IBAction func photosAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toPhotos", sender: self)
    }
    // rsvp's user to the event, creates an alert informing the user of the result
    @IBAction func rsvpAction(_ sender: UIButton)
    {
        userModel.unRSVPFromEvent(userUID: signedInID!, eventUID: eventID!, eventDateTime: dateTimeString!, completion: {(success) in
            if(success)
            {
                self.createAlert(title: "RSVP Status", message: "Un-RSVP Successful!")
            }
            else
            {
                self.createAlert(title: "RSVP Status", message: "Un-RSVP Failed!")
            }
            
        })
        
    }
    // segues the user to a list of other users going to the event in a tableview
    @IBAction func goingAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toGoing", sender: self)
    }
    
    // set the necessary data in classes that can be segued to
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
        // find the event data
        eventModel.getEventDict(uid: eventID!, dateTime: dateTimeString!) { (dict) in
            
            // populate the fields with the event data
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
            
            if(self.thisEvent["Organizer"]! == self.signedInID)
            {
                self.rsvpButton.isHidden = true
                self.rsvpButton.isEnabled = false
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // generic method for creating an alert with a custom title, custom message, and ok button
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
