//
//  HostEventP2ViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/15/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class HostEventP2ViewController: UIViewController
{
    
    var category: String?
    var name: String?
    var date: String?
    var time: String?
    var subtitle: String?
    
    var eventDescription: String?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        handleDoneButtonOnKeyboard()
        handleViewAdjustmentsFromKeyboard()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var descriptionSpace: UITextView!
    
    @IBAction func nextAction(_ sender: UIButton)
    {
        if(descriptionSpace.text != nil)
        {
            performSegue(withIdentifier: "toEventP3", sender: self)
        }
        else
        {
            createAlert(title: "Gathering Description", message: "Your event needs a description!")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toEventP3")
        {
            let destinationVC = segue.destination as? HostEventP3ViewController
            destinationVC?.category = category
            destinationVC?.name = name
            destinationVC?.date = date
            destinationVC?.time = time
            destinationVC?.subtitle = subtitle
            destinationVC?.eventDescription = descriptionSpace.text
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
        descriptionSpace.inputAccessoryView = toolbar
        
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
        if(descriptionSpace.isFirstResponder)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * 80
        }
        else
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
            view.frame.origin.y += 80
        }
    }
    
    
    
}
