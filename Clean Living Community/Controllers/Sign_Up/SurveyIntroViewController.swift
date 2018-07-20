//
//  SurveyIntroViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 5/22/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class SurveyIntroViewController: UIViewController
{
    var email: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toSurveyP1")
        {
            let destinationVC = segue.destination as! SurveyFinal
            destinationVC.email = email
            destinationVC.password = password
            
            
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func startSurvey(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toSurveyP1", sender: self)
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
