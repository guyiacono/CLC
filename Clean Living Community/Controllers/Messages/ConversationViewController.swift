//
//  ConversationViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/30/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var thisMessageUID: String?
    var userModel = UserModel.sharedInstance
    var messageModel = MessageModel.sharedInstance
    let signedInUserID = Auth.auth().currentUser?.uid
    var messageText : [[String : String]]?
    
    var textContents: String?
    
    var otherUser : User?
    var otherUserPhoto = UIImageView()
    
    @IBOutlet weak var table: UITableView!
    
    
    
    @IBOutlet weak var entryField: UITextField!
    
    // update this value whenever the text field is changed so sending while editting doesn't send nil
    @IBAction func entryFieldChanged(_ sender: UITextField)
    {
        textContents = sender.text
    }
    
    
    
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendAction(_ sender: UIButton)
    {
        // check to see if the users are connected, if not don't send the message
        userModel.checkIfConnection(meUID: signedInUserID!, friendUID: (otherUser?.key)!) { (isConnection) in
            if(isConnection == true)
            {
                // make the entry field is enabled false (to prevent button mashing)
                self.entryField.isEnabled = false
                // make sure a blank message isn't being sent
                if (self.textContents != "" && self.textContents != nil)
                {
                    // delete the entered text from the field
                    self.entryField.text = ""
                    let today = Date()
                    
                    // get the datetime right now in UTC
                    let printDate = self.convertToUTC(date: today)!
                    
                    if(self.thisMessageUID != nil)
                    {
                        // send the new message
                        self.messageModel.sendNewText(messageID: self.thisMessageUID!, dateTime: printDate, senderUID: self.signedInUserID!, text: self.textContents!, completion: {(success)
                            in
                            if (success)
                            {
                                
                                
                                //self.viewDidAppear(false)
                            }
                        })
                    }
                    // if there was no conversation already in existance
                    else
                    {
                        // create one
                        self.messageModel.createNewMessage(sender: self.signedInUserID!, receiver:(self.otherUser?.key)!,completion:  { (newUID) in
                            // create a new UID
                            if(newUID != nil)
                            {
                                self.thisMessageUID = newUID
                                // send the first text
                                self.messageModel.sendNewText(messageID: self.thisMessageUID!, dateTime: printDate, senderUID: self.signedInUserID!, text: self.textContents!, completion: {(success)
                                    in
                                    if (success)
                                    {
                                        // store the message id and the other person's key in each others message
                                        // sections in the database
                                        self.messageModel.setMessageWith(signedInUID: self.signedInUserID!, otherPersonUID: (self.otherUser?.key)!, messageID: self.thisMessageUID!, completion: {(success2)
                                            in
                                            if(success2)
                                            {
                                                self.viewDidLoad()
                                            }
                                        })
                                        
                                    }
                                })
                            }
                        }
                        )}
                    
                    
                    // clear the field
                    self.textContents = ""
                    // allow messages to be sent again
                    self.entryField.isEnabled = true
                    
                }
            }
            // if not connected, show alert saying so
            else
            {
                self.createAlert(title: "Unable to Send", message: "You can only send messages to your connections!")
            }
        }
        
        
        
       
       
    }
    
   

    override func viewDidLoad()
    {
        super.viewDidLoad()
        handleViewAdjustmentsFromKeyboard()
        handleDoneButtonOnKeyboard()
        table.dataSource = self
        table.delegate = self
        // prepare the other user's photo for use in the table cells
        let otherURL = otherUser?.url1
        setImageFromURl(stringImageUrl: otherURL!, forImage: otherUserPhoto)
        
        // get all the messages
        messageModel.listAllMessages(completion: {(success)
        in
            // if there is a message object for this conversation
            if (success && self.thisMessageUID != nil)
            {
                // find this message and prepare the table
                self.messageModel.getMessageData(messageID: self.thisMessageUID!, completion: {(list)
                    in
                    if (list.count >= 0)
                    {
                        self.messageText = list
                        self.table.reloadData()
                        self.scrollToLastRow()

                    }
                    })
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // if there are not messages in this conversation, there are not sections
        if(messageText != nil)
        {
            return messageText!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = table.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! ConversationTableViewCell
        cell.otherPhoto.image = nil
        
        // for each cell, get a message in the conversation
        let IDcontentSet = messageText![indexPath.row]
        
       // if the message was sent by this user
        if(IDcontentSet[(signedInUserID)!] != nil )
        {
            cell.messageText.text = IDcontentSet[signedInUserID!]
            cell.messageText.sizeToFit()
            cell.messageText.numberOfLines = 0
            
            
        }
            // if the message was sent by the other user
        else
        {
            cell.messageText.text = IDcontentSet[(otherUser?.key)!]
            cell.messageText.sizeToFit()
            cell.messageText.numberOfLines = 0
            cell.otherPhoto.image = otherUserPhoto.image

        }
        
        return cell
        
    }

    // automatically scrolls to the most recent message ( at the bottom) of the table
    func scrollToLastRow()
    {
        let indexPath = NSIndexPath(row: (messageText?.count)! - 1, section: 0)
        self.table.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    
    
    /*
    override func viewWillAppear(_ animated: Bool)
    {
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setImageFromURl(stringImageUrl url: String, forImage image: UIImageView)
    {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                image.image = UIImage(data: data as Data)
            }
        }
    }
    
    
    func convertToUTC(date: Date) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyyHHmmss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.string(from: date)
        
        return localDate
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
         entryField.inputAccessoryView = toolbar
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
        if(entryField.isEditing)
        {
            guard let keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
            {
                return
            }
            view.frame.origin.y = -1 * keyboard.height + 50
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
            view.frame.origin.y = 0
        }
    }
}


