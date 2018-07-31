//
//  ConnectionsTableViewCell.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/5/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class ConnectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var datalabel: UILabel!
    
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
