//
//  EventModel.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/14/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import Foundation

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import CoreLocation

class EventModel
{
    static let sharedInstance = EventModel()
    var events = [Event]()
    
    // finds events in the events array
    // requires events array to be populated
    // requires listAllEvents be run first
    func findEvent(uid: String) -> Event?
    {
        var foundEvent: Event?
        for event in events
        {
            if(event.key == uid )
            {
                foundEvent = event
                
                return(foundEvent)
            }
        }
        return(nil)
    }
    
    
    // populates events array with event objects
    func listAllEvents(completion: @escaping (Bool) -> Void)
    {
        let path = "Events"
        let ref = Database.database().reference(withPath: path)
        ref.observe(.value, with: {snapshot in
            
            self.events.removeAll()
            
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                for eventID in snap.children
                {
                    let event = Event(snapshot:eventID as! DataSnapshot)
                    self.events.append(event)
                }
            }
            completion(true)
        })
    }
    
    // returns an array of dictionarys, one dictionary per event
    // each dictionary has the event's data in it as a key value pair
    // does not listen for updates
    
    func returnAllEvents(completion: @escaping ([[String : String]]) -> Void)
    {
        var eventsList = [[String : String]]()
        let path = "Events/"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children
            {
                let event = child as! DataSnapshot
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MMddyyyyHHmm"
                let dayOfEvent = dateformatter.date(from: event.key)

                print(event.key)
                dateformatter.dateFormat = "MM/dd/yyyy"
                let today = Date()
                
                
                // events are only added to the list of events if they have not already passed
                let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
                if(Calendar.current.dateComponents(components, from: today, to: dayOfEvent!).day!  >= 0)
                {
                    let snap = child as! DataSnapshot
                    for details in snap.children
                    {
                        var tempdict : [String : String] = [:]
                        let eventInfo = details as! DataSnapshot
                        
                        for fields in eventInfo.children
                        {
                            let info = fields as! DataSnapshot
                            tempdict[info.key] = info.value as? String
                            if(info.key == "Lat" || info.key == "Long")
                            {
                                let val = info.value as! Double
                                tempdict[info.key] = String(val)
                            }
                        }
                       
                        eventsList.append(tempdict)
                    }
                }
            }
            completion(eventsList)
        }
        )
    }
    
    // returns a dictionary of event data for a specific dateTime event UID combo
    // is a snapshot and does not listen for changes
    func getEventDict(uid: String, dateTime: String, completion: @escaping(_ event : [String : String]) -> Void)
    {
        let path = "Events/" + dateTime + "/" + uid
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in

            var tempdict : [String : String] = [:]
            for child in snapshot.children
            {
                let info = child as! DataSnapshot
                tempdict[info.key] = info.value as? String
            }
            completion(tempdict)
        })
    }
    
    // creates an event in Firebase, similair structure to creating a user
    func createEvent(key: String, name: String, date: String, subtitle: String, time: String, address: String, city : String, lat: Double, long: Double, state: String, zip: String, organizer: String, image1: UIImage, image2: UIImage, image3: UIImage, location : String, category: String, daytimeString: String, organizerName: String, completion: @escaping (Bool) -> Void)
    {
        
        
        
        var photo1URL = ""
        var photo2URL = ""
        var photo3URL = ""
        
        // Photo 1
        let image1Ref = Storage.storage().reference().child("\(key)/pic1.jpg")
        var imageData = UIImageJPEGRepresentation(image1, 0.8)!
        _ = image1Ref.putData(imageData, metadata: nil, completion: { (metadata, error) in
            guard metadata != nil else
            {
                print(error!)
                return
            }
            Storage.storage().reference().child("\(key)/pic1.jpg").downloadURL{url, error in
                if let error = error
                {
                    print(error)
                }
                else
                {
                    guard let url = url?.absoluteString else {return}
                    photo1URL = url
                    
                    // Photo 2
                    
                    
                    let image2Ref = Storage.storage().reference().child("\(key)/pic2.jpg")
                    imageData = UIImageJPEGRepresentation(image2, 0.8)!
                    _ = image2Ref.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        guard metadata != nil else
                        {
                            print(error!)
                            return
                        }
                        Storage.storage().reference().child("\(key)/pic2.jpg").downloadURL{url, error in
                            if let error = error
                            {
                                print(error)
                            }
                            else
                            {
                                photo2URL = (url?.absoluteString)!
                                
                                
                                // Photo 3
                                let image3Ref = Storage.storage().reference().child("\(key)/pic3.jpg")
                                imageData = UIImageJPEGRepresentation(image3, 0.8)!
                                _ = image3Ref.putData(imageData, metadata: nil, completion: { (metadata, error) in
                                    guard metadata != nil else
                                    {
                                        print(error!)
                                        return
                                    }
                                    Storage.storage().reference().child("\(key)/pic3.jpg").downloadURL{url, error in
                                        if let error = error
                                        {
                                            print(error)
                                        }
                                        else
                                        {
                                            
                                            
                                            photo3URL = (url?.absoluteString)!
        
        
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "MM/dd/YYYY"
                                            let eventDate = formatter.date(from: date)
                                            formatter.dateFormat = "MMddYYYY"
                                            let dateID = formatter.string(from: eventDate!)
                                            
                                            
                                            // the path for events relies on datetime and a unique key so that
                                            // when returned in a list form, events will already be sorted by date
                                            var path = "Events/" + daytimeString + "/" + key
                                            var ref = Database.database().reference(withPath : path)
                                            
                                            let newEvent = Event(key: key, date: date, name: name, subtitle: subtitle, time: time, address: address, city: city, lat: lat, long: long, state: state, zip: zip, organizer: organizer, url1: photo1URL, url2: photo2URL, url3: photo3URL, location: location, category: category,dateTimeString : daytimeString)
                                            ref.setValue(newEvent.createEvent())
                                            
                                            // rsvp the creator of the event to their event
                                            self.rsvp(personUID: organizer, personName: organizerName, eventUID: key, dateTime: daytimeString, completion: { (success) in
                                                if(success)
                                                {
                                                    completion(true)
                                                }
                                            })
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
    
    // writes event data to the user's event section in the database
    func updateEvents(userUID: String, eventID: String, eventDateTimeString: String,completion:  @escaping(Bool) -> Void)
    {
        let path = "Users/" + userUID + "/Events"
        let ref = Database.database().reference(withPath: path)
        ref.updateChildValues([eventID : eventDateTimeString])
        completion(true)
    }
    
    // creates an event's uniuqe ID and path
    func createNewEvent(name: String, date: String, subtitle: String, time: String, address: String, city : String, lat: Double, long: Double, state: String, zip: String, organizer: String, image1: UIImage, image2: UIImage, image3: UIImage, location : String, category: String, organizerName: String, completion: @escaping (Bool) -> Void)
    {
        var formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dayDate = formatter.date(from: date)
        
        formatter.dateFormat = "hh:mm a"
        let timeDate = formatter.date(from: time)
        
        formatter.dateFormat = "MMddyyyy"
        let dayString = formatter.string(from: dayDate!)
        
        formatter.dateFormat = "HHmm"
        let timeString = formatter.string(from: timeDate!)
        
        let dayTimeString = dayString + timeString
        
        let path = "Events/" + dayTimeString
        var ref = Database.database().reference(withPath: path).childByAutoId()
        
        createEvent(key: ref.key , name: name, date: date, subtitle: subtitle, time: time, address: address, city: city, lat: lat, long: long, state: state, zip: zip, organizer: organizer, image1: image1, image2: image2, image3: image3, location: location, category: category, daytimeString: dayTimeString, organizerName: organizerName) { (success) in
            if(success)
            {
                completion(true)
            }
        }
    }
        
    // RSVP's a person to an event (puts their user ID and name in the event's attending section, then the event's
    // UID and datetiem in their event section)
    func rsvp(personUID : String, personName: String, eventUID: String, dateTime: String, completion: @escaping (Bool) -> Void)
    {
        var path = "Users/" + personUID + "/Events"
        var ref = Database.database().reference(withPath: path)
        ref.updateChildValues([eventUID : dateTime])
        
        path = "Events/" + dateTime + "/" + eventUID + "/Attending/"
        ref = Database.database().reference(withPath: path)
        ref.updateChildValues([personUID : personName])
        
        completion(true)
    }
    
    // returns a dictionary of the users that have RSVP'd to an event
    // listens for changes
    // key is the user's ID, value is their first and last name in one string
    func ObserveAttending(eventUID: String, dateTimeString : String, completion: @escaping (_ list: [String : String]) -> Void)
    {
        var attending = [String : String]()
        let path = "Events/" + dateTimeString + "/" + eventUID + "/Attending"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of : .value, with: {snapshot in
            attending.removeAll()
            for child in snapshot.children
            {
                let person = child as! DataSnapshot
                attending[person.key] = person.value as? String
            }
            completion(attending)
        })
        
    }
    
    // gets the distance (in miles) from a person to an event based on their location data in Firebase
    // rounds to one decimal
    func getDistanceToEvent(eventUID: String, eventDateTimeString : String, userUID: String, completion: @escaping (_ distance : Double) -> Void)
    {
        var meLat = 0.0
        var eventLat = 0.0
        var meLong = 0.0
        var eventLong = 0.0
        
        
        var path = "Users/" + userUID + "/Profile/" + "lastLat"
        var ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.value != nil
            {
                meLat = (snapshot.value as? Double)!
                
                path = "Users/" + userUID + "/Profile/" + "lastLong"
                ref = Database.database().reference(withPath: path)
                ref.observeSingleEvent(of: .value, with: {snapshot in
                    if snapshot.value != nil
                    {
                        meLong = (snapshot.value as? Double)!
                        
                        path = "Events/" + eventDateTimeString + "/" + eventUID + "/Lat"
                        ref = Database.database().reference(withPath: path)
                        ref.observeSingleEvent(of: .value, with: {snapshot in
                            if snapshot.value != nil
                            {
                                eventLat = (snapshot.value as? Double)!
                                
                                 path = "Events/" + eventDateTimeString + "/" + eventUID + "/Long"
                                ref = Database.database().reference(withPath: path)
                                ref.observeSingleEvent(of: .value, with: {snapshot in
                                    if snapshot.value != nil
                                    {
                                        eventLong = (snapshot.value as? Double)!
                                        
                                        let meLoc = CLLocation(latitude: (meLat as? Double)!, longitude: (meLong as? Double)!)
                                        let eventLoc = CLLocation(latitude: (eventLat as? Double)!, longitude: (eventLong as? Double)!)
                                        
                                        var distance = meLoc.distance(from: eventLoc)
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
     // returns a boolean checking whether or not a user is the created a specific event
    // checks if the user ID is the same as the ID listed in the event's Organizer field
    func checkIfUserIsHosting(userUID : String, eventID : String, eventDateTimeID: String, completion : @escaping
        (_ isHosting : Bool) -> Void)
    {
        var isHosting = false
        let path = "Events/" + eventDateTimeID + "/" + eventID + "/Organizer"
        let ref = Database.database().reference(withPath: path)
        ref.observeSingleEvent(of : .value, with: {snapshot in
            if(snapshot.value != nil)
            {
                print(snapshot.value)
                if((snapshot.value) as! String == userUID)
                {
                    isHosting = true
                }
                print(isHosting)
                completion(isHosting)
            }
            
        })
        
    }
}
