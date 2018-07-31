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
    
    @IBOutlet weak var Connect: UIButton!
    @IBOutlet weak var Message: UIButton!
    @IBOutlet weak var MoreInfo: UIButton!
    
    
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
        age.text = calculateAge(withDOB: (thisUser?.DOB)!)
        setImageFromURl(stringImageUrl: (thisUser?.url1)!, forImage: mainProfileImage)
        
        mainProfileImage.layer.masksToBounds = true
        mainProfileImage.clipsToBounds = true
        mainProfileImage.layer.cornerRadius = mainProfileImage.frame.height/2
        mainProfileImage.layer.borderColor = UIColor(red:0.13, green:0.89, blue:0.73, alpha:1.0).cgColor
        mainProfileImage.layer.borderWidth = 2.0
        
        Connect.layer.cornerRadius = 15.0
        Message.layer.cornerRadius = 15.0
        MoreInfo.layer.cornerRadius = 15.0
        
        
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
