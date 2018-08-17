//
//  HostEventCategoryTableViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/15/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class HostEventCategoryTableViewController: UITableViewController {

    let categories = ["Arts", "Exercise", "Food", "Hobbies", "Leisure", "Music", "Outdoors", "Travel" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCategoryTableViewCell
        
        // Configure the cell...
        
        cell.nameLabel.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "toEventP1", sender: categories[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toEventP1")
        {
            let destinationVC = segue.destination as! HostEventP1ViewController
            destinationVC.category = sender as? String
        }
    }
}
