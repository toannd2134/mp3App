//
//  SearchViewNavigateBarCell.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/7/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class SearchNavigateCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 1.25
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        label.textColor = UIColor.darkGray
    }
    

    
}
