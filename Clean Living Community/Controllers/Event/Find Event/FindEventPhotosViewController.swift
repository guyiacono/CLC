//
//  FindEventPhotosViewController.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/16/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class FindEventPhotosViewController: UIViewController
{
    var thisEvent = [String : String]()

    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageFromURl(stringImageUrl: thisEvent["Photo1"]!, forImage: mainPhoto)
        setImageFromURl(stringImageUrl: thisEvent["Photo2"]!, forImage: photo2)
        setImageFromURl(stringImageUrl: thisEvent["Photo3"]!, forImage: photo3)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
