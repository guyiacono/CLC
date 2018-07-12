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

class MyProfilePreferencesViewController: UIViewController
{
    @IBOutlet weak var pref1: UISegmentedControl!
    @IBOutlet weak var pref2: UISegmentedControl!
    
    let currentUserID = Auth.auth().currentUser?.uid
    var userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayedUser = userModel.findUser(uid: currentUserID!)
        if(displayedUser.pref1 == "Yes")
        {
            pref1.selectedSegmentIndex = 0
        }
        else
        {
            pref2.selectedSegmentIndex = 1
        }
        if(displayedUser.pref2 == "Yes")
        {
            pref2.selectedSegmentIndex = 0
        }
        else
        {
            pref2.selectedSegmentIndex = 1
        }
        // Do any additional setup after loading the view.
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
