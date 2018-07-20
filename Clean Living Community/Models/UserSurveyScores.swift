//
//  UserSurveyScores.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/18/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

class UserSurveyScores
{
     let Q1: Int
     let Q2: Int
     let Q3: Int
     let Q4: Int
     let Q5: Int
    
    let ref: DatabaseReference?
    
    init(snapshot: DataSnapshot)
    {
        key = snapshot.key
        let snapshotValue = snapshot.childSnapshot(forPath: "/Profile").value as! [String: AnyObject]
    
    
    
    
}

