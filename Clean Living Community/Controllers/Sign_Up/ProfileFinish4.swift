//
//  ProfileFinish4.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/17/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileFinish4: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    var usermodel = UserModel.sharedInstance
    
    var email: String?
    var password: String?
    
    var fname: String?
    var lname: String?
    var dob: String?
    var home: String?
    var dor: String?
    var qAnswer: [Int]?
    
    var edu: String?
    var rel: String?
    var ori: String?
    var reli: String?
    var spt: String?
    var smk: String?
    var sup: String?
    
    var bio: String?
    
    @IBOutlet weak var profileImage1: UIImageView!
    let profileImage2 = UIImage(named: "No Photo.png")
    let profileImage3 = UIImage(named: "No Photo.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       finish.isEnabled = true
        
        profileImage1.layer.masksToBounds = true
        profileImage1.clipsToBounds = true
        profileImage1.layer.cornerRadius = profileImage1.frame.height/2
        
       
       
 
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var photoButton: UIButton!
    
    @IBAction func photoChanged(_ sender: UIButton)
    {
        print("button Pushed")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true)
    }
    
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
             profileImage1.image = image
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toProfileFinish5")
        {
            let destinationVC = segue.destination as! ProfileFinish5
            destinationVC.qAnswer = qAnswer
            destinationVC.email = email
            destinationVC.password = password
            destinationVC.fname = fname
            destinationVC.lname = lname
            destinationVC.dob = dob
            destinationVC.home = home
            destinationVC.dor = dor
            
            destinationVC.edu = edu
            destinationVC.rel = rel
            destinationVC.reli = reli
            destinationVC.ori = ori
            destinationVC.spt = spt
            destinationVC.smk = smk
            destinationVC.sup = sup
            
            destinationVC.bio = bio
            
            destinationVC.profileImage1 = profileImage1.image
            destinationVC.profileImage2 = profileImage2
            destinationVC.profileImage3 = profileImage3
            print("destination ready")
        }
    }
    @IBOutlet weak var finish: UIButton!
    @IBAction func finishSurvey(_ sender: UIButton)
    {
        finish.isEnabled = false
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/YYYY"
        let today = Date()
        let recoveryDate = dateformatter.date(from: dor!)
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        print(Calendar.current.dateComponents(components, from: today, to: recoveryDate!).year!)
        if(Calendar.current.dateComponents(components, from: today, to: recoveryDate!).year! * -1 <= 3)
        {
            usermodel.registerUser(withEmail: email!, withPassword: password!, withFirst: fname!, withLast: lname!, withDOB: dob!, withTown: home!, withEdu: edu!, withOrientation: ori!, withRecovery: dor!, withRomance: rel!, withReligion: reli!, withSpiritual: spt!, isSmoke: smk!, attendSupport: sup!, withOpt1: "No", withOpt2: "Yes", withBio: bio!, withImage1: profileImage1.image!, withImage2: profileImage2!, withImage3: profileImage3!, withQuestionair: qAnswer!, completion: {(success)
                in
                if (success)
                {
                    Auth.auth().signIn(withEmail: self.email!, password: self.password!)
                    {user, error in
                        if error == nil && user != nil
                        {
                            print("should sign in immediately")
                            self.performSegue(withIdentifier: "noMentorSegue", sender: ProfileFinish4.self)
                        }
                        else
                        {
                            print("authentication failed")
                            self.performSegue(withIdentifier: "toSignIn", sender: ProfileFinish4.self)
                        }
                    }
                }
                else
                {
                   print("failed to register")
                   self.finish.isEnabled = true
                }
            })
        }
        else
        {
            performSegue(withIdentifier: "toProfileFinish5", sender: self)
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
