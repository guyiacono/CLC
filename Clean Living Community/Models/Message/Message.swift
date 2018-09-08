//
//  Message.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/27/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import Foundation

import FirebaseDatabase
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

// same format as user class, see comments there
struct Message
{
    /*
     sender is the user that initiated the message
     reciever is the user that didnt' initiate
     lastDate is the datetime the last message in the conversation was sent at
     lastText is the text of the last message that was sent in the conversation
 */
    let key : String
    let sender : String?
    let receiver: String?
    let lastDate: String?
    let lastText: String?
    
    
    
    let ref: DatabaseReference?
    
    init(snapshot: DataSnapshot)
    {
        key = snapshot.key
        //print(snapshot)
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
    
        sender = snapshotValue["Sender"] as? String
        receiver = snapshotValue["Receiver"] as? String
        lastDate = snapshotValue["lastTime"] as? String
        lastText = snapshotValue["lastMessage"] as? String
        
        
        ref = snapshot.ref
    }
    
     init(key: String, sender: String, receiver: String)
     {
        self.key = key
        self.sender = sender
        self.receiver = receiver
        self.lastDate = nil
        self.lastText = nil
        self.ref = nil
    }
    
    func senderReceiver() -> Any
    {
        return
            [
                "Sender" : sender,
                "Receiver" : receiver
            ]
    }
    
    
        
}
