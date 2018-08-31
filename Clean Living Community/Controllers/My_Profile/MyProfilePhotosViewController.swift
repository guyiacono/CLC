//
//  MyProfilePhotosViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/10/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyProfilePhotosViewController: UIViewController
{
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
 
    let currentUserID = Auth.auth().currentUser?.uid
    var userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayedUser = userModel.findUser(uid: currentUserID!)
        userModel.returnUserObject(UID: currentUserID!) { (user) in
            self.displayedUser = user
            
            self.setImageFromURl(stringImageUrl: self.displayedUser.url1!, forImage: self.photo1)
            self.setImageFromURl(stringImageUrl: self.displayedUser.url2!, forImage: self.photo2)
            self.setImageFromURl(stringImageUrl: self.displayedUser.url3!, forImage: self.photo3)
        }
        

        photo1.setRadiusBorder(content: photo1)
        photo2.setRadiusBorder(content: photo2)
        photo3.setRadiusBorder(content: photo3)

        // Do any additional setup after loading the view.
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
