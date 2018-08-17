//
//  PeopleGoingTableViewCell.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/17/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class PeopleGoingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var host: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
