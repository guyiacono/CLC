//
//  FindEventsNewViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/19/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class FindEventsNewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTable.dataSource = self
        eventTable.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var eventTable: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell = eventTable.dequeueReusableCell(withIdentifier: "foundEventCell", for: indexPath) as! FindEventsTableViewCell
        return cell
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
