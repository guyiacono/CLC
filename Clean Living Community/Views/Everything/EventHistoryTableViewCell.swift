//
//  EventHistoryTableViewCell.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 8/17/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import UIKit

class EventHistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
