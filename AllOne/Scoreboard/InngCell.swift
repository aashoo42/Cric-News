//
//  InngCell.swift
//  AllOne
//
//  Created by Absoluit on 15/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class InngCell: UICollectionViewCell {
    
    @IBOutlet weak var inngLbl: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = frame.height/2
        self.layer.masksToBounds = true
    }
}
