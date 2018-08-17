//
//  FindEventsTableViewCell.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 6/13/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class FindEventsTableViewCell: UITableViewCell {

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var organization: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
