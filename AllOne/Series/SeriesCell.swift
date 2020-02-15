//
//  SeriesCell.swift
//  AllOne
//
//  Created by Absoluit on 08/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class SeriesCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var firstTeamImg: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var firstTeamTotal: UILabel!
    @IBOutlet weak var firstTeamOvers: UILabel!
    
    @IBOutlet weak var secondTeamImg: UIImageView!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamTotal: UILabel!
    @IBOutlet weak var secondTeamOvers: UILabel!
    
    @IBOutlet weak var resultLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        parentView.layer.masksToBounds = true
        parentView.layer.cornerRadius = 10.0
        
        firstTeamImg.layer.masksToBounds = true
        firstTeamImg.layer.borderWidth = 0.5
        firstTeamImg.layer.borderColor = UIColor.lightGray.cgColor
        
        secondTeamImg.layer.masksToBounds = true
        secondTeamImg.layer.borderWidth = 0.5
        secondTeamImg.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
