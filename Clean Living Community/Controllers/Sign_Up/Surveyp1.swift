//
//  Surveyp1.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 5/22/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

// ignore this class, it isn't used

import UIKit
import TGPControls
@IBDesignable

class Surveyp1: UIViewController {

    @IBOutlet weak var q1: UISlider!
    @IBOutlet weak var q2: UISlider!
    @IBOutlet weak var q3: UISlider!
    @IBOutlet weak var q4: UISlider!
    @IBOutlet weak var q5: UISlider!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
