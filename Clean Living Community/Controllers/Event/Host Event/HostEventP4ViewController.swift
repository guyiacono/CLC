//
//  HostEventP4ViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/15/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class HostEventP4ViewController: UIViewController
{
    
    var eventModel = EventModel.sharedInstance
    var userModel = UserModel.sharedInstance
    let signedInID = Auth.auth().currentUser?.uid

    var category: String?
    var name: String?
    var date: String?
    var time: String?
    var subtitle: String?
    
    var eventDescription: String?
    
    var photo1: UIImage?
    var photo2: UIImage?
    var photo3: UIImage?
    
    
    
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var townCityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    
    
    @IBOutlet weak var finishButton: UIButton!
    @IBAction func finishAction(_ sender: UIButton)
    {
        if(addressField.text != "" && townCityField.text != "" && stateField.text != "" && zipField.text != "")
        {

            userModel.findUserProfileInfo(uid: signedInID!, completion: { (person) in
                
                let name = person["First Name"]! + " " + person["Last Name"]!
                sender.isEnabled = false
                self.eventModel.createNewEvent(name: name, date: self.date!, subtitle: self.subtitle!, time: self.time!, address: self.addressField.text!, city: self.townCityField.text!, lat: "", long: "", state: self.stateField.text!, zip: self.zipField.text!, organizer: self.signedInID!, image1: self.photo1!, image2: self.photo2!, image3: self.photo3!, location: self.locationNameField.text!, category: self.category!, organizerName: name) { (success) in
                    if(success)
                    {
                        //self.performSegue(withIdentifier: "toStart", sender: self)
                        //sender.isEnabled = true
                        self.createDismissAlert(title: "Gathering Status", message: "Gathering Created!")
                        
                    }
                    else
                    {
                        self.createAlert(title: "Gathering Status", message: "Gathering Creation Failed")
                        sender.isEnabled = true
                    }
                }
            })
            
            
        }
        else
        {
            self.createAlert(title: "Gathering Status", message: "Please enter the all the required fields!")
            sender.isEnabled = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButton.isEnabled = true
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()

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

    func createDismissAlert (title: String, message: String)
    {
         let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {_ in
            CATransaction.setCompletionBlock({
                self.performSegue(withIdentifier: "toStart", sender: nil)
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
   
    
    
    
    
    // GENERIC ALERT METHOD
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
        locationNameField.inputAccessoryView = toolbar
        addressField.inputAccessoryView = toolbar
        townCityField.inputAccessoryView = toolbar
        stateField.inputAccessoryView = toolbar
        zipField.inputAccessoryView = toolbar
        
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
        if(zipField.isEditing || stateField.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * keyboard.height
        }
        else if (addressField.isEditing || townCityField.isEditing || locationNameField.isEditing)
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
