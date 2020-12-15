//
//  Artist_Album_detailView.swift
//  FlashProject
//
//  Created by Techmaster on 7/31/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit
class Artist_Album_detailView: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var likeButtonFrame: UIView!
    let likeButton = UILikeButton(frame: .zero, originState: .unlike, unlikeImageName: "icons8-whiteheart-32", likedImageName: "icons8-redheart-50")
    var playButtonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.playButton.layer.cornerRadius = 20.0
        avatar.layer.masksToBounds = false
        avatar.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        avatar.layer.shadowOpacity = 0.5
        avatar.layer.shadowRadius = 10.0
        avatar.layer.cornerRadius = 10.0
        self.likeButtonFrame.layer.cornerRadius = 25.0
        likeButtonFrame.addSubview(likeButton)
        layoutLikeButton()
    }
    
    func layoutLikeButton(){
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: self.likeButtonFrame.centerXAnchor).isActive = true
        likeButton.centerYAnchor.constraint(equalTo: self.likeButtonFrame.centerYAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func playTracksTapped(_ sender: UIButton) {
        if let playButtonAction = self.playButtonAction{
            playButtonAction()
        }
    }
}
