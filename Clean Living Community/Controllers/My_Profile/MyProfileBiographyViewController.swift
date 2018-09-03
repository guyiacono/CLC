//
//  MyProfileBiographyViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/10/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol bioDelegate
{
    func returnBio(bio : String)
}

class MyProfileBiographyViewController: UIViewController, UITextViewDelegate
{
    let currentUserID = Auth.auth().currentUser?.uid
    var userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    var bioDelegate : bioDelegate?
    
    @IBOutlet weak var bio: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        bio.delegate = self
        handleViewAdjustmentsFromKeyboard()
        handleDoneButtonOnKeyboard()
        
        userModel.returnUserObject(UID: currentUserID!) { (user) in
            self.displayedUser = user
            self.bio.text = self.displayedUser.bio
            if(self.bioDelegate != nil)
            {
                self.bioDelegate?.returnBio(bio: self.bio.text)
            }
        }
        
        bio.layer.cornerRadius = 12.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        self.bioDelegate?.returnBio(bio: self.bio.text)
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
        bio.inputAccessoryView = toolbar
        
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
        if(bio.isFirstResponder)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            self.parent?.view.frame.origin.y = (-1 * 120)
        }
            /*
        else if(bio. == false)
        {
            print("bio not first responder")
            self.parent?.view.frame.origin.y = 0
        }
 */
        
    }
    @objc func keyboardWillHide(notification: Notification)
    {
        guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            return
        }
        if(self.parent?.view.frame.origin.y != 0)
        {
            self.parent?.view.frame.origin.y = 0
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
