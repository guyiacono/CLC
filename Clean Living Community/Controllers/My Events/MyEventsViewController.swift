//
//  MyEventsViewController.swift
//  Pods-Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//

import UIKit

class MyEventsViewController: UIViewController
{
    
    @IBOutlet weak var typeofevent: UISegmentedControl!
    
    @IBAction func typechanged(_ sender: UISegmentedControl)
    {
        switch typeofevent.selectedSegmentIndex{
        case 0:
            attendingEvents.isHidden = false
            hostingEvents.isHidden = true
        case 1:
            attendingEvents.isHidden = true
            hostingEvents.isHidden = false
        default:
            break
        }
    }
    
    @IBOutlet weak var attendingEvents: UIView!
    @IBOutlet weak var hostingEvents: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendingEvents.isHidden = true
        hostingEvents.isHidden = false
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
