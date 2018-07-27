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
    /*
    
    func createMessage (withEmail email: String, withPassword password: String, withFirst fname: String, withLast lname: String, withDOB dob: String, withTown home: String, withEdu edu: String, withOrientation orient: String, withRecovery recovery: String, withRomance relation: String, withReligion rel: String, withSpiritual spirit: String, isSmoke smoke: String, attendSupport sup: String, withOpt1 p1: String, withOpt2 p2: String, withBio bio: String,  withImage1 image1: UIImage, withImage2 image2: UIImage, withImage3 image3: UIImage, withQuestionair questionair : [Int], completion: @escaping(Bool)->Void)
    {
        Auth.auth().createUser(withEmail: email, password: password) {myuser,error in
            if error == nil {
                let uid = myuser?.user.uid
                self.addUserPofile(uid: uid!, withEmail: email, withFirst: fname, withLast: lname, withDOB: dob, withTown: home, withEdu: edu, withOrientation: orient, withRecovery: recovery, withRomance: relation, withReligion: rel, withSpiritual: spirit, isSmoke: smoke, attendSupport: sup, withOpt1: p1, withOpt2: p2, withBio: bio, withImage1: image1, withImage2: image2, withImage3: image3, withQuestionair: questionair)
                
            }
        }
        completion(true)
 
    }
    */
    
    
    
}
