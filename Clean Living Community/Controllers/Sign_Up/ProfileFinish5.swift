//
//  ProfileFinish5.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/17/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileFinish5: UIViewController
{
    var usermodel = UserModel.sharedInstance
    
    var email: String?
    var password: String?
    
    var fname: String?
    var lname: String?
    var dob: String?
    var home: String?
    var dor: String?
    var qAnswer: [Int]?
    
    var edu: String?
    var rel: String?
    var ori: String?
    var reli: String?
    var spt: String?
    var smk: String?
    var sup: String?
    
    var bio: String?
    
    var pref1: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var pref1Option: UISegmentedControl!
    
    @IBOutlet weak var createButton: UIButton!
    @IBAction func createProfile(_ sender: UIButton)
    {
        createButton.isEnabled = false
        if(pref1Option.selectedSegmentIndex == 0)
        {
            pref1 = "Yes"
        }
        else
        {
            pref1 = "No"
        }
        
        usermodel.registerUser(withEmail: email!, withPassword: password!, withFirst: fname!, withLast: lname!, withDOB: dob!, withTown: home!, withEdu: edu!, withOrientation: ori!, withRecovery: dor!, withRomance: rel!, withReligion: reli!, withSpiritual: spt!, isSmoke: smk!, attendSupport: sup!, withOpt1: pref1!, withOpt2: "Yes", withBio: bio!, withQuestionair: qAnswer!, completion: {(success)
            in
            if (success)
            {
                self.performSegue(withIdentifier: "toSignIn", sender: ProfileFinish5.self)
            }
            else
            {
                self.createButton.isEnabled = true
            }
        })
        /*
        self.performSegue(withIdentifier: "loginpass", sender: Sign_In.self)
        print("login success")
    })
        
        Auth.auth().signIn(withEmail: "beth@email.com", password: "123456")
        {user, error in
            if error == nil && user != nil
            {
                self.performSegue(withIdentifier: "toHome", sender: ProfileFinish5.self)
            }
            else
            {
                print("authentication failed")
            }
        }
        */
        
        
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
