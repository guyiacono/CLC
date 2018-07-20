//
//  ProfileFinish1.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/11/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class ProfileFinish1: UIViewController {

    var qArray: [Int]?
    var email: String?
    var password: String?
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var hometown: UITextField!
    @IBOutlet weak var recoveryDate: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
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
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func pushNextButton(_ sender: UIButton)
    {
        if(firstName.text != "" && lastName.text != "" && dateOfBirth.text != "" && hometown.text != "" && recoveryDate.text != "")
        {
            performSegue(withIdentifier: "toProfileFinish2", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "toProfileFinish2")
        {
            let destinationVC = segue.destination as! ProfileFinish2
            destinationVC.email = email
            destinationVC.password = password
            destinationVC.qAnswer = qArray
            destinationVC.fname = firstName.text
            destinationVC.lname = lastName.text
            destinationVC.dob = dateOfBirth.text
            destinationVC.home = hometown.text
            destinationVC.dor = recoveryDate.text
        }
    }
    
    
}
