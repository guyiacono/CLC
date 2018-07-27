//
//  Sign_In.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 5/22/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth

extension UITextField {
    func setBottomBorder(bottom_border : String) {
        var borderColor : CGColor = UIColor.white.cgColor
        
        if bottom_border == "teal" {
            borderColor = UIColor(red:0.13, green:0.89, blue:0.73, alpha:1.0).cgColor
        } else if bottom_border == "blue" {
            borderColor = UIColor(red:0.25, green:0.58, blue:0.95, alpha:1.0).cgColor
        }
        
        self.borderStyle = .none
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = borderColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

class Sign_In: UIViewController
{
    let usermodel = UserModel.sharedInstance
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: UIButton)
    {
        //var success = usermodel.authenticate(withEmail: email.text!, withPassword: password.text!)
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!)
        {user, error in
            if error == nil && user != nil
            {
                self.usermodel.listAllUsers(completion: {(success)
                    in
                    if (success)
                    {
                        //print(self.usermodel.users)
                    }
                })
                self.performSegue(withIdentifier: "loginpass", sender: Sign_In.self)
                print("login success")
            }
            else
            {
                print("login failed")
            }
        }
    }
    
    @IBOutlet weak var signButton: UIButton!
    @IBAction func signUp(_ sender: UIButton)
    {
        if(email.text != nil && (password.text?.count)! >= 6)
        {
            self.performSegue(withIdentifier: "signUpPass", sender: Sign_In.self)
        }
        else
        {
            print("signup failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "signUpPass")
        {
            let destinationVC = segue.destination as! SurveyIntroViewController
            destinationVC.email = email.text
            destinationVC.password = password.text
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
                
        // Do any additional setup after loading the view.
        
        email.setBottomBorder(bottom_border: "teal")
        password.setBottomBorder(bottom_border: "blue")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "signUpPass"
        {
            if let destination = segue.destination as? SurveyIntroViewController
            {
                
            }
        }
    }
    */
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func unwindToSignin(_ sender: UIStoryboardSegue)
    {
        
    }
}
