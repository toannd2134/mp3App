//
//  RecentlyPlayedCell.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/7/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class RecentlyPlayedCell: UICollectionViewCell {

    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutSubView()
    }
    func layoutSubView(){
        //layout avatar
        contentView.layer.cornerRadius = 5.0
        avatar.layer.cornerRadius = 5.0
    }
}
