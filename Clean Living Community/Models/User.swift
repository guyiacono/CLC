//
//  User.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/1/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

struct User
{
    let key: String
    
   
    let first: String
    let last: String
    let DOB: String
    let education: String
    let hometown: String
    let orientation: String
    let recoveryDate: String
    let relationship: String
    let religious: String
    let spiritual: String
    let smoker: String
    let support: String
    
    let pref1: String
    let pref2: String
    
    let bio: String
    
    var url1: String?
    var url2: String?
    var url3: String?
    
    let questionair: [Int]
    /*
    let Q1: Int
    let Q2: Int
    let Q3: Int
    let Q4: Int
    let Q5: Int
    */
    let ref: DatabaseReference?
    
    init(snapshot: DataSnapshot)
    {
        key = snapshot.key
        var snapshotValue = snapshot.childSnapshot(forPath: "/Profile").value as! [String: AnyObject]
        
        
        

 
        first = snapshotValue["First Name"] as! String
        last = snapshotValue["Last Name"] as! String
        DOB = snapshotValue["DOB"] as! String
        hometown = snapshotValue["Hometown"] as! String
        education = snapshotValue["Education"] as! String
        orientation = snapshotValue["Orientation"] as! String
        recoveryDate = snapshotValue["Recovery Date"] as! String
        relationship = snapshotValue["Relationship"] as! String
        religious = snapshotValue["Religious"] as! String
        spiritual = snapshotValue["Spiritual"] as! String
        smoker = snapshotValue["Smoker"] as! String
        support = snapshotValue["Support Groups"] as! String
        pref1 = snapshotValue["Preference1"] as! String
        pref2 = snapshotValue["Preference2"] as! String
        bio = snapshotValue["Bio"] as! String
        url1 = snapshotValue["Photo1"] as! String
        url2 = snapshotValue["Photo2"] as! String
        url3 = snapshotValue["Photo3"] as! String
        
      
        
        snapshotValue = snapshot.childSnapshot(forPath: "/Questionair").value as! [String: AnyObject]
        questionair = Array(repeating: 0, count: 100)

        /*
        Q1 = snapshotValue["Q1"] as! Int
        Q2 = snapshotValue["Q2"] as! Int
        Q3 = snapshotValue["Q3"] as! Int
        Q4 = snapshotValue["Q4"] as! Int
        Q5 = snapshotValue["Q5"] as! Int
        */
        ref = snapshot.ref
 
    }
    init(fname: String, lname: String, dob: String, home: String, edu: String, orient: String, recovery: String, relation: String, rel: String, spirit: String, smoke: String, sup: String, p1: String, p2: String, key: String, bio: String, questionair: [Int])
    {
        self.first = fname
        self.last = lname
        self.DOB = dob
        self.hometown = home
        self.education = edu
        self.orientation = orient
        self.recoveryDate = recovery
        self.relationship = relation
        self.religious = rel
        self.spiritual = spirit
        self.smoker = smoke
        self.support = sup
        self.pref1 = p1
        self.pref2 = p2
        self.key = key
        self.bio = bio
        self.questionair = questionair
        self.ref = nil
    }
    func toAnyObject() -> Any
    {
        return
            [
                "First Name" : first,
                "Last Name" : last,
                "DOB" : DOB,
                "Hometown" : hometown,
                "Education": education,
                "Orientation" : orientation,
                "Recovery Date" : recoveryDate,
                "Relationship" : relationship,
                "Religious" : religious,
                "Spiritual" : spiritual,
                "Smoker" : smoker,
                "Support Groups" : support,
                "Preference1" : pref1,
                "Preference2" : pref2,
                "key" : key,
                "Bio" : bio,
                "Photo1": url1,
                "Photo2": url2,
                "Photo3": url3
                
        ]
    }
    func toQuestionairResults() -> Any
    {
        var answers : [String:Int] = [:]
        for(index, element) in (questionair.enumerated())
        {
            let key = "Q\(index+1)"
            let val = questionair[index]
            answers[key] = val
        }
        return answers
    }
}

