//
//  UserInfoView.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/13/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class UserInfoView: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmailAddress: UILabel!
    @IBOutlet weak var userID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         userAvatar.layer.cornerRadius = 32.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
