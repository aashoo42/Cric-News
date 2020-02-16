//
//  CommOverCell.swift
//  AllOne
//
//  Created by Absoluit on 15/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class CommOverCell: UITableViewCell {

    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var runsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        runsLbl.layer.cornerRadius = 10.0
        runsLbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
