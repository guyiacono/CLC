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

class EventModel
{
    static let sharedInstance = EventModel()
    var events = [Event]()
    
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
                
                //print(dayOfEvent)
                
                
                let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
                //print(Calendar.current.dateComponents(components, from: today, to: dayOfEvent!).day!)
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
                        }
                        eventsList.append(tempdict)
                    }
                }
            }
            completion(eventsList)
        }
        )
    }
    
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
    
    
    func createEvent(key: String, name: String, date: String, subtitle: String, time: String, address: String, city : String, lat: String, long: String, state: String, zip: String, organizer: String, image1: UIImage, image2: UIImage, image3: UIImage, location : String, category: String, daytimeString: String, organizerName: String, completion: @escaping (Bool) -> Void)
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
                                            
                                            
                                            
                                            var path = "Events/" + daytimeString + "/" + key
                                            var ref = Database.database().reference(withPath : path)
                                            
                                            let newEvent = Event(key: key, date: date, name: name, subtitle: subtitle, time: time, address: address, city: city, lat: lat, long: long, state: state, zip: zip, organizer: organizer, url1: photo1URL, url2: photo2URL, url3: photo3URL, location: location, category: category,dateTimeString : daytimeString)
                                            ref.setValue(newEvent.createEvent())
                                            
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
    
    func updateEvents(userUID: String, eventID: String, eventDateTimeString: String,completion:  @escaping(Bool) -> Void)
    {
        let path = "Users/" + userUID + "/Events"
        let ref = Database.database().reference(withPath: path)
        ref.updateChildValues([eventID : eventDateTimeString])
        completion(true)
    }
    

    func createNewEvent(name: String, date: String, subtitle: String, time: String, address: String, city : String, lat: String, long: String, state: String, zip: String, organizer: String, image1: UIImage, image2: UIImage, image3: UIImage, location : String, category: String, organizerName: String, completion: @escaping (Bool) -> Void)
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
        
      
            
        
    
}
