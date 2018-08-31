//
//  MyProfileBasicInfoViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/10/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyProfileBasicInfoViewController: UIViewController
{
    let currentUserID = Auth.auth().currentUser?.uid
    let userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var hometown: UITextField!
    @IBOutlet weak var recoveryDate: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userModel.returnUserObject(UID: currentUserID!, completion: { (user) in
            self.displayedUser = user
            self.firstName.text = self.displayedUser.first
            self.lastName.text = self.displayedUser.last
            self.dateOfBirth.text = self.displayedUser.DOB
            self.hometown.text = self.displayedUser.hometown
            self.recoveryDate.text = self.displayedUser.recoveryDate
        })
        
        // Do any additional setup after loading the view.
        
        firstName.setBottomBorder(bottom_border: "teal")
        lastName.setBottomBorder(bottom_border: "teal")
        dateOfBirth.setBottomBorder(bottom_border: "teal")
        hometown.setBottomBorder(bottom_border: "teal")
        recoveryDate.setBottomBorder(bottom_border: "teal")
        
        
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
