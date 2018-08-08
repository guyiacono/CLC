//
//  UserModel.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/2/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class UserModel
{
    static let sharedInstance = UserModel()
    var uid = ""
    var userInfo: User?
    var users = [User]()
    
    
    func getUserInfo (uid: String)
    {
        let userPath = "Users/Profile" + uid
        let userRef = Database.database().reference(withPath: userPath)
        userRef.observeSingleEvent(of: .value, with: {snapshot in self.userInfo = User(snapshot: snapshot)})
        print(self.userInfo)
    }
    
    func findUser(uid: String) -> User?
    {
        var founduser: User?
        for user in users
        {
            if(user.key == uid )
            {
                founduser = user
                
                return(founduser)
            }
        }
        return(nil)
    }
    
    
    func registerUser (withEmail email: String, withPassword password: String, withFirst fname: String, withLast lname: String, withDOB dob: String, withTown home: String, withEdu edu: String, withOrientation orient: String, withRecovery recovery: String, withRomance relation: String, withReligion rel: String, withSpiritual spirit: String, isSmoke smoke: String, attendSupport sup: String, withOpt1 p1: String, withOpt2 p2: String, withBio bio: String,  withImage1 image1: UIImage, withImage2 image2: UIImage, withImage3 image3: UIImage, withQuestionair questionair : [Int], completion: @escaping(Bool)->Void)
    {
        Auth.auth().createUser(withEmail: email, password: password) {myuser,error in
            if error == nil {
               let uid = myuser?.user.uid
                self.addUserPofile(uid: uid!, withEmail: email, withFirst: fname, withLast: lname, withDOB: dob, withTown: home, withEdu: edu, withOrientation: orient, withRecovery: recovery, withRomance: relation, withReligion: rel, withSpiritual: spirit, isSmoke: smoke, attendSupport: sup, withOpt1: p1, withOpt2: p2, withBio: bio, withImage1: image1, withImage2: image2, withImage3: image3, withQuestionair: questionair, completion: {(success)
                    in
                    if(success)
                    {
                        completion(true)
                    }
                })
                
            }
        }
        
    }
    func addUserPofile(uid: String, withEmail email: String, withFirst fname: String, withLast lname: String, withDOB dob: String, withTown home: String, withEdu edu: String, withOrientation orient: String, withRecovery recovery: String, withRomance relation: String, withReligion rel: String, withSpiritual spirit: String, isSmoke smoke: String, attendSupport sup: String, withOpt1 p1: String, withOpt2 p2: String, withBio bio: String, withImage1 image1: UIImage, withImage2 image2: UIImage, withImage3 image3: UIImage, withQuestionair questionair : [Int], completion: @escaping(Bool)->Void)
    {
        var photo1URL = ""
        var photo2URL = ""
        var photo3URL = ""
        
       // Photo 1
        let image1Ref = Storage.storage().reference().child("\(uid)/pic1.jpg")
        var imageData = UIImageJPEGRepresentation(image1, 0.8)!
        _ = image1Ref.putData(imageData, metadata: nil, completion: { (metadata, error) in
            guard metadata != nil else
            {
                print(error!)
                return
            }
            Storage.storage().reference().child("\(uid)/pic1.jpg").downloadURL{url, error in
                if let error = error
                {
                    print(error)
                }
                else
                {
                    guard let url = url?.absoluteString else {return}
                    photo1URL = url
                    
                    // Photo 2

                    
                    let image2Ref = Storage.storage().reference().child("\(uid)/pic2.jpg")
                    imageData = UIImageJPEGRepresentation(image2, 0.8)!
                    _ = image2Ref.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        guard metadata != nil else
                        {
                            print(error!)
                            return
                        }
                        Storage.storage().reference().child("\(uid)/pic2.jpg").downloadURL{url, error in
                            if let error = error
                            {
                                print(error)
                            }
                            else
                            {
                                photo2URL = (url?.absoluteString)!
                                
                                
                                // Photo 3
                                let image3Ref = Storage.storage().reference().child("\(uid)/pic3.jpg")
                                imageData = UIImageJPEGRepresentation(image3, 0.8)!
                                _ = image3Ref.putData(imageData, metadata: nil, completion: { (metadata, error) in
                                    guard metadata != nil else
                                    {
                                        print(error!)
                                        return
                                    }
                                    Storage.storage().reference().child("\(uid)/pic3.jpg").downloadURL{url, error in
                                        if let error = error
                                        {
                                            print(error)
                                        }
                                        else
                                        {
                                            
                                            
                                            photo3URL = (url?.absoluteString)!
                                            
                                            let usersRef = Database.database().reference(withPath: "Users")
                                            let newUser = User(fname: fname, lname: lname, dob: dob, home: home, edu: edu, orient: orient, recovery: recovery, relation: relation, rel: rel, spirit: spirit, smoke: smoke, sup: sup, p1: p1, p2: p2, key: uid, bio: bio, url1: photo1URL, url2: photo2URL, url3: photo3URL, questionair : questionair)
                                            
                                            var uRef = usersRef.child(uid).child("Profile")
                                            uRef.setValue(newUser.toAnyObject())
                                            
                                            
                                            uRef = usersRef.child(uid).child("Questionair")
                                            uRef.setValue(newUser.toQuestionairResults())
                                            
                                            print("user registered")
                                            completion(true)
                                            
                                        }
                                    }
                                })
                                
        
                            }
                        }
                    })
        
                }
            }
        })
        
    }
        
        
        
    func listAllUsers(completion: @escaping(Bool)->Void)
    {
        users.removeAll()
        let path = "Users/"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            // print(snapshot)
            for child in snapshot.children
            {
                let user = User(snapshot:child as! DataSnapshot)
                self.users.append(user)
            }
            completion(true)
        }
        )
    }
    
    func listAllUsersExcept(withUID UID: String!) -> [User]
    {
        print(users)
        var list = users
        for (index,person) in list.enumerated()
        {
            if(person.key == UID)
            {
                list.remove(at: index)
            }
        }
        return(list)
    }
    
    func getUnderConnections(withUID UID : String!,completion: @escaping(_ list: [[String : String]]) -> Void)
    {
        
        var connections = [[String : String]]()
        let path = "Users/" + UID + "/Connections"
        
        let ref = Database.database().reference(withPath: path)
        ref.observe(.value, with: {snapshot in
             //print(snapshot)
            for (child) in snapshot.children
            {
                var tempdict : [String : String] = [:]
                let snap = child as! DataSnapshot
                let photoSnap = snap.childSnapshot(forPath: "MainPhoto")
                tempdict[(photoSnap.key)] = photoSnap.value as? String
                let nameSnap = snap.childSnapshot(forPath: "Name")
                tempdict[nameSnap.key] = nameSnap.value as? String
                let requestSnap = snap.childSnapshot(forPath: "Request")
                tempdict[requestSnap.key] = requestSnap.value as? String
                let uidSnap = snap.childSnapshot(forPath: "UID")
                tempdict[uidSnap.key] = uidSnap.value as? String
                connections.append(tempdict)
            }
           completion(connections)
        }
        )
    }
    
    func sendFriendRequest(withFriendUID: String!, withMyUID: String!, withMyPhotoURL : String!, withMyName: String!, withRequestStatus: String, completion: @escaping(Bool)->Void )
    {
        let path = "Users/" + withFriendUID + "/Connections/" + withMyUID
        let ref = Database.database().reference(withPath: path)
        ref.updateChildValues(["MainPhoto" : withMyPhotoURL])
        ref.updateChildValues(["Name" : withMyName])
        ref.updateChildValues(["UID" : withMyUID])
        ref.updateChildValues(["Request" : withRequestStatus])
        completion(true)
       
    }
    func listAllMessages(withUID UID : String!,completion: @escaping(_ list: [String: String]) -> Void)
    {
        
        var messages = [String: String]()
        let path = "Users/" + (UID) + "/Messages"
        
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            //print(snapshot)
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                let personID = snap.key
                
                let messageID = snap.value
                messages[personID] = messageID as? String
                
            }
            completion(messages)
        }
        )
    }
    
    
}
