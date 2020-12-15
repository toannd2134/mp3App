//
//  SearchResultCell.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/6/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class TrackSearchResultCell: UITableViewCell {
    let cellType = "track"
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var track_title: UILabel!
    @IBOutlet weak var artist_album: UILabel!
    @IBOutlet weak var stackView: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        layoutSubview()
    }
    
    func layoutSubview(){
        //layout avatar
        avatar.layer.cornerRadius = 4.0
        
    }
}
