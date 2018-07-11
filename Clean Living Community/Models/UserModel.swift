//
//  UserModel.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/2/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//
/*
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
        let userPath = "Users/" + uid
        let userRef = Database.database().reference(withPath: userPath)
        userRef.observeSingleEvent(of: .value, with: {snapshot in self.userInfo = User(snapshot: snapshot)})
        print(self.userInfo)
    }
    /*
    func registerUser (withEmail email: String, withPassword password: String)
    {
        Auth.auth().createUser(withEmail: email, password: password)
        {user, error in
            if error == nil
            {
                let uid = user?.uid
                self.addUserPofile(uid: uid!, withEmail: email)
            // add user profile
            }
        }
    } */
    func addUserPofile(uid: String, withEmail email: String, fname: String,fname: String, lname: String, dob: String, home: String, edu: String, orient: String, recovery: String, relation: String, rel: String, spirit: String, smoke: String, sup: String, p1: String, p2: String)
    {
        let usersRef = Database.database().reference(withPath: "Users")
        let newUser = User(key: uid)
        let uRef = usersRef.child(uid)
        uRef.setValue(newUser.toAnyObject())
    }
 
}
*/
