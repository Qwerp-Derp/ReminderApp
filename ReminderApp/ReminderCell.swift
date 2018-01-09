//
//  ReminderCell.swift
//  ReminderApp
//
//  Created by Hanyuan Li on 8/1/18.
//  Copyright © 2018 Qwerp-Derp. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var reminderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
