//
//  StrangerProfileViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/9/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

class StrangerProfileViewController: UIViewController
{
    let signedInID = Auth.auth().currentUser?.uid
    
    
    let usermodel = UserModel.sharedInstance
    var thisUser: User?
    
    var thisPersonsConnections : [[String: String]]?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var mainProfileImage: UIImageView!
    
    @IBOutlet weak var Connect: UIButton!
    @IBOutlet weak var MoreInfo: UIButton!
    
    
    @IBAction func moreInfoButton(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toUserProfile", sender: thisUser)
    }
    @IBAction func friendRequest(_ sender: UIButton)
    {
        var foundRequestAlready = false
        for person in thisPersonsConnections!
        {
            if(person["UID"] == signedInID)
            {
                foundRequestAlready = true
            }
        }
        if(foundRequestAlready)
        {
            createAlert(title: "Connection Request Status", message: "Already sent a request!")
        }
        else
        {
            let me = usermodel.findUser(uid: signedInID!)
            usermodel.sendFriendRequest(withFriendUID: thisUser?.key, withMyUID: signedInID, withMyPhotoURL: me?.url1, withMyName: ((me?.first)! + " " + (me?.last)!), withRequestStatus: "Unaccepted") { (success) in
                if(success)
                {
                    self.usermodel.getUnderConnections(withUID: self.thisUser?.key) { (list) in
                        
                        self.thisPersonsConnections = list
                        self.createAlert(title: "Connection Request Status", message: "Request Sent!")
                    }
                    
                }
                else
                {
                    self.createAlert(title: "Connection Request Status", message: "Failed to Send Request!")

                }
            }
            
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("This user: \(thisUser)")
        name.text = (thisUser?.first)! + " " +  (thisUser?.last)!
        bio.text = thisUser?.bio
        age.text = calculateAge(withDOB: (thisUser?.DOB)!)
        setImageFromURl(stringImageUrl: (thisUser?.url1)!, forImage: mainProfileImage)
        
        mainProfileImage.layer.masksToBounds = true
        mainProfileImage.clipsToBounds = true
        mainProfileImage.layer.cornerRadius = mainProfileImage.frame.height/2
        mainProfileImage.layer.borderColor = UIColor(red:0.13, green:0.89, blue:0.73, alpha:1.0).cgColor
        mainProfileImage.layer.borderWidth = 2.0
        
        Connect.layer.cornerRadius = 15.0
        MoreInfo.layer.cornerRadius = 15.0
        
        usermodel.getUnderConnections(withUID: thisUser?.key) { (list) in
            
            self.thisPersonsConnections = list
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateAge(withDOB DOB: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateRangeStart = formatter.date(from: DOB)
        let dateRangeEnd = Date()
        let components = Calendar.current.dateComponents([.year], from: dateRangeStart!, to: dateRangeEnd)
        return (String(components.year!))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toUserProfile")
        {
            let destinationVC = segue.destination as! StrangerProfileInfoViewController
            destinationVC.viewedUser = sender as? User
            
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
