//
//  StrangerProfileViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/9/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class StrangerProfileViewController: UIViewController
{
    var thisUser: User?
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var mainProfileImage: UIImageView!
    
    
    
    @IBAction func moreInfoButton(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toUserProfile", sender: thisUser)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("This user: \(thisUser)")
        name.text = (thisUser?.first)! + " " +  (thisUser?.last)!
        bio.text = thisUser?.bio
        age.text = "Age: " + calculateAge(withDOB: (thisUser?.DOB)!)
        setImageFromURl(stringImageUrl: (thisUser?.url1)!, forImage: mainProfileImage)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toUserProfile")
        {
            let destinationVC = segue.destination as! StrangerProfileInfoViewController
            destinationVC.viewedUser = sender as? User
            
        }
        
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
