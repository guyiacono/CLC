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
import CoreLocation

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
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.bounds.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

class Sign_In: UIViewController, CLLocationManagerDelegate
{
    let usermodel = UserModel.sharedInstance
    
    let manager = CLLocationManager()
    
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
                self.attemptToUpdateLocation()
                self.performSegue(withIdentifier: "loginpass", sender: Sign_In.self)
                print("login success")
            }
            else
            {
                self.createAlert(title: "Login Failed", message: "Invalid Email Address or Password")
            }
        }
    }
    

   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        manager.delegate = self
        
        // Do any additional setup after loading the view.

        email.setBottomBorder(bottom_border: "teal")
        password.setBottomBorder(bottom_border: "blue")
        
        /*
        usermodel.writeQuestionair(UID: "Y0jUv3EvPMVK5kPIZZN06EdZr8R2", val: 0)
        usermodel.writeQuestionair(UID: "SyZ3lSFp9dh4w1KNHuM8Td4iEup1",val: 1)
        usermodel.writeQuestionair(UID: "KytbcDtvuobNNHyg52o5DBPpsxt1",val: 2)
        usermodel.writeQuestionair(UID: "Dl9VO62eIwbaeJT1ENdk1WoiWVq1",val: 3)
        usermodel.writeQuestionair(UID: "QhDnh9qWygN5Nyghdfaz2cDjFIG3",val: 4)
        usermodel.writeQuestionair(UID: "f6iD5G0bPESuKhlTocShD24Xnay2",val: 2)
        usermodel.writeQuestionair(UID: "r6PWN4yItAfxAnTUU21u2h4hZUl2", val: 0)
        */
        
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attemptToUpdateLocation()
    {
        if(CLLocationManager.locationServicesEnabled())
        {
            self.manager.requestLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            let uid = Auth.auth().currentUser?.uid as? String
            print("Found user's location: \(location)")
            usermodel.updateLocation(uid: uid!, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update user location: \(error.localizedDescription)")
    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func resetPasswordTapped(_ sender: UIButton)
    {
        var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Password Recovery", message: "Please enter your email address", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            if (loginTextField?.text != "")
            {
                
                Auth.auth().sendPasswordReset(withEmail: (loginTextField?.text!)!, completion: { (error) in
                    if (error == nil)
                    {
                        
                        self.showErrorAlert(title: "Password reset", msg: "Check your inbox to reset your password")
                        
                    }
                    else
                    {
                        print(error)
                        self.showErrorAlert(title: "Unidentified email address", msg: "Please re-enter the email you registered with")
                    }
                })
            }
            print("textfield is empty")
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            loginTextField = textField
            loginTextField?.placeholder = "Enter your login ID"
        }
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)}
    
    
    
    
    
    
    
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
