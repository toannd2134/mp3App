//
//  ArtistSearchResultCell.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/7/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class ArtistSearchResultCell: UITableViewCell {
    let cellType = "artist"
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var artistname: UILabel!
    @IBOutlet weak var numberOfFans: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        layoutLikeButton()
    }
    
    func layoutLikeButton(){
        //layout avatar
        avatar.layer.cornerRadius = 30.0
    }
}
