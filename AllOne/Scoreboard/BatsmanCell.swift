//
//  BatsmanCell.swift
//  AllOne
//
//  Created by Absoluit on 09/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class BatsmanCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var runsLbl: UILabel!
    @IBOutlet weak var ballsLbl: UILabel!
    @IBOutlet weak var foursLbl: UILabel!
    @IBOutlet weak var sixsLbl: UILabel!
    @IBOutlet weak var strikeRateLbl: UILabel!
    @IBOutlet weak var outLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
