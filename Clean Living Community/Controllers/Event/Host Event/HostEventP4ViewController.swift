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
import CoreLocation

class HostEventP4ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate
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
    var selectedField: UITextField?
    
    let statePicker = UIPickerView()
    let states = [ "AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS",
                   "KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH",
                   "OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    
    
    
    
    
    
    @IBOutlet weak var finishButton: UIButton!
    @IBAction func finishAction(_ sender: UIButton)
    {
        if(addressField.text != "" && townCityField.text != "" && stateField.text != "" && zipField.text != "")
        {
            var address = "1 Infinite Loop, Cupertino, CA 95014"
            address = addressField.text! + ", " + townCityField.text! + ", " + stateField.text! + " " + zipField.text!
            print(address)
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else
                {
                    self.createAlert(title: "Unable to Find Location", message: "The location inputted was not able to be found by location services. Please ensure you have entered all information correctly")
                        return
                }
                
                // Use your location
                
                self.userModel.findUserProfileInfo(uid: self.signedInID!, completion: { (person) in
                    
                    let name = person["First Name"]! + " " + person["Last Name"]!
                    sender.isEnabled = false
                    self.eventModel.createNewEvent(name: name, date: self.date!, subtitle: self.subtitle!, time: self.time!, address: self.addressField.text!, city: self.townCityField.text!, lat: location.coordinate.latitude, long: location.coordinate.longitude, state: self.stateField.text!, zip: self.zipField.text!, organizer: self.signedInID!, image1: self.photo1!, image2: self.photo2!, image3: self.photo3!, location: self.locationNameField.text!, category: self.category!, organizerName: name) { (success) in
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
        statePicker.delegate = self
        statePicker.dataSource = self
        stateField.inputView = statePicker
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
    
    
    // BEGIN PICKER METHODS
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return states.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return fullState[row]
        
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        stateField.text = states[row]
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        selectedField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch selectedField
        {
        case stateField: stateField.resignFirstResponder()
        case locationNameField: locationNameField.resignFirstResponder()
        case zipField: zipField.resignFirstResponder()
        case addressField: addressField.resignFirstResponder()
        case townCityField: townCityField.resignFirstResponder()
        default: locationNameField.resignFirstResponder()
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
    

    // BEGIN FULL STATE ARRAY
    
    let fullState = [ "AK - Alaska",
                      "AL - Alabama",
                      "AR - Arkansas",
                      "AS - American Samoa",
                      "AZ - Arizona",
                      "CA - California",
                      "CO - Colorado",
                      "CT - Connecticut",
                      "DC - District of Columbia",
                      "DE - Delaware",
                      "FL - Florida",
                      "GA - Georgia",
                      "GU - Guam",
                      "HI - Hawaii",
                      "IA - Iowa",
                      "ID - Idaho",
                      "IL - Illinois",
                      "IN - Indiana",
                      "KS - Kansas",
                      "KY - Kentucky",
                      "LA - Louisiana",
                      "MA - Massachusetts",
                      "MD - Maryland",
                      "ME - Maine",
                      "MI - Michigan",
                      "MN - Minnesota",
                      "MO - Missouri",
                      "MS - Mississippi",
                      "MT - Montana",
                      "NC - North Carolina",
                      "ND - North Dakota",
                      "NE - Nebraska",
                      "NH - New Hampshire",
                      "NJ - New Jersey",
                      "NM - New Mexico",
                      "NV - Nevada",
                      "NY - New York",
                      "OH - Ohio",
                      "OK - Oklahoma",
                      "OR - Oregon",
                      "PA - Pennsylvania",
                      "PR - Puerto Rico",
                      "RI - Rhode Island",
                      "SC - South Carolina",
                      "SD - South Dakota",
                      "TN - Tennessee",
                      "TX - Texas",
                      "UT - Utah",
                      "VA - Virginia",
                      "VI - Virgin Islands",
                      "VT - Vermont",
                      "WA - Washington",
                      "WI - Wisconsin",
                      "WV - West Virginia",
                      "WY - Wyoming"]
    
    
    
}
