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
    let sender : String
    let reciever: String
    
    
    
    let ref: DatabaseReference?
    
    init(snapshot: DataSnapshot)
    {
        key = snapshot.key
        //print(snapshot)
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
    
        sender = snapshotValue["Sender"] as! String
        reciever = snapshotValue["Reciever"] as! String
        
        ref = snapshot.ref
    }
    
     init(key: String, sender: String, reciever: String)
     {
        self.key = key
        self.sender = sender
        self.reciever = reciever
        self.ref = nil
    }
    
    func senderReciever() -> Any
    {
        return
            [
                "Sender" : sender,
                "Reciever" : reciever
            ]
    }
    
    
        
}
