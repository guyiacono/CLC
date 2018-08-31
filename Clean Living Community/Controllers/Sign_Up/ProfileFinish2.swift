//
//  ProfileFinish2.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/11/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class ProfileFinish2: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate
{
    
    var email: String?
    var password: String?
    
    var fname: String?
    var lname: String?
    var dob: String?
    var home: String?
    var dor: String?
    var qAnswer: [Int]?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        eduField.setBottomBorder(bottom_border: "teal")
        relationField.setBottomBorder(bottom_border: "teal")
        orientationField.setBottomBorder(bottom_border: "teal")
        religiousField.setBottomBorder(bottom_border: "teal")
        spiritualField.setBottomBorder(bottom_border: "teal")
        smokeField.setBottomBorder(bottom_border: "teal")
        supportField.setBottomBorder(bottom_border: "teal")
        
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
    }

    override func didReceiveMemoryWarning() {
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
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonAction(_ sender: UIButton)
    {
        if(eduField.text != "" && religiousField.text != "" && relationField.text != "" && orientationField.text != "" && spiritualField.text != "" && smokeField.text != "" && supportField.text != "")
        {
            performSegue(withIdentifier: "toProfileFinish3", sender: self)
        }
        else
        {
            createAlert(title: "Profile Information Incomplete", message: "Please complete all the fields")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toProfileFinish3")
        {
            let destinationVC = segue.destination as! ProfileFinish3
            destinationVC.qAnswer = qAnswer
            destinationVC.email = email
            destinationVC.password = password
            destinationVC.fname = fname
            destinationVC.lname = lname
            destinationVC.dob = dob
            destinationVC.home = home
            destinationVC.dor = dor
            
            destinationVC.edu = eduField.text
            destinationVC.rel = relationField.text
            destinationVC.reli = religiousField.text
            destinationVC.ori = orientationField.text
            destinationVC.spt = spiritualField.text
            destinationVC.smk = smokeField.text
            destinationVC.sup = supportField.text
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
        eduField.inputAccessoryView = toolbar
        relationField.inputAccessoryView = toolbar
        religiousField.inputAccessoryView = toolbar
        spiritualField.inputAccessoryView = toolbar
        smokeField.inputAccessoryView = toolbar
        supportField.inputAccessoryView = toolbar
        orientationField.inputAccessoryView = toolbar
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
        if(smokeField.isEditing || supportField.isEditing || spiritualField.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * keyboard.height
        }
        else if(eduField.isEditing || relationField.isEditing || religiousField.isEditing || orientationField.isEditing)
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
