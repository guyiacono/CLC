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
    }
    
    @IBOutlet weak var messageButton: UIButton!
    @IBAction func messageAction(_ sender: UIButton)
    {
        
    }
    
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBAction func moreInfoAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toFriendProfileDetail", sender: thisUser)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        name.text = (thisUser?.first)! + " " +  (thisUser?.last)!
        bio.text = thisUser?.bio
        age.text = "Age: " + calculateAge(withDOB: (thisUser?.DOB)!)
        setImageFromURl(stringImageUrl: (thisUser?.url1)!, forImage: profileImage)
        if(segmentedStatus == 1)
        {
            disconnect.setTitle("Connect", for: UIControlState.normal)
        }
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
        formatter.dateFormat = "DD/MM/YYYY"
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
