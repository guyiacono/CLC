//
//  FriendProfileViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/24/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseAuth

class FriendProfileViewController: UIViewController {

    
    var userModel = UserModel.sharedInstance
    var thisUser: User?
    var segmentedStatus: Int?
    let signedInID = Auth.auth().currentUser?.uid
    var messageModel = MessageModel.sharedInstance

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var bio: UITextView!
    
    
    @IBOutlet weak var disconnect: UIButton!
    @IBAction func disconnectAction(_ sender: UIButton)
    {
        if(segmentedStatus == 1)
        {
            let me = userModel.findUser(uid: signedInID!)
            userModel.sendFriendRequest(withFriendUID: thisUser?.key, withMyUID: signedInID, withMyPhotoURL: me!.url1, withMyName: (me?.first)! + " " + (me?.last)!, withRequestStatus: "Accepted") { (success) in
                if(success)
                {
                    self.userModel.sendFriendRequest(withFriendUID: self.signedInID, withMyUID: self.thisUser?.key, withMyPhotoURL: self.thisUser?.url1, withMyName: (self.thisUser?.first)! + " " + (self.thisUser?.last)!, withRequestStatus: "Accepted", completion: { (success2) in
                        if(success2)
                        {
                            self.createAlert(title: "Connection Request Status", message: "Connection Request Accepted!")
                        }
                    })
                }
            }
        }
        else
        {
            userModel.disconnectFromUser(myUID: signedInID!, theirUID: (thisUser?.key)!) { (success) in
                if(success)
                {
                    self.createAlert(title: "Connection Request Status", message: "Successfully Disconnected!")
                }
                else
                {
                    self.createAlert(title: "Connection Request Status", message: "Failed to Disconnect!")
                }
            }
        }
    }
    
    @IBOutlet weak var messageButton: UIButton!
    @IBAction func messageAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toMessageFromProfile", sender: thisUser)
    }
    
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBAction func moreInfoAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toFriendProfileDetail", sender: thisUser)
    }
    
    @IBAction func eventsButton(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toHistory", sender: thisUser?.key)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        name.text = (thisUser?.first)! + " " +  (thisUser?.last)!
        bio.text = thisUser?.bio
        print((thisUser?.DOB)!)
        age.text = "Age: " + calculateAge(withDOB: (thisUser?.DOB)!)
        setImageFromURl(stringImageUrl: (thisUser?.url1)!, forImage: profileImage)
        if(segmentedStatus == 1)
        {
            disconnect.setTitle("Connect", for: UIControlState.normal)
        }
        else
        {
            disconnect.setTitle("Disconnect", for: UIControlState.normal)
        }
        
        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderColor = UIColor(red:0.13, green:0.89, blue:0.73, alpha:1.0).cgColor
        profileImage.layer.borderWidth = 2.0
        
        disconnect.layer.cornerRadius = 15.0
        messageButton.layer.cornerRadius = 15.0
        moreInfoButton.layer.cornerRadius = 15.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toFriendProfileDetail")
        {
            let destinationVC = segue.destination as! StrangerProfileInfoViewController
            destinationVC.viewedUser = sender as? User
        }
        if(segue.identifier == "toMessageFromProfile")
        {
            var destinationVC = segue.destination as! ConversationViewController
            destinationVC.otherUser = thisUser
            
            userModel.listAllMessages(withUID: signedInID, completion: {(list)
                in
                if(list[(self.thisUser?.key)!] != nil)
                {
                  
                    destinationVC.thisMessageUID = list[(self.thisUser?.key)!]
                }
                else
                {
                    destinationVC.thisMessageUID = nil

                }
            })
        }
        if(segue.identifier == "toHistory")
        {
            var destinationVC = segue.destination as! EventHistoryTableViewController
            destinationVC.thisUID = sender as? String
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
    func calculateAge(withDOB DOB: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        print(formatter.date(from: DOB))
        let dateRangeStart = formatter.date(from: DOB)
        
        let dateRangeEnd = Date()
        let components = Calendar.current.dateComponents([.year], from: dateRangeStart!, to: dateRangeEnd)
        return (String(components.year!))
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
