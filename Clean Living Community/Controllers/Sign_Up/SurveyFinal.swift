//
//  SurveyFinal.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 5/24/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import TGPControls
@IBDesignable



class SurveyFinal: UIViewController {
    
    
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
        performSegue(withIdentifier: "endSurvey", sender: self)
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
    @IBAction func q2changed(_ sender: UISlider) {
        q2.value = roundf(q2.value)
    }
    @IBAction func q1changed(_ sender: UISlider) {
        q1.value = roundf(q1.value)
    }
    @IBAction func q3changed(_ sender: UISlider) {
        q3.value = roundf(q3.value)
    }
    @IBAction func q4changed(_ sender: UISlider) {
        q4.value = roundf(q4.value)
    }
    @IBAction func q5changed(_ sender: UISlider) {
        q5.value = roundf(q5.value)
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
