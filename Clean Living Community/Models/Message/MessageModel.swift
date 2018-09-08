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
    
    // finds and returns a message in the messages array by UID
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
    // populates the messages array with all the conversations in firebase
    // listens for changes, will update in real time
    func listAllMessages(completion: @escaping(Bool)->Void)
    {
        
        let path = "Messages/"
        let ref = Database.database().reference(withPath: path)
        ref.observe(.value, with: {snapshot in
            self.messages.removeAll()
            if(snapshot.hasChild("Reciever") == true)
            {
            }
            for child in snapshot.children
            {
                let message = Message(snapshot:child as! DataSnapshot)
                self.messages.append(message)
            }
            completion(true)
        }
        )
    }
    // returns an array of dictionaries containing all the message data for a conversation
    // each dictionary contains the sender, datetime, and text body of a message
    // the dictionary is ordered by datetime
    func getMessageData(messageID: String, completion: @escaping([[String : String]]) -> Void)
    {
        var messageText = [[String : String]]()
        let path = "Messages/" + (messageID)
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                if(snap.key != "Sender" && snap.key != "Receiver")
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
    // writes a new message for a conversation
    func sendNewText(messageID: String, dateTime: String, senderUID: String, text: String, completion: @escaping (Bool) -> Void)
    {
        var path = "Messages/" + (messageID) + "/" + dateTime
        var ref = Database.database().reference(withPath: path)
        ref.setValue([senderUID : text])
        
        path = "Messages/" + (messageID)
        ref = Database.database().reference(withPath : path)
        ref.updateChildValues(["lastMessage" : text])
        ref.updateChildValues(["lastTime" : dateTime])
        
        
        completion(true)
        
    }
    
    // creates a new message node for users that have never messaged before
    func createNewMessage(sender: String, receiver: String, completion: @escaping ( _ newMessageID : String) -> Void)
    {
        
       let path = "Messages"
        
         let ref = Database.database().reference(withPath : path).childByAutoId()

        ref.updateChildValues(["Sender" : sender])
        ref.updateChildValues(["Receiver" : receiver])
        completion(ref.key)
    
    }
    
    // given two user's finds whether or not there is a message between them
    // try not to use this, if there are lots of messages it could get inefficient
    func findMessageBetween(sender: String, receiver: String) -> String?
    {
        //print(self.messages)
        for message in self.messages
        {
            
            if(message.receiver! == receiver && message.sender! == sender)
            {
                
                return message.key
            }
        }
        return(nil)
       
    }
    // sets appropriate message data inside the two user's message sections. Key is the other user's ID, value is
    // the message ID
    func setMessageWith(signedInUID: String, otherPersonUID: String, messageID: String, completion: @escaping (Bool) -> Void)
    {
        var path = "Users/" + (signedInUID) + "/Messages/"
        var ref = Database.database().reference(withPath: path)
        ref.updateChildValues([otherPersonUID : messageID])
        path = "Users/" + otherPersonUID + "/Messages/"
        ref = Database.database().reference(withPath: path)
        ref.updateChildValues([signedInUID : messageID])
        completion(true)
        
    }
}
