//
//  ConnectionWithNoMessageTableViewCell.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/8/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class ConnectionWithNoMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
