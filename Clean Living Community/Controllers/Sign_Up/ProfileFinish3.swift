//
//  ProfileFinish3.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/11/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class ProfileFinish3: UIViewController
{
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
    

    @IBOutlet weak var bioSpace: UITextView!
    
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toProfileFinish4", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toProfileFinish4")
        {
            let destinationVC = segue.destination as! ProfileFinish4
            destinationVC.qAnswer = qAnswer
            destinationVC.email = email
            destinationVC.password = password
            destinationVC.fname = fname
            destinationVC.lname = lname
            destinationVC.dob = dob
            destinationVC.home = home
            destinationVC.dor = dor
            
            destinationVC.edu = edu
            destinationVC.rel = rel
            destinationVC.reli = reli
            destinationVC.ori = ori
            destinationVC.spt = spt
            destinationVC.smk = smk
            destinationVC.sup = sup
            
            destinationVC.bio = bioSpace.text
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
