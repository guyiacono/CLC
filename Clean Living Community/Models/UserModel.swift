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
            if(user.key == uid)
            {
                founduser = user
                return(founduser)
            }
        }
        return(nil)
    }
    
    
    func registerUser (withEmail email: String, withPassword password: String, withFirst fname: String, withLast lname: String, withDOB dob: String, withTown home: String, withEdu edu: String, withOrientation orient: String, withRecovery recovery: String, withRomance relation: String, withReligion rel: String, withSpiritual spirit: String, isSmoke smoke: String, attendSupport sup: String, withOpt1 p1: String, withOpt2 p2: String, withBio bio: String)
    {
        Auth.auth().createUser(withEmail: email, password: password) {myuser,error in
            if error == nil {
                let uid = myuser?.user.uid //double check to make sure correct UID is being used
                self.addUserPofile(uid: uid!, withEmail: email, withFirst: fname, withLast: lname, withDOB: dob, withTown: home, withEdu: edu, withOrientation: orient, withRecovery: recovery, withRomance: relation, withReligion: rel, withSpiritual: spirit, isSmoke: smoke, attendSupport: sup, withOpt1: p1, withOpt2: p2, withBio: bio)
                
            }
        }
    }
    func addUserPofile(uid: String, withEmail email: String, withFirst fname: String, withLast lname: String, withDOB dob: String, withTown home: String, withEdu edu: String, withOrientation orient: String, withRecovery recovery: String, withRomance relation: String, withReligion rel: String, withSpiritual spirit: String, isSmoke smoke: String, attendSupport sup: String, withOpt1 p1: String, withOpt2 p2: String, withBio bio: String)
    {
        let usersRef = Database.database().reference(withPath: "Users")
        let newUser = User(fname: fname, lname: lname, dob: dob, home: home, edu: edu, orient: orient, recovery: recovery, relation: relation, rel: rel, spirit: spirit, smoke: smoke, sup: sup, p1: p1, p2: p2, key: uid, bio: bio)
        let uRef = usersRef.child(uid)
        uRef.setValue(newUser.toAnyObject())
        print("user registered")
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
    /*
     func authenticate(withEmail email: String, withPassword password: String)->Bool
     {
     var success: Bool = false
     Auth.auth().signIn(withEmail: email, password: password)
     {user, error in
     if error == nil && user != nil
     {
     success = true
     }
     
     else
     {
     success = false
     }
     }
     return (success)
     }
     */
}
