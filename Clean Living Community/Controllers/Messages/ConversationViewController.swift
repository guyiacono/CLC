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
    
    @IBAction func entryFieldChanged(_ sender: UITextField)
    {
        textContents = sender.text
    }
    
    
    
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendAction(_ sender: UIButton)
    {
        entryField.isEnabled = false
        if (textContents != "" && textContents != nil)
        {
            self.entryField.text = ""
            let today = Date()
            
            let printDate = convertToUTC(date: today)!
           
            
            
            messageModel.sendNewText(messageID: thisMessageUID!, dateTime: printDate, senderUID: signedInUserID!, text: textContents!, completion: {(success)
                in
                    if (success)
                    {
                       
                        
                        //self.viewDidAppear(false)
                    }
                })
        }
        textContents = ""
        self.entryField.isEnabled = true
        
    
       
    }
    
   

    override func viewDidLoad()
    {
        super.viewDidLoad()
        handleViewAdjustmentsFromKeyboard()
        handleDoneButtonOnKeyboard()
        table.dataSource = self
        table.delegate = self
        let otherURL = otherUser?.url1
        setImageFromURl(stringImageUrl: otherURL!, forImage: otherUserPhoto)
        
        messageModel.listAllMessages(completion: {(success)
        in
            if (success)
            {
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
        
        
        let IDcontentSet = messageText![indexPath.row]
        
        print(messageText![indexPath.row])
        if(IDcontentSet[(signedInUserID)!] != nil )
        {
            cell.messageText.text = IDcontentSet[signedInUserID!]
            cell.messageText.sizeToFit()
            print(IDcontentSet[signedInUserID!]!)
            cell.messageText.numberOfLines = 0
            
            
        }
        else
        {
            cell.messageText.text = IDcontentSet[(otherUser?.key)!]
            cell.messageText.sizeToFit()
            print(IDcontentSet[(otherUser?.key)!]!)
            cell.messageText.numberOfLines = 0
            cell.otherPhoto.image = otherUserPhoto.image

        }
        
        return cell
        
    }

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
