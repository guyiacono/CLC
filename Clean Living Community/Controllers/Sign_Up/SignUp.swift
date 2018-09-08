//
//  SignUp.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/6/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class SignUp: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emailField.setBottomBorder(bottom_border: "teal")
        passwordField.setBottomBorder(bottom_border: "blue")
        
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var invalidPasswordLabel: UILabel!
    
    @IBOutlet weak var invalidEmailLabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUp(_ sender: UIButton)
    {
        // make sure there is valid input for each field
        if(emailField.text != "" && (passwordField.text?.count)! >= 6)
        {
            print(emailField.text)
            print(passwordField.text)
            // send the information through to the next screen
            self.performSegue(withIdentifier: "signUpSucceed", sender: Sign_In.self)
        }
            // if invalid input, show a message saying so
        else
        {
            print("signup failed")
            if(emailField.text == "")
            {
                invalidEmailLabel.isHidden = false
            }
            if((invalidPasswordLabel.text?.count)! >= 6)
            {
                invalidPasswordLabel.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "signUpSucceed")
        {
            let destinationVC = segue.destination as! SurveyIntroViewController
            destinationVC.email = emailField.text
            destinationVC.password = passwordField.text
        }
    }
    
    
    
    // BEGIN KEYBOARD METHODS
    
    
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
        emailField.inputAccessoryView = toolbar
        passwordField.inputAccessoryView = toolbar
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
        if(passwordField.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * keyboard.height
        }
        else if(emailField.isEditing)
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
            view.frame.origin.y += keyboard.height
        }
    }

}
