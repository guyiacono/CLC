//
//  HostEventP1ViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/15/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class HostEventP1ViewController: UIViewController
{

    var category: String?
    var name: String?
    var date: String?
    var time: String?
    var subtitle: String?
    
    var timePicker: UIDatePicker?
    var eventDatePicker: UIDatePicker?
 
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var subtitleField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextAction(_ sender: UIButton)
    {
         if(nameField.text != "" && dateField.text != "" && timeField.text != "")
         {
            performSegue(withIdentifier: "toEventP2", sender: self)
         }
        else
         {
            createAlert(title: "Gathering Info", message: "Please enter the all the required fields!")
         }
    }

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(category)
        
        let todayPlusOne = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        
        timePicker = UIDatePicker()
        timePicker?.addTarget(self, action: #selector(HostEventP1ViewController.timeChanged(timePicker:)), for: .valueChanged)
        timePicker?.datePickerMode = .time
        timeField.inputView = timePicker

        eventDatePicker = UIDatePicker()
        let today = Date()
        eventDatePicker?.minimumDate = today
        eventDatePicker?.maximumDate = todayPlusOne
      
        eventDatePicker?.addTarget(self, action: #selector(HostEventP1ViewController.dateChanged(eventDatePicker:)), for: .valueChanged)
        eventDatePicker?.datePickerMode = .date
        dateField.inputView = eventDatePicker
        
        
 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileFinish1.viewTapped(gesture:)))
        
        view.addGestureRecognizer(tapGesture)
        
    
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toEventP2")
        {
            let destinationVC = segue.destination as! HostEventP2ViewController
            destinationVC.name = nameField.text
            destinationVC.date = dateField.text
            destinationVC.time = timeField.text
            destinationVC.subtitle = subtitleField.text
            destinationVC.category = category
        }
    }
    
    //BEGIN PICKER METHODS
    
    
    @objc func dateChanged(eventDatePicker: UIDatePicker)
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/YYYY"
        dateField.text = dateformatter.string(from: eventDatePicker.date)
        view.endEditing(true)
    }
    @objc func timeChanged(timePicker: UIDatePicker)
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        timeField.text = dateformatter.string(from: timePicker.date)
        view.endEditing(true)
    }
    @objc func viewTapped(gesture: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
        nameField.inputAccessoryView = toolbar
        subtitleField.inputAccessoryView = toolbar
        dateField.inputAccessoryView = toolbar
        timeField.inputAccessoryView = toolbar
        
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
        if(timeField.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * keyboard.height
        }
        else if(nameField.isEditing || subtitleField.isEditing || dateField.isEditing)
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
