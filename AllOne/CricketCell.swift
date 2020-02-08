//
//  CricketCell.swift
//  AllOne
//
//  Created by Absoluit on 07/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class CricketCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!

    @IBOutlet weak var seriesTitleLbl: UILabel!
    @IBOutlet weak var seeAllBtn: UIButton!
    
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
        
//        let shadowSize : CGFloat = 5.0
//        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
//                                                   y: -shadowSize / 2,
//                                                   width: (self.parentView.frame.size.width + shadowSize)*deviceRatio,
//                                                   height: (self.parentView.frame.size.height + shadowSize)*deviceRatio))
//
//        parentView.layer.shadowColor = UIColor.black.cgColor
//        parentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        parentView.layer.shadowOpacity = 0.2
//        parentView.layer.shadowPath = shadowPath.cgPath

        parentView.layer.masksToBounds = true
        parentView.layer.cornerRadius = 10.0
//        parentView.layer.borderWidth = 0.5
//        parentView.layer.borderColor = UIColor.lightGray.cgColor
        
        
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
