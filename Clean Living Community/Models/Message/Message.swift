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

struct Message
{
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
