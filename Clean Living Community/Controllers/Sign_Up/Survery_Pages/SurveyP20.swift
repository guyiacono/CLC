//
//  SurveyP20.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/28/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import TGPControls
@IBDesignable

class SurveyP20: UIViewController {

    var qAnswer: [Int]?
    
    var email: String?
    var password: String?
    
    
    
    
    
    @IBOutlet weak var q1custom: TGPDiscreteSlider!
    @IBOutlet weak var q2custom: TGPDiscreteSlider!
    @IBOutlet weak var q3custom: TGPDiscreteSlider!
    @IBOutlet weak var q4custom: TGPDiscreteSlider!
    @IBOutlet weak var q5custom: TGPDiscreteSlider!
    
    
    @IBOutlet weak var q1Label: TGPCamelLabels!
    @IBOutlet weak var q2Label: TGPCamelLabels!
    @IBOutlet weak var q3Label: TGPCamelLabels!
    @IBOutlet weak var q4Label: TGPCamelLabels!
    @IBOutlet weak var q5Label: TGPCamelLabels!
    
    
    /*
     @IBOutlet weak var q1: UISlider!
     @IBOutlet weak var q2: UISlider!
     @IBOutlet weak var q3: UISlider!
     @IBOutlet weak var q4: UISlider!
     @IBOutlet weak var q5: UISlider!
     */
    
    @IBAction func endSurvey(_ sender: UIButton)
    {
        qAnswer![95] = Int(q1custom.value)
        qAnswer![96] = Int(q2custom.value)
        qAnswer![97] = Int(q3custom.value)
        qAnswer![98] = Int(q4custom.value)
        qAnswer![99] = Int(q5custom.value)
        performSegue(withIdentifier: "endSurvey", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "endSurvey")
        {
            let destinationVC = segue.destination as! ProfileFinish1
            destinationVC.qArray = qAnswer
            destinationVC.email = email
            destinationVC.password = password
            
            
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        q1Label.names = ["Strongly Disagree", "Disagree", "Neutral", "Agree","Strongly Agree"]
        // let typeString = String(describing: type(of: q1Label.names))
        
        q1Label.upFontSize = 9
        q1Label.downFontSize = 9
        q1custom.ticksListener = q1Label
        
        q2Label.names = ["Strongly Disagree", "Disagree", "Neutral", "Agree","Strongly Agree"]
        q2Label.upFontSize = 9
        q2Label.downFontSize = 9
        q2custom.ticksListener = q2Label
        
        q3Label.names = ["Strongly Disagree", "Disagree", "Neutral", "Agree","Strongly Agree"]
        q3Label.upFontSize = 9
        q3Label.downFontSize = 9
        q3custom.ticksListener = q3Label
        
        q4Label.names = ["Strongly Disagree", "Disagree", "Neutral", "Agree","Strongly Agree"]
        q4Label.upFontSize = 9
        q4Label.downFontSize = 9
        q4custom.ticksListener = q4Label
        
        q5Label.names = ["Strongly Disagree", "Disagree", "Neutral", "Agree","Strongly Agree"]
        q5Label.upFontSize = 9
        q5Label.downFontSize = 9
        q5custom.ticksListener = q5Label
        
        
        
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
