//
//  FindConnectionsInitialViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/11/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class FindConnectionsInitialViewController: UIViewController
{
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    
    
    
    @IBOutlet weak var findConnectionsStart: UIButton!
    
    @IBAction func findConnectionsPushed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toConnectionsTable", sender: filterControl.selectedSegmentIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toConnectionsTable")
        {
            let destinationVC = segue.destination as! ConnectionsTableViewController
            destinationVC.filterIndex = sender! as! Int
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findConnectionsStart.setButtonStyle(content: findConnectionsStart)
        
        filterControl.selectedSegmentIndex = 0
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
