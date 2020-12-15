//
//  CustomButton.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/7/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

// Custom Like Button
protocol UILikeButtonDelegate: AnyObject{
    func likeButtonTapped()
    func unlikeButtonTapped()
}
class UILikeButton: UIButton {
    
    private var likeButtonImages: [String: UIImage] = [:]
    
    weak var likeButtonDelegate : UILikeButtonDelegate?

    enum LikeButtonState{
        case unlike
        case liked
    }
    
    var buttonState: LikeButtonState
    
    func updateButtonByState(state: LikeButtonState){
        switch state{
        case .unlike:
            self.buttonState = .unlike
            self.setImage(likeButtonImages["unlike"], for: .normal)
        case .liked:
            self.buttonState = .liked
            self.setImage(likeButtonImages["liked"], for: .normal)
        }
    }
    
    func toggle(){
        switch self.buttonState {
        case .unlike:
            self.buttonState = .liked
            self.setImage(likeButtonImages["liked"], for: .normal)
            likeButtonDelegate?.likeButtonTapped()
        case .liked:
            self.buttonState = .unlike
            self.setImage(likeButtonImages["unlike"], for: .normal)
            likeButtonDelegate?.unlikeButtonTapped()
        }
    }
    
    init(frame: CGRect , originState: LikeButtonState , unlikeImageName: String, likedImageName: String) {
        self.buttonState = originState
        likeButtonImages["unlike"] = UIImage(named: unlikeImageName)
        likeButtonImages["liked"] = UIImage(named: likedImageName)
        super.init(frame: frame)
        originState == .unlike ? self.setImage(UIImage(named: unlikeImageName), for: .normal) : self.setImage(UIImage(named: likedImageName), for: .normal)
        self.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped(_ sender: UILikeButton){
        sender.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
