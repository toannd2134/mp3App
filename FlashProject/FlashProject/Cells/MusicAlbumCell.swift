//
//  MusicAlbumCell.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/9/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class MusicAlbumCell: UICollectionViewCell {
    @IBOutlet weak var albumAvatar: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutSubview()
    }
    
    func layoutSubview(){
        albumAvatar.layer.cornerRadius = 5.0
    }

}
