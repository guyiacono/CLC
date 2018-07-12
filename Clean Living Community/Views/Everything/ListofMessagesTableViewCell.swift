//
//  ListofMessagesTableViewCell.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/4/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class ListofMessagesTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var preview: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cellview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
