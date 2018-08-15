//
//  EventsViewController.swift
//  Clean Living Community
//
//  Created by Tim Hilton on 8/8/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

extension UIButton {
    func setButtonStyle(content: UIButton) {
        content.layer.masksToBounds = true
        content.clipsToBounds = true
        content.layer.cornerRadius = content.frame.height/2
    }
}

class EventsViewController: UIViewController {
    @IBOutlet weak var findEvent: UIButton!
    @IBOutlet weak var hostEvent: UIButton!
    
    @IBAction func findAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toFindCategory", sender: self)
    }
    
    @IBAction func hostAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toHostCategory", sender: self)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        findEvent.setButtonStyle(content: findEvent)
        hostEvent.setButtonStyle(content: hostEvent)
        
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
