//
//  NewsCell.swift
//  AllOne
//
//  Created by Absoluit on 16/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var seeAllBtn: UIButton!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var detailsLbl: UILabel!
    
    @IBOutlet weak var detailsView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        parentView.layer.cornerRadius = 13.0
        parentView.layer.shadowColor = UIColor.lightGray.cgColor
        parentView.layer.shadowOpacity = 0.5
        parentView.layer.shadowRadius = 5.0
        parentView.layer.shadowOffset = .zero
        parentView.layer.shadowPath = UIBezierPath(rect: parentView.bounds).cgPath

        
        innerView.layer.cornerRadius = 13.0
        innerView.layer.masksToBounds = true
        innerView.layer.borderWidth = 0.5
        innerView.layer.borderColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
