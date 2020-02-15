//
//  BowlerCell.swift
//  AllOne
//
//  Created by Absoluit on 15/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class BowlerCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var oversLbl: UILabel!
    @IBOutlet weak var maidenLbl: UILabel!
    @IBOutlet weak var runsLbl: UILabel!
    @IBOutlet weak var wicketsLbl: UILabel!
    @IBOutlet weak var economyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
