//
//  EventMapViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/19/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    // list of all events for a certain cateogry
    var listOfEvents = [[String : String]]()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // for each event
        for event in listOfEvents
        {
            // create a point with all the nessessary information to display it in the correct place and
            // reference the corresponding event
            let temp = MyPointAnnotation(pinTitle: event["Event Name"]!, pinLat: event["Lat"]!, pinLong: event["Long"]!, pinSubtitle: "", pinID: event["key"]!, pinDate: event["DateTimeString"]!)
            print(temp.ID)
            print(temp.dateTime)
            // add the point to the map
            map.addAnnotation(temp)
        }
        self.map.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    // get the user's location and zoom in on that
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    
    var selectedAnnotation: MyPointAnnotation?
    
    // segue to the corresponding event's details when a pin is selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        selectedAnnotation = view.annotation as? MyPointAnnotation
        performSegue(withIdentifier: "mapToDetail", sender: selectedAnnotation)
    }
    
    private let reuseIdentifier = "MyIdentifier"
    
    // for each pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation { return nil }
        
        // give it a reuse identifier
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        // allow it to callout
        annotationView.canShowCallout = true
        // set its image
        annotationView.image = UIImage(named: "pin")
        return annotationView
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "mapToDetail"
        {
            let destinationVC = segue.destination as! EventDetailViewController
            let thing = sender as! MyPointAnnotation
            destinationVC.dateTimeString = thing.dateTime
            destinationVC.eventID = thing.ID
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
class MyPointAnnotation : NSObject, MKAnnotation
{
    var coordinate : CLLocationCoordinate2D
    var title  : String?
    var subtitle: String?
    var ID: String?
    var dateTime: String?
    
    
    init(pinTitle : String, pinLat: String, pinLong: String, pinSubtitle: String, pinID : String, pinDate : String)
    {
        coordinate = CLLocationCoordinate2D.init(latitude: Double(pinLat)!, longitude: Double(pinLong)!)
        title = pinTitle
        subtitle = pinSubtitle
        ID = pinID
        dateTime = pinDate
    }
}
