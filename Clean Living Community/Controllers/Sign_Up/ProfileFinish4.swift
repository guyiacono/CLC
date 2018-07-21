//
//  ProfileFinish4.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/17/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class ProfileFinish4: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate
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
    
    @IBOutlet weak var profileImage1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        profileImage1.layer.masksToBounds = true
        profileImage1.clipsToBounds = true
        profileImage1.layer.cornerRadius = profileImage1.frame.height/2
        // Do any additional setup after loading the view.
    }

    @IBAction func changePhoto(_ sender: UIGestureRecognizer)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toProfileFinish5")
        {
            let destinationVC = segue.destination as! ProfileFinish5
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
            
            destinationVC.bio = bio
        }
    }
    @IBOutlet weak var finish: UIButton!
    @IBAction func finishSurvey(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toProfileFinish5", sender: self)
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
