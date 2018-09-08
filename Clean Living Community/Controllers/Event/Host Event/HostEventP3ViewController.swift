//
//  HostEventP3ViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/15/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class HostEventP3ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    var category: String?
    var name: String?
    var date: String?
    var time: String?
    var subtitle: String?
    
    var eventDescription: String?
    
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    
    var currentImageView: UIImageView?

    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextAction(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toEventP4", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "toEventP4")
        {
            var destinationVC = segue.destination as? HostEventP4ViewController
            destinationVC?.category = category
            destinationVC?.name = name
            destinationVC?.date = date
            destinationVC?.time = time
            destinationVC?.subtitle = subtitle
            destinationVC?.eventDescription = eventDescription
            
            destinationVC?.photo1 = photo1.image
            destinationVC?.photo2 = photo2.image
            destinationVC?.photo3 = photo3.image
        }
    }
    
    
    
    
    
    // a button lays on top of a UIImage view, when the button is pressed, start the flow of changing the photo
    // I really don't know how any of this works
    // followed this video https://www.youtube.com/watch?v=v8r_wD_P3B8
    
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
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
