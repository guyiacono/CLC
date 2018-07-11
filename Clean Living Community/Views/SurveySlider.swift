//
//  SurveySlider.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 5/29/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class SurveySlider: UISlider
{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var thumbimage: UIImage?
    {
        didSet {
            setThumbImage(#imageLiteral(resourceName: "Leaf-Slider"), for: .normal)
        }
        
    }
    
}
