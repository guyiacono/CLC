//
//  ProfileFinish5.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/17/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

class ProfileFinish5: UIViewController, CLLocationManagerDelegate
{
    var usermodel = UserModel.sharedInstance
    
    var email: String?
    var password: String?
    
    var fname: String?
    var lname: String?
    var dob: String?
    var home: String?
    var dor: String?
    var qAnswer: [Int]?
    
    var edu: String?
    var rel: String?
    var ori: String?
    var reli: String?
    var spt: String?
    var smk: String?
    var sup: String?
    
    var bio: String?
    
    var pref1: String?

    var profileImage1: UIImage?
    var profileImage2: UIImage?
    var profileImage3: UIImage?
    
    let manager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self

        pref1Option.layer.cornerRadius = 7
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var pref1Option: UISegmentedControl!
    
    @IBOutlet weak var createButton: UIButton!
    @IBAction func createProfile(_ sender: UIButton)
    {
        createButton.isEnabled = false
        if(CLLocationManager.locationServicesEnabled())
        {
            manager.requestLocation()
        }
        else
        {
            createAlert(title: "Location Services", message: "The Clean Living Community requires Location Services to be enabled when creating a profile. This location is used to find nearby connections and events. Please go into Settings -> Privacy -> Location Services to enable")
            createButton.isEnabled = true
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            print("Found user's location: \(location)")
            signUp(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        print("failed to find location")
        createAlert(title: "Location Services", message: "Failed to find location or Location Services is disabled for this application. The Clean Living Community requires Location Services to be enabled when creating a profile. This location is used to find nearby connections and events. Please check your location settings in Settings -> Privacy -> Location Services or try again in a different location")
        createButton.isEnabled = true

    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func signUp(latitude: Double, longitude: Double)
    {
        if(pref1Option.selectedSegmentIndex == 0)
        {
            pref1 = "Yes"
        }
        else
        {
            pref1 = "No"
        }
        
        usermodel.registerUser(withEmail: email!, withPassword: password!, withFirst: fname!, withLast: lname!, withDOB: dob!, withTown: home!, withEdu: edu!, withOrientation: ori!, withRecovery: dor!, withRomance: rel!, withReligion: reli!, withSpiritual: spt!, isSmoke: smk!, attendSupport: sup!, withOpt1: pref1!, withOpt2: "Yes", withBio: bio!, withImage1: profileImage1!, withImage2: profileImage2!, withImage3: profileImage3!, withQuestionair: qAnswer!, withLat: latitude, withLong: longitude, completion: {(success)
            in
            if (success)
            {
                Auth.auth().signIn(withEmail: self.email!, password: self.password!)
                {user, error in
                    if error == nil && user != nil
                    {
                        print("authentication successful")
                        self.performSegue(withIdentifier: "toNewProfile", sender: ProfileFinish5.self)
                    }
                    else
                    {
                        print("authentication failed")
                        self.performSegue(withIdentifier: "toSignIn", sender: ProfileFinish5.self)
                    }
                }
            }
            else
            {
                self.createButton.isEnabled = true
            }
        })
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
