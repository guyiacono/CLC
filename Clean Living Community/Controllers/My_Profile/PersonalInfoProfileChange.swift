//
//  PersonalInfoProfileChange.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PersonalInfoProfileChange: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate
{
    let currentUserID = Auth.auth().currentUser?.uid
    var userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    let edupicker = UIPickerView()
    let relationpicker = UIPickerView()
    let orientationpicker = UIPickerView()
    let religiouspicker = UIPickerView()
    let spiritualpicker = UIPickerView()
    let smokepicker = UIPickerView()
    let supportpicker = UIPickerView()
    
    var selectedfield: UITextField?
    @IBOutlet weak var eduField: UITextField!
    @IBOutlet weak var relationField: UITextField!
    @IBOutlet weak var orientationField: UITextField!
    @IBOutlet weak var religiousField: UITextField!
    @IBOutlet weak var spiritualField: UITextField!
    @IBOutlet weak var smokeField: UITextField!
    @IBOutlet weak var supportField: UITextField!
    
    
    @IBAction func eduChanged(_ sender: UITextField)
    {
        selectedfield = eduField
    }
    @IBAction func relationChanged(_ sender: UITextField)
    {
        selectedfield = relationField
    }
    @IBAction func orientationChanged(_ sender: UITextField)
    {
        selectedfield = orientationField
    }
    @IBAction func religiousChanged(_ sender: UITextField)
    {
        selectedfield = religiousField
    }
    @IBAction func spiritualChanged(_ sender: UITextField)
    {
        selectedfield = spiritualField
    }
    
    @IBAction func smokeChanged(_ sender: UITextField)
    {
        selectedfield = smokeField
    }
    
    @IBAction func supportChanged(_ sender: UITextField)
    {
        selectedfield = supportField
    }
    
    
    
    
    
    let education = ["High School/GED","Some College/Bachelors Degree","Graduate Degree","PHD"]
    let religious = ["Yes","No"]
    let spiritual = ["Yes", "No"]
    let relationship = ["Single", "In a Relationship"]
    let smoke = ["Yes","No"]
    let orientation = ["Heterosexual","Homosexual","Bisexual","Wish not to disclose"]
    let support = ["Yes","No","Occasionally"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        edupicker.delegate = self
        edupicker.dataSource = self
        relationpicker.delegate = self
        relationpicker.dataSource = self
        religiouspicker.delegate = self
        religiouspicker.dataSource = self
        spiritualpicker.delegate = self
        spiritualpicker.dataSource = self
        smokepicker.delegate = self
        smokepicker.dataSource = self
        orientationpicker.delegate = self
        orientationpicker.dataSource = self
        supportpicker.delegate = self
        supportpicker.dataSource = self
        
        eduField.inputView = edupicker
        relationField.inputView = relationpicker
        religiousField.inputView = religiouspicker
        spiritualField.inputView = spiritualpicker
        smokeField.inputView = smokepicker
        orientationField.inputView = orientationpicker
        supportField.inputView = supportpicker
        
        var userlist = userModel.users
        displayedUser = userModel.findUser(uid: currentUserID!)
        
        userModel.returnUserObject(UID: currentUserID!) { (user) in
            self.displayedUser = user
            self.eduField.text = self.displayedUser.education
            self.relationField.text = self.displayedUser.relationship
            self.religiousField.text = self.displayedUser.religious
            self.spiritualField.text = self.displayedUser.spiritual
            self.smokeField.text = self.displayedUser.smoker
            self.orientationField.text = self.displayedUser.orientation
            self.supportField.text = self.displayedUser.support
        }
        
       
        
        eduField.setBottomBorder(bottom_border: "teal")
        relationField.setBottomBorder(bottom_border: "teal")
        religiousField.setBottomBorder(bottom_border: "teal")
        spiritualField.setBottomBorder(bottom_border: "teal")
        smokeField.setBottomBorder(bottom_border: "teal")
        orientationField.setBottomBorder(bottom_border: "teal")
        supportField.setBottomBorder(bottom_border: "teal")
        
        
        // datepicker.setValue(DesignHelper.getOffWhiteColor(), forKey: "textColor")
        // datepicker.performSelector(inBackground: "setHighlightsToday", with: <#T##Any?#>)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch selectedfield
        {
        case eduField: return education.count
        case relationField: return relationship.count
        case religiousField: return religious.count
        case spiritualField: return spiritual.count
        case smokeField: return smoke.count
        case orientationField: return orientation.count
        case supportField: return support.count
        default: return 1
        }
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        switch selectedfield
        {
        case eduField: return education[row]
        case relationField: return relationship[row]
        case religiousField: return religious[row]
        case spiritualField: return spiritual[row]
        case smokeField: return smoke[row]
        case orientationField: return orientation[row]
        case supportField: return support[row]
        default: return education[row]
        }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch selectedfield
        {
        case eduField: eduField.text = education[row]
        self.view.endEditing(true)
        case relationField: relationField.text = relationship[row]
        self.view.endEditing(true)
        case religiousField: religiousField.text = religious[row]
        self.view.endEditing(true)
        case spiritualField: spiritualField.text = spiritual[row]
        self.view.endEditing(true)
        case smokeField: smokeField.text = smoke[row]
        self.view.endEditing(true)
        case orientationField: orientationField.text = orientation[row]
        self.view.endEditing(true)
        case supportField: supportField.text = support[row]
        self.view.endEditing(true)
        default: eduField.text = education[row]
        self.view.endEditing(true)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        selectedfield = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch selectedfield
        {
        case eduField: eduField.resignFirstResponder()
        case relationField: relationField.resignFirstResponder()
        case religiousField: religiousField.resignFirstResponder()
        case spiritualField: spiritualField.resignFirstResponder()
        case smokeField: smokeField.resignFirstResponder()
        case orientationField: orientationField.resignFirstResponder()
        case supportField: supportField.resignFirstResponder()
        default: eduField.resignFirstResponder()
        }
        
    }
    
    
    @IBOutlet weak var datepicker: UIDatePicker!
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

