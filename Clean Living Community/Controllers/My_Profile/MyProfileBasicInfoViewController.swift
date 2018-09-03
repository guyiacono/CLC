//
//  MyProfileBasicInfoViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/10/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


protocol firstDelegate
{
    func returnFirst(basicInfo: [String : String])
}

class MyProfileBasicInfoViewController: UIViewController
{
    let currentUserID = Auth.auth().currentUser?.uid
    let userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var hometown: UITextField!
    @IBOutlet weak var recoveryDate: UITextField!
    
    
    
    var firstDelegate: firstDelegate?
    var tempDict = [String:String]()

    
    var birthDatePicker : UIDatePicker?
    var recoveryDatePicker: UIDatePicker?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        firstName.setBottomBorder(bottom_border: "teal")
        lastName.setBottomBorder(bottom_border: "teal")
        dateOfBirth.setBottomBorder(bottom_border: "teal")
        hometown.setBottomBorder(bottom_border: "teal")
        recoveryDate.setBottomBorder(bottom_border: "teal")
        
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        
        userModel.returnUserObject(UID: currentUserID!, completion: { (user) in
            self.displayedUser = user
            self.firstName.text = self.displayedUser.first
            self.lastName.text = self.displayedUser.last
            self.dateOfBirth.text = self.displayedUser.DOB
            self.hometown.text = self.displayedUser.hometown
            self.recoveryDate.text = self.displayedUser.recoveryDate
            if (self.firstDelegate != nil)
            {
                self.tempDict["first"] = self.firstName.text
                self.tempDict["last"] = self.lastName.text
                self.tempDict["DOB"] = self.dateOfBirth.text
                self.tempDict["hometown"] = self.hometown.text
                self.tempDict["DOR"] = self.recoveryDate.text
                self.firstDelegate?.returnFirst(basicInfo: self.tempDict)
            }
        })
        
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
        recoveryDatePicker?.addTarget(self, action: #selector(MyProfileBasicInfoViewController.recDateChanged(recoveryDatePicker:)), for: .valueChanged)
        recoveryDatePicker?.datePickerMode = .date
        recoveryDate.inputView = recoveryDatePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileFinish1.viewTapped(gesture:)))
        
        view.addGestureRecognizer(tapGesture)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func firstDidEnd(_ sender: UITextField)
    {
        self.tempDict["first"] = self.firstName.text
        self.firstDelegate?.returnFirst(basicInfo: self.tempDict)

    }
    @IBAction func lastDidEnd(_ sender: UITextField)
    {
        self.tempDict["last"] = self.lastName.text
        self.firstDelegate?.returnFirst(basicInfo: self.tempDict)

    }
    @IBAction func DOBdidEnd(_ sender: UITextField)
    {
        self.tempDict["DOB"] = self.dateOfBirth.text
        self.firstDelegate?.returnFirst(basicInfo: self.tempDict)

    }
    @IBAction func hometownDidEnd(_ sender: UITextField)
    {
        self.tempDict["hometown"] = self.hometown.text
        self.firstDelegate?.returnFirst(basicInfo: self.tempDict)

    }
    @IBAction func DORdidEnd(_ sender: UITextField)
    {
         self.tempDict["DOR"] = self.recoveryDate.text
        self.firstDelegate?.returnFirst(basicInfo: self.tempDict)

    }
    
    
    @objc func dateChanged(birthDatePicker: UIDatePicker)
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/YYYY"
        dateOfBirth.text = dateformatter.string(from: birthDatePicker.date)
        recoveryDatePicker?.minimumDate = birthDatePicker.date
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
            self.parent?.view.frame.origin.y = -1 * keyboard.height
            //view.frame.origin.y = -1 * keyboard.height
        }
        else if(firstName.isEditing || lastName.isEditing || dateOfBirth.isEditing)
        {
            //view.frame.origin.y = 0
            self.parent?.view.frame.origin.y = 0

        }
        
    }
    @objc func keyboardWillHide(notification: Notification)
    {
        guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            return
        }
        if(self.parent?.view.frame.origin.y != 0)
        {
            self.parent?.view.frame.origin.y += keyboard.height
           // view.frame.origin.y += keyboard.height
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
