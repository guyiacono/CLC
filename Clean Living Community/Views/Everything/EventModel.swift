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
    
    func createEvent(key: String, name: String, date: String, subtitle: String, time: String, address: String, city : String, lat: String, long: String, state: String, zip: String, organizer: String, image1: UIImage, image2: UIImage, image3: UIImage, completion: @escaping (Bool) -> Void)
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
                                            
                                            
                                            let path = "Events/" + (dateID)
                                            let ref = Database.database().reference(withPath : path)
                                            
                                            let newEvent = Event(key: key, date: date, name: name, subtitle: subtitle, time: time, address: address, city: city, lat: lat, long: long, state: state, zip: zip, organizer: organizer, url1: photo1URL, url2: photo2URL, url3: photo3URL)
                                            ref.setValue(newEvent.createEvent())
                                            
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
    

        
        
        
        
        
        
        
      
            
        
    
}
