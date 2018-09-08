//
//  MyProfilePreferencesViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/10/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

// send data about this view to super view controller
protocol preferenceDelegate
{
    func returnPref(prefInfo: [String : String])
}

class MyProfilePreferencesViewController: UIViewController
{
    @IBOutlet weak var pref1: UISegmentedControl!
    @IBOutlet weak var pref2: UISegmentedControl!
    
    let currentUserID = Auth.auth().currentUser?.uid
    var userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    var pref1Value : String?
    var pref2Value : String?
    
    var prefDelegate : preferenceDelegate?
    var tempDict = [String:String]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        // get and display the users's preference
        displayedUser = userModel.findUser(uid: currentUserID!)
        userModel.returnUserObject(UID: currentUserID!) { (user) in
            self.displayedUser = user
            if(self.self.displayedUser.pref1 == "Yes")
            {
                self.pref1.selectedSegmentIndex = 0
                self.pref1Value = "Yes"
            }
            else
            {
                self.self.pref2.selectedSegmentIndex = 1
                self.pref1Value = "No"
            }
            if(self.self.displayedUser.pref2 == "Yes")
            {
                self.pref2.selectedSegmentIndex = 0
                self.pref2Value = "Yes"
            }
            else
            {
                self.pref2.selectedSegmentIndex = 1
                self.pref2Value = "No"
            }
            // send this information to super view controller
            if(self.prefDelegate != nil)
            {
                self.tempDict["pref1"] = self.pref1Value
                self.tempDict["pref2"] = self.pref2Value
                self.prefDelegate?.returnPref(prefInfo: self.tempDict)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pref1LocationChanged(_ sender: UISegmentedControl)
    {
        switch pref1.selectedSegmentIndex{
        case 0:
            tempDict["pref1"] = "Yes"
            // keep super view controller updated with changes
            prefDelegate?.returnPref(prefInfo: tempDict)

        case 1:
            tempDict["pref1"] = "No"
            prefDelegate?.returnPref(prefInfo: tempDict)
        default:
            break
        }
    }
    
    @IBAction func pref2MentorChanged(_ sender: UISegmentedControl)
    {
        // disallow changing of this preference if user does not meet the requirement for mentorship
        // (recovery date was more than 3 years ago)
        var changeable = true
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/YYYY"
        let today = Date()
        let recoveryDate = dateformatter.date(from: displayedUser.recoveryDate)
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        print(Calendar.current.dateComponents(components, from: today, to: recoveryDate!).year!)
        if(Calendar.current.dateComponents(components, from: today, to: recoveryDate!).year! * -1 <= 3)
        {
            changeable = false
            switch pref2.selectedSegmentIndex
            {
            case 0:
                pref2.selectedSegmentIndex = 1
            case 1:
                pref2.selectedSegmentIndex = 1
            default:
                break
            }
        }
        
        
        if(changeable)
        {
            switch pref2.selectedSegmentIndex{
            case 0:
                
                tempDict["pref2"] = "Yes"
                // keep super view controller updated with changes
                prefDelegate?.returnPref(prefInfo: tempDict)
                
            case 1:
                tempDict["pref2"] = "No"
                prefDelegate?.returnPref(prefInfo: tempDict)
            default:
                break
            }
        }
        else
        {
            createAlert(title: "Mentorship", message: "Becoming a mentor is only available to those who have recovered 3 or more years ago")
        }
    }
    
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
