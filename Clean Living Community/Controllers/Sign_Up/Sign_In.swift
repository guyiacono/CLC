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
    

   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        email.setBottomBorder(bottom_border: "teal")
        password.setBottomBorder(bottom_border: "blue")
        
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //BEGIN KEYBOARD METHODS
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }
    
    func handleDoneButtonOnKeyboard()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([flexibleSpace,doneButton], animated: false)
        email.inputAccessoryView = toolbar
        password.inputAccessoryView = toolbar
    }
    @objc func doneClicked()
    {
        view.endEditing(true)
    }

    func handleViewAdjustmentsFromKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification)
    {
        if(password.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * keyboard.height
        }
        else if(email.isEditing)
        {
            view.frame.origin.y = 0
        }
        
    }
    @objc func keyboardWillHide(notification: Notification)
    {
        guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            return
        }
        if(view.frame.origin.y != 0)
        {
            view.frame.origin.y = 0
        }
    }
}
