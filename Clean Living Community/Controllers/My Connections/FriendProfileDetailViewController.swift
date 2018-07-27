//
//  FriendProfileDetailViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/26/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class FriendProfileDetailViewController: UIViewController
{
    var viewedUser: User?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var education: UILabel!
    @IBOutlet weak var relation: UILabel!
    @IBOutlet weak var orientation: UILabel!
    @IBOutlet weak var religious: UILabel!
    @IBOutlet weak var spiritual: UILabel!
    @IBOutlet weak var smokes: UILabel!
    @IBOutlet weak var support: UILabel!
    @IBOutlet weak var recovery: UILabel!
    
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        name.text = "Name: " + (viewedUser?.first)! + " " + (viewedUser?.last)!
        age.text = "Age: " + calculateAge(withDOB: (viewedUser?.DOB)!)
        education.text = "Education: " + (viewedUser?.education)!
        relation.text = "Relationship Status: " + (viewedUser?.relationship)!
        orientation.text = "Sexual Orientation: " + (viewedUser?.orientation)!
        religious.text = "Religious: " + (viewedUser?.religious)!
        spiritual.text = "Spiritual: " + (viewedUser?.spiritual)!
        smokes.text = "Smokes: " + (viewedUser?.smoker)!
        support.text = "Attends Support Groups: " + (viewedUser?.support)!
        recovery.text = "Recovery Date: " + (viewedUser?.recoveryDate)!
        setImageFromURl(stringImageUrl: (viewedUser?.url1)!, forImage: photo1)
        setImageFromURl(stringImageUrl: (viewedUser?.url2)!, forImage: photo2)
        setImageFromURl(stringImageUrl: (viewedUser?.url3)!, forImage: photo3)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateAge(withDOB DOB: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YYYY"
        let dateRangeStart = formatter.date(from: DOB)
        let dateRangeEnd = Date()
        let components = Calendar.current.dateComponents([.year], from: dateRangeStart!, to: dateRangeEnd)
        return (String(components.year!))
    }
    
    func setImageFromURl(stringImageUrl url: String, forImage image: UIImageView)
    {
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                image.image = UIImage(data: data as Data)
            }
        }
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
