//
//  StrangerProfileInfoViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/10/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRadiusBorder(content: UIImageView) {
        content.layer.masksToBounds = true
        content.clipsToBounds = true
        content.layer.cornerRadius = content.frame.height/2
        content.layer.borderColor = UIColor(red:0.13, green:0.89, blue:0.73, alpha:1.0).cgColor
        content.layer.borderWidth = 2.0
    }
}

class StrangerProfileInfoViewController: UIViewController
{
    var viewedUser: User?
    // populate the fields with the user's profile data
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
        
        photo1.setRadiusBorder(content: photo1)
        photo2.setRadiusBorder(content: photo2)
        photo2.setRadiusBorder(content: photo3)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calculateAge(withDOB DOB: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/YYYY"
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
