//
//  MyProfileSuperViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class MyProfileSuperViewController: UIViewController, firstDelegate, personalDelegate, photoDelegate, bioDelegate, preferenceDelegate
{

    var first : String?
    var last: String?
    var DOB : String?
    var hometown: String?
    var DOR : String?
    
    var edu : String?
    var rel : String?
    var religion: String?
    var spt : String?
    var smoke : String?
    var ori : String?
    var sup : String?
    
    var photo1 : UIImage?
    var photo2 : UIImage?
    var photo3 : UIImage?
    
    var bio : String?
    
    var pref1 : String?
    var pref2 : String?
    
    @IBOutlet weak var pages: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func save(_ sender: UIBarButtonItem)
    {
        self.view.endEditing(true)
        print(checkIfAllInfoPresent())
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl)
    {
        self.view.endEditing(true)
        switch pages.selectedSegmentIndex
        {
        case 0:
            basicInfo.isHidden = false
            personalInfo.isHidden = true
            biography.isHidden = true
            Profilephoto.isHidden = true
            settings.isHidden = true

        case 1:
            basicInfo.isHidden = true
            personalInfo.isHidden = false
            biography.isHidden = true
            Profilephoto.isHidden = true
            settings.isHidden = true

        case 2:
            basicInfo.isHidden = true
            personalInfo.isHidden = true
            biography.isHidden = false
            Profilephoto.isHidden = true
            settings.isHidden = true

        case 3:
            basicInfo.isHidden = true
            personalInfo.isHidden = true
            biography.isHidden = true
            Profilephoto.isHidden = false
            settings.isHidden = true
        case 4:
            basicInfo.isHidden = true
            personalInfo.isHidden = true
            biography.isHidden = true
            Profilephoto.isHidden = true
            settings.isHidden = false
        default:
         break
        }
    }
    
    @IBOutlet weak var basicInfo: UIView!
    @IBOutlet weak var personalInfo: UIView!
    @IBOutlet weak var biography: UIView!
    @IBOutlet weak var Profilephoto: UIView!
    @IBOutlet weak var settings: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicInfo.isHidden = false
        personalInfo.isHidden = true
        biography.isHidden = true
        Profilephoto.isHidden = true
        settings.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func returnFirst(basicInfo: [String : String])
    {
        first = basicInfo["first"]
        last = basicInfo["last"]
        DOB = basicInfo["DOB"]
        hometown = basicInfo["hometown"]
        DOR = basicInfo["DOR"]
    }
    func returnPersonal(personalInfo: [String : String])
    {
        edu = personalInfo["edu"]
        rel = personalInfo["rel"]
        religion = personalInfo["religion"]
        spt = personalInfo["spt"]
        smoke = personalInfo["smoke"]
        ori = personalInfo["ori"]
        sup = personalInfo["sup"]
    }

    func returnPhotos(photos: [String : UIImage])
    {
        photo1 = photos["photo1"]
        photo2 = photos["photo2"]
        photo3 = photos["photo3"]

    }
    func returnBio(bio: String)
    {
        self.bio = bio
    }
    func returnPref(prefInfo: [String : String])
    {
        self.pref1 = prefInfo["pref1"]
        self.pref2 = prefInfo["pref2"]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? MyProfileBasicInfoViewController, segue.identifier == "basicSegue"
        {
            viewController.firstDelegate = self
        }
            
        else if let viewController = segue.destination as? PersonalInfoProfileChange, segue.identifier == "personalSegue"
        {
            viewController.personalDelegate = self
        }
        else if let viewController = segue.destination as? MyProfilePhotosViewController, segue.identifier == "photoSegue"
        {
            viewController.photoDelegate = self
        }
        else if let viewController = segue.destination as? MyProfileBiographyViewController, segue.identifier == "bioSegue"
        {
            viewController.bioDelegate = self
        }
        else if let viewController = segue.destination as? MyProfilePreferencesViewController, segue.identifier == "settingsSegue"
        {
            viewController.prefDelegate = self
        }
 
    }
    func checkIfAllInfoPresent() -> Bool
    {
        if(first != nil && last != nil && hometown != nil && DOB != nil && DOR != nil && edu != nil && rel != nil && religion != nil && spt != nil && smoke != nil && ori != nil && sup != nil && photo1 != nil && photo2 != nil && photo3 != nil && bio != nil && pref1 != nil && pref2 != nil)
        {
            print(first)
            print(last)
            print(hometown)
            print(DOB)
            print(DOR)
            print(edu)
            print(rel)
            print(religion)
            print(spt)
            print(smoke)
            print(ori)
            print(sup)
            print(photo1)
            print(photo2)
            print(photo3)
            print(bio)
            print(pref1)
            print(pref2)
            return true
        }
        else
        {
            print(first)
            print(last)
            print(hometown)
            print(DOB)
            print(DOR)
            print(edu)
            print(rel)
            print(religion)
            print(spt)
            print(smoke)
            print(ori)
            print(sup)
            print(photo1)
            print(photo2)
            print(photo3)
            print(bio)
            print(pref1)
            print(pref2)
            return false
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
