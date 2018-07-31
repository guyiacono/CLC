//
//  MyProfileSuperViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class MyProfileSuperViewController: UIViewController
{


    @IBOutlet weak var pages: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func save(_ sender: UIBarButtonItem)
    {
        
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl)
    {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
