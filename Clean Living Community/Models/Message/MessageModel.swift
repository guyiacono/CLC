//
//  MessageModel.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/27/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//


import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class MessageModel
{
    static let sharedInstance = MessageModel()
    var messages = [Message]()
    
    func findMessage(uid: String) -> Message?
    {
        var foundMessage: Message?
        for message in messages
        {
            if(message.key == uid )
            {
                foundMessage = message
                
                return(foundMessage)
            }
        }
        return(nil)
    }
    func listAllMessages(completion: @escaping(Bool)->Void)
    {
        
        let path = "Messages/"
        let ref = Database.database().reference(withPath: path)
     
        ref.observe(.value, with: {snapshot in
            self.messages.removeAll()
            for child in snapshot.children
            {
                let message = Message(snapshot:child as! DataSnapshot)
                self.messages.append(message)
            }
            completion(true)
        }
        )
    }
    func getMessageData(messageID: String, completion: @escaping([[String : String]]) -> Void)
    {
        var messageText = [[String : String]]()
        let path = "Messages/" + (messageID)
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                if(snap.key != "Sender" && snap.key != "Reciever")
                {
                    for text in snap.children
                    {

                        let messageInfo = text as! DataSnapshot
                        var pair = [String : String]()
                        pair[messageInfo.key] = messageInfo.value as? String
                        messageText.append(pair)
                    }
                }
            }
            completion(messageText)
        }
        )
        
    }
    func sendNewText(messageID: String, dateTime: String, senderUID: String, text: String, completion: @escaping (Bool) -> Void)
    {
        let path = "Messages/" + (messageID) + "/" + dateTime
        let ref = Database.database().reference(withPath: path)
        ref.setValue([senderUID : text])
        completion(true)
        
    }
}
