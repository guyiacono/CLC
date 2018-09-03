//
//  MyProfilePhotosViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 7/10/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol photoDelegate
{
    func returnPhotos(photos: [String : UIImage])
}

class MyProfilePhotosViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
 
    let currentUserID = Auth.auth().currentUser?.uid
    var userModel = UserModel.sharedInstance
    var displayedUser: User!
    
    var photoDelegate : photoDelegate?
    var tempDict = [String:UIImage]()

    var currentImageView: UIImageView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayedUser = userModel.findUser(uid: currentUserID!)
        userModel.returnUserObject(UID: currentUserID!) { (user) in
            self.displayedUser = user
            
            self.setImageFromURl(stringImageUrl: self.displayedUser.url1!, forImage: self.photo1)
            self.setImageFromURl(stringImageUrl: self.displayedUser.url2!, forImage: self.photo2)
            self.setImageFromURl(stringImageUrl: self.displayedUser.url3!, forImage: self.photo3)
            
            if(self.photoDelegate != nil)
            {
                self.tempDict["photo1"] = self.photo1.image
                self.tempDict["photo2"] = self.photo2.image
                self.tempDict["photo3"] = self.photo3.image
                self.photoDelegate?.returnPhotos(photos: self.tempDict)

            }
        }
        

        photo1.setRadiusBorder(content: photo1)
        photo2.setRadiusBorder(content: photo2)
        photo3.setRadiusBorder(content: photo3)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBAction func buttonPhoto1(_ sender: UIButton)
    {
        self.currentImageView = self.photo1
        
        let image1 = UIImagePickerController()
        image1.delegate = self
        image1.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image1.allowsEditing = true
        self.present(image1, animated: true)
    }
    @IBOutlet weak var button2: UIButton!
    @IBAction func buttonPhoto2(_ sender: UIButton)
    {
        self.currentImageView = self.photo2
        
        let image2 = UIImagePickerController()
        image2.delegate = self
        image2.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image2.allowsEditing = true
        self.present(image2, animated: true)

    }
    @IBOutlet weak var button3: UIButton!
    @IBAction func buttonPhoto3(_ sender: UIButton)
    {
        self.currentImageView = self.photo3
        let image3 = UIImagePickerController()
        image3.delegate = self
        image3.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image3.allowsEditing = true
        self.present(image3, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image1 = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.currentImageView?.image = image1
        }
        if(currentImageView == photo1)
        {
            tempDict["photo1"] = photo1.image
            photoDelegate?.returnPhotos(photos: tempDict)
        }
        else if(currentImageView == photo2)
        {
            tempDict["photo2"] = photo2.image
            photoDelegate?.returnPhotos(photos: tempDict)
        }
        else if (currentImageView == photo3)
        {
            tempDict["photo3"] = photo3.image
            photoDelegate?.returnPhotos(photos: tempDict)
        }

        self.dismiss(animated: true, completion: nil)
        
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
