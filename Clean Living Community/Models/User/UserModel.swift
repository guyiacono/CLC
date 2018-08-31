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
import CoreLocation

class UserModel
{
    static let sharedInstance = UserModel()
    var uid = ""
    var userInfo: User?
    var users = [User]()
    
    
    func getUserInfo (uid: String, completion: @escaping(_ user : User) -> Void)
    {
        let userPath = "Users/" + uid + "/Profile"
        let userRef = Database.database().reference(withPath: userPath)
        userRef.observeSingleEvent(of: .value, with: {snapshot in
            self.userInfo = User(snapshot: snapshot)
            completion(self.userInfo!)
        })
       
    }
    
    func findUser(uid: String) -> User?
    {
        var founduser: User?
        for user in users
        {
            print("key : uid")
            print(user.key + " " + uid)
            if(user.key == uid )
            {
                founduser = user
                
               
                return(founduser)
            }
        }
        return(nil)
    }
    
    func findUserProfileInfo(uid: String, completion: @escaping (_ user : [String : String]) -> Void)
    {
        let path = "Users/" + uid + "/Profile"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            
            var tempDict = [String : String]()
            for child in snapshot.children
            {
                let data = child as? DataSnapshot
                tempDict[(data?.key)!] = data?.value as? String
            }
            completion(tempDict)
            
        })
    }
    
    func registerUser (withEmail email: String, withPassword password: String, withFirst fname: String, withLast lname: String, withDOB dob: String, withTown home: String, withEdu edu: String, withOrientation orient: String, withRecovery recovery: String, withRomance relation: String, withReligion rel: String, withSpiritual spirit: String, isSmoke smoke: String, attendSupport sup: String, withOpt1 p1: String, withOpt2 p2: String, withBio bio: String,  withImage1 image1: UIImage, withImage2 image2: UIImage, withImage3 image3: UIImage, withQuestionair questionair : [Int], withLat lat: Double, withLong long: Double, completion: @escaping(Bool)->Void)
    {
        Auth.auth().createUser(withEmail: email, password: password) {myuser,error in
            if error == nil {
               let uid = myuser?.user.uid
                self.addUserPofile(uid: uid!, withEmail: email, withFirst: fname, withLast: lname, withDOB: dob, withTown: home, withEdu: edu, withOrientation: orient, withRecovery: recovery, withRomance: relation, withReligion: rel, withSpiritual: spirit, isSmoke: smoke, attendSupport: sup, withOpt1: p1, withOpt2: p2, withBio: bio, withImage1: image1, withImage2: image2, withImage3: image3, withQuestionair: questionair, withLat: lat, withLong: long, completion: {(success)
                    in
                    if(success)
                    {
                        completion(true)
                    }
                })
                
            }
        }
        
    }
    func addUserPofile(uid: String, withEmail email: String, withFirst fname: String, withLast lname: String, withDOB dob: String, withTown home: String, withEdu edu: String, withOrientation orient: String, withRecovery recovery: String, withRomance relation: String, withReligion rel: String, withSpiritual spirit: String, isSmoke smoke: String, attendSupport sup: String, withOpt1 p1: String, withOpt2 p2: String, withBio bio: String, withImage1 image1: UIImage, withImage2 image2: UIImage, withImage3 image3: UIImage, withQuestionair questionair : [Int], withLat lat: Double, withLong long: Double, completion: @escaping(Bool)->Void)
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
                                            let newUser = User(fname: fname, lname: lname, dob: dob, home: home, edu: edu, orient: orient, recovery: recovery, relation: relation, rel: rel, spirit: spirit, smoke: smoke, sup: sup, p1: p1, p2: p2, key: uid, bio: bio, url1: photo1URL, url2: photo2URL, url3: photo3URL, questionair : questionair, lat: lat , long: long)
                                            
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
            connections.removeAll()
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
    
    
    func getUnderConnectionsSnapshot(withUID UID : String!,completion: @escaping(_ list: [[String : String]]) -> Void)
    {
        
        var connections = [[String : String]]()
        let path = "Users/" + UID + "/Connections"
        
        let ref = Database.database().reference(withPath: path)
        //ref.observeSingleEvent(of: .value, with: {snapshot in
        ref.observe(.value, with: {snapshot in
            
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
        ref.observe(.value, with: {snapshot in
            messages.removeAll()
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
    
    func updateEvents(userUID: String, eventID: String, eventDateTimeString: String,completion:  @escaping(Bool) -> Void)
    {
        let path = "Users/" + userUID + "/Events"
        let ref = Database.database().reference(withPath: path)
        ref.updateChildValues([eventID : eventDateTimeString])
        completion(true)
    }
    func getEventList(userUID: String, completion : @escaping (_ list : [String : String]) -> Void)
    {
        var events = [String: String]()
        let path = "Users/" + userUID + "/Events"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            events.removeAll()
            for (child) in snapshot.children
            {
                let snap = child as! DataSnapshot
                let eventID = snap.key
                let eventDateTime = snap.value
                
                events[eventID] = eventDateTime as? String
            }
            completion(events)
        })
    }
    
    func getEventListObserve(userUID: String, completion: @escaping(_ list : [String : String]) -> Void)
    {
        var events = [String: String]()
        let path = "Users/" + userUID + "/Events"
        let ref = Database.database().reference(withPath: path)
        ref.observe(.value, with: {snapshot in
            events.removeAll()
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                let eventID = snap.key
                let eventDateTime = snap.value
                
                events[eventID] = eventDateTime as? String
            }
            completion(events)
        })
    }
    func checkIfRSVP(userUID: String, eventUID: String, completion: @escaping (_ dateTime: String) -> Void)
    {
        print("checking RSVP Status")
        var dateTime: String?
        getEventList(userUID: userUID) { (list) in
            
            dateTime = list[eventUID] as? String
            print(dateTime)
            if(dateTime == nil)
            {
                dateTime = ""
            }
            completion(dateTime!)
        }
    }
    func updateLocation(uid: String, latitude: Double, longitude: Double)
    {
        let path = "Users/" + uid + "/Profile"
        let ref = Database.database().reference(withPath: path)
        print(latitude)
        print(longitude)
        ref.updateChildValues(["lastLat" : latitude])
        ref.updateChildValues(["lastLong" : longitude])
    }
    
    func checkIfConnection(meUID: String, friendUID: String, completion: @escaping (_ check: Bool) -> Void)
    {
        var check = true
        let path = "Users/" + meUID + "/Connections/"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.hasChild(friendUID)
            {
                check = true
                completion(check)

            }
            else
            {
                check = false
                completion(check)
            }
        })
    }
    
    func distanceBetweenUsers(meUID: String, otherUID: String, completion: @escaping (_ distance: Double)->Void)
    {
        var meLat = 0.0
        var themLat = 0.0
        var meLong = 0.0
        var themLong = 0.0
        
        
        var path = "Users/" + meUID + "/Profile/" + "lastLat"
        var ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.value != nil
            {
                meLat = (snapshot.value as? Double)!
                
                path = "Users/" + meUID + "/Profile/" + "lastLong"
                ref = Database.database().reference(withPath: path)
                ref.observeSingleEvent(of: .value, with: {snapshot in
                    if snapshot.value != nil
                    {
                        meLong = (snapshot.value as? Double)!
                        
                        path = "Users/" + otherUID + "/Profile/" + "lastLat"
                        ref = Database.database().reference(withPath: path)
                        ref.observeSingleEvent(of: .value, with: {snapshot in
                            if snapshot.value != nil
                            {
                                themLat = (snapshot.value as? Double)!
                                
                                path = "Users/" + otherUID + "/Profile/" + "lastLong"
                                ref = Database.database().reference(withPath: path)
                                ref.observeSingleEvent(of: .value, with: {snapshot in
                                    if snapshot.value != nil
                                    {
                                        themLong = (snapshot.value as? Double)!
                                        
                                        let meLoc = CLLocation(latitude: (meLat as? Double)!, longitude: (meLong as? Double)!)
                                        let themLoc = CLLocation(latitude: (themLat as? Double)!, longitude: (themLong as? Double)!)
                                        
                                        var distance = meLoc.distance(from: themLoc)
                                        distance = distance * 0.000621371
                                        distance = round(distance * 10) / 10
                                        completion(distance)
                                        
                                        
                                    }
                                })
                                
                                
                            }
                        })
                    }
                })
                
            }
        })
    }
    
    func writeQuestionair(UID: String, val: Int)
    {
        var path = "Users/" + UID + "/Questionair"
        let ref = Database.database().reference(withPath: path)
        var qAnswer = Array(repeating: 0, count: 100)
        var number = 1
        while number <= 100
        {
            ref.updateChildValues(["\(number)" : val])
            //ref.setValue(["Q\(number)" : filler])
            number = number + 1
        }
        
    }
    func getQuestionairAnswers(UID: String, completion: @escaping (_ answers: [Int])->Void)
    {
        var questionArray = [Int]()
        let path = "Users/" + UID + "/Questionair"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                questionArray.append(snap.value as! Int)
            }
        completion(questionArray)
        })
    }
    
    func returnUserObject(UID: String, completion: @escaping(User)->Void)
    {
        users.removeAll()
        let path = "Users/" + UID
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            // print(snapshot)
            let user = User(snapshot: snapshot)
            completion(user)
        }
        )
    }
    
    func unRSVPFromEvent(userUID : String, eventUID : String, eventDateTime : String, completion: @escaping (Bool) -> Void)
    {
        var path = "Events/" + eventDateTime + "/" + eventUID + "/Attending/" + userUID
        Database.database().reference(withPath: path).removeValue()
        
        path = "Users/" + userUID + "/Events/" + eventUID
        Database.database().reference(withPath : path).removeValue()
        
        completion(true)
    }
 
    func disconnectFromUser(myUID : String, theirUID: String, completion: @escaping (Bool) -> Void)
    {
        var path = "Users/" + myUID + "/Connections/" + theirUID
        Database.database().reference(withPath: path).removeValue()
        
        path = "Users/" + theirUID + "/Connections/" + myUID
        Database.database().reference(withPath: path).removeValue()

        completion(true)

    }
    func listAllUsersObserve(completion: @escaping(Bool)->Void)
    {
        users.removeAll()
        let path = "Users/"
        let ref = Database.database().reference(withPath: path)
        ref.observe(.value, with: {snapshot in
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
}


