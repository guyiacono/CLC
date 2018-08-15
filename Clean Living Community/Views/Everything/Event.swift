//
//  Event.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/14/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

struct Event
{
    let key: String?
    
    let date: String?
    let name: String?
    let subtitle: String?
    let time: String?
    
    let address: String?
    let city: String?
    let lat: String?
    let long: String?
    let state: String?
    let zip: String?
    
    let organizer: String?
    
    let url1 : String?
    let url2 : String?
    let url3 : String?
    
    let ref: DatabaseReference?

    
    init(snapshot: DataSnapshot)
    {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String : AnyObject]

        
        date = snapshotValue["Date"] as? String
        name = snapshotValue["Event Name"] as? String
        subtitle = snapshotValue["Subtitle"] as? String
        time = snapshotValue["Time"] as? String
        
        address = snapshotValue["Address"] as? String
        city = snapshotValue["City_Town"] as? String
        lat = snapshotValue["Lat"] as? String
        long = snapshotValue["Long"] as? String
        state = snapshotValue["State"] as? String
        zip = snapshotValue["Zip"] as? String
        
        organizer = snapshotValue["Organizer"] as? String
        
        url1 = snapshotValue["Photo1"] as? String
        url2 = snapshotValue["Photo2"] as? String
        url3 = snapshotValue["Photo3"] as? String
 
        ref = snapshot.ref
    }
    
    init(key: String, date: String, name: String, subtitle: String, time: String, address: String, city: String, lat: String, long: String, state: String, zip : String, organizer : String, url1: String, url2: String, url3: String)
    {
        self.key = key
        self.date = date
        self.name = name
        self.subtitle = subtitle
        self.time = time
        
        self.address = address
        self.city = city
        self.lat = lat
        self.long = long
        self.state = state
        self.zip = zip
        
        self.organizer = organizer
        
        self.url1 = url1
        self.url2 = url2
        self.url3 = url3
        
        self.ref = nil
        
        
    }
    
    func createEvent() -> Any?
    {
        return
        [
            "Event Name" : name,
            "Time" : time,
            "Date" : date,
            "Subtitle" : subtitle,
            "key": key,
            
            "Address" : address,
            "City_Town" : city,
            "Lat" : lat,
            "Long" : long,
            "State" : state,
            "Zip" : zip,
            
            "Organizer" : organizer,
            
            "Photo1" : url1,
            "Photo2" : url2,
            "Photo3" : url3
            
        ]
    }
}
