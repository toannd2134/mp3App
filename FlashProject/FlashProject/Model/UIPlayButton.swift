//
//  PlayButton.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/7/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

// Custom Play Button
protocol UIPlayButtonDelegate: AnyObject{
    func playButtonTapped()
    func pauseButtonTapped()
}
class UIPlayButton: UIButton {
    private var playButtonImages: [String : UIImage] = [:]
    weak var playButtonDelegate : UIPlayButtonDelegate?

    enum PlayButtonState{
        case play
        case pause
    }
    
    var buttonState: PlayButtonState
    
    func updateButtonByState(state: PlayButtonState){
        switch state{
        case .pause:
            self.buttonState = .pause
            self.setImage(playButtonImages["onPause"], for: .normal)
        case .play:
            self.buttonState = .play
            self.setImage(playButtonImages["onPlay"], for: .normal)
           }
       }
    
    func toggle(){
        switch self.buttonState {
        case .pause:
            self.buttonState = .play
            self.setImage(playButtonImages["onPlay"], for: .normal)
            playButtonDelegate?.playButtonTapped()
        case .play:
            self.buttonState = .pause
            self.setImage(playButtonImages["onPause"], for: .normal)
            playButtonDelegate?.pauseButtonTapped()
        }
    }
    
    init(frame: CGRect , originState: PlayButtonState , playImageName: String, pauseImageName: String) {
        self.buttonState = originState
        playButtonImages["onPause"] = UIImage(named: playImageName)
        playButtonImages["onPlay"] = UIImage(named: pauseImageName)
        super.init(frame: frame)
        self.buttonState == .pause ? self.setImage(UIImage(named: playImageName), for: .normal) : self.setImage(UIImage(named: pauseImageName), for: .normal)
        
        self.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func playButtonTapped(_ sender: UIPlayButton){
        sender.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

