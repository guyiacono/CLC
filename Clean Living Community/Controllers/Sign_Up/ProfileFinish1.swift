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
    
     var birthDatePicker : UIDatePicker?
     var recoveryDatePicker: UIDatePicker?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let todayMinus18 = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        let minFormatter = DateFormatter()
        minFormatter.dateFormat = "MM/dd/YYYY"
        let minDate = minFormatter.date(from: "01/01/1900")
        
        birthDatePicker = UIDatePicker()
        birthDatePicker?.maximumDate = todayMinus18
        birthDatePicker?.minimumDate = minDate
        birthDatePicker?.addTarget(self, action: #selector(ProfileFinish1.dateChanged(birthDatePicker:)), for: .valueChanged)
        birthDatePicker?.datePickerMode = .date
        dateOfBirth.inputView = birthDatePicker
        
        
        recoveryDatePicker = UIDatePicker()
        let today = Date()
        recoveryDatePicker?.maximumDate = today
        recoveryDatePicker?.minimumDate = minDate
        recoveryDatePicker?.addTarget(self, action: #selector(ProfileFinish1.recDateChanged(recoveryDatePicker:)), for: .valueChanged)
        recoveryDatePicker?.datePickerMode = .date
        recoveryDate.inputView = recoveryDatePicker
        
        
        
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileFinish1.viewTapped(gesture:)))
        
        view.addGestureRecognizer(tapGesture)
        
        firstName.setBottomBorder(bottom_border: "teal")
        lastName.setBottomBorder(bottom_border: "teal")
        dateOfBirth.setBottomBorder(bottom_border: "teal")
        hometown.setBottomBorder(bottom_border: "teal")
        recoveryDate.setBottomBorder(bottom_border: "teal")
        
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        // Do any additional setup after loading the view.
    }
    
    @objc func dateChanged(birthDatePicker: UIDatePicker)
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/YYYY"
        dateOfBirth.text = dateformatter.string(from: birthDatePicker.date)
        view.endEditing(true)
    }
    @objc func recDateChanged(recoveryDatePicker: UIDatePicker)
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/YYYY"
        recoveryDate.text = dateformatter.string(from: recoveryDatePicker.date)
        view.endEditing(true)
    }
    @objc func viewTapped(gesture: UITapGestureRecognizer)
    {
        view.endEditing(true)
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
        else
        {
            createAlert(title: "Profile Information Incomplete", message: "Please complete all the fields")

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
        firstName.inputAccessoryView = toolbar
        lastName.inputAccessoryView = toolbar
        dateOfBirth.inputAccessoryView = toolbar
        hometown.inputAccessoryView = toolbar
        recoveryDate.inputAccessoryView = toolbar
        
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
        if(hometown.isEditing || recoveryDate.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * keyboard.height
        }
        else if(firstName.isEditing || lastName.isEditing || dateOfBirth.isEditing)
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
