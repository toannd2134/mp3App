//
//  TarBarViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/7/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit
import AVFoundation
class TabBarViewController: UITabBarController{
    
    let minimizeMusicPlayerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        return view
    }()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    let trackName: UILabel = {
        let track = UILabel()
        track.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        track.text = "Track title"
        track.textColor = .white
        return track
    }()
    let artistName: UILabel = {
        let artist = UILabel()
        artist.textColor = .white
        artist.text = "Artist"
        return artist
    }()
    let cancelButton : UIButton = {
        let cancel = UIButton()
        cancel.setImage(UIImage(named: "icons8-cancel-32"), for: .normal)
        return cancel
    }()
    let progressBar: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .white
        progress.trackTintColor = .purple
        progress.progress = 0.5
        return progress
    }()
    let playButton = UIPlayButton(frame: .zero, originState: .pause, playImageName: "icons8-play-white-50", pauseImageName: "icons8-pause-white-50")
    
    unowned let commander = MusicPlayer.shared
    var musicPlayerVC: MusicPlayerViewController!
    var updateUI = Timer()
    
    override func loadView() {
        super.loadView()
        musicPlayerVC = storyboard?.instantiateViewController(withIdentifier: "MusicPlayerViewController") as? MusicPlayerViewController
        musicPlayerVC.loadView()
        musicPlayerVC.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        layoutMinimizeMusicView()
        addTargetForMiniViewButtons()
    }
    
    //update UI base on Music Player status
    @objc func updateUIfrequently(){
        DispatchQueue.main.async {
            self.progressBar.progress = self.commander.progress
        }
    }
    
    func layoutMinimizeMusicView(){
        // layout minimize music player view
        view.addSubview(minimizeMusicPlayerView)
        minimizeMusicPlayerView.translatesAutoresizingMaskIntoConstraints = false
        minimizeMusicPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -49).isActive = true
        minimizeMusicPlayerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        minimizeMusicPlayerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        minimizeMusicPlayerView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        view.sendSubviewToBack(minimizeMusicPlayerView)
        
        //layout play button
        minimizeMusicPlayerView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.centerYAnchor.constraint(equalTo: minimizeMusicPlayerView.centerYAnchor).isActive = true
        playButton.leadingAnchor.constraint(equalTo: minimizeMusicPlayerView.leadingAnchor, constant: 10).isActive = true
        playButton.playButtonDelegate = self
        
        //layout stack view
        minimizeMusicPlayerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 10).isActive = true
        stackView.centerYAnchor.constraint(equalTo: minimizeMusicPlayerView.centerYAnchor).isActive = true
        stackView.addArrangedSubview(trackName)
        stackView.addArrangedSubview(artistName)
        
        //layout cancel button
        minimizeMusicPlayerView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: minimizeMusicPlayerView.trailingAnchor, constant: -10).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: minimizeMusicPlayerView.centerYAnchor).isActive = true
        cancelButton.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 10).isActive = true
        
        //layout progress view
        minimizeMusicPlayerView.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.leadingAnchor.constraint(equalTo: minimizeMusicPlayerView.leadingAnchor).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: minimizeMusicPlayerView.trailingAnchor).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: minimizeMusicPlayerView.bottomAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func addTargetForMiniViewButtons(){
        //add target action for cancel button
        cancelButton.addTarget(self, action: #selector(cancelButtonMiniMusicViewTapped(_:)), for: .touchUpInside)
        //add target action for minimize music view
        minimizeMusicPlayerView.isUserInteractionEnabled = true
        let minimizeMusicViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(minimizeMusicViewTapped(_:)))
        minimizeMusicPlayerView.addGestureRecognizer(minimizeMusicViewTapGesture)
    }
    
    // cancel button tap response
    @objc func cancelButtonMiniMusicViewTapped(_ sender: UIButton){
        commander.cancel()
        UIView.animate(withDuration: 2) {
            [weak self] () -> Void in
            guard let strongSelf = self else {return}
            strongSelf.view.sendSubviewToBack(strongSelf.minimizeMusicPlayerView)
        }
    }
    //minimize music view tapped
    @objc func minimizeMusicViewTapped(_ sender: UIView){
        self.musicPlayerVC.modalPresentationStyle = .fullScreen
        present(self.musicPlayerVC, animated: true, completion: nil)
    }
    
    //add Observer
    func addObserver(){
        let postPlaying = Notification.Name.init(rawValue: "MusicIsPlaying")
        NotificationCenter.default.addObserver(self, selector: #selector(musicIsPlaying), name: postPlaying, object: commander)
        let postPause = Notification.Name.init(rawValue: "MusicOnPause")
        NotificationCenter.default.addObserver(self, selector: #selector(musicOnPause), name: postPause, object: commander)
    }
    
    func reloadDataInSubviews(){
        if commander.trackList.count > 0{
            self.trackName.text = commander.trackList[commander.index].title
            self.artistName.text = commander.trackList[commander.index].artist.name
        }
    }
    
    @objc func musicIsPlaying(){
        DispatchQueue.main.async{
            self.commander.audioPlayer?.delegate = self
            self.updateUI = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateUIfrequently), userInfo: nil, repeats: true)
            self.updateUI.fire()
            self.reloadDataInSubviews()
            self.playButton.updateButtonByState(state: .play)
            self.view.bringSubviewToFront(self.minimizeMusicPlayerView)
            self.musicPlayerVC.musicIsPlaying()
        }
    }
    @objc func musicOnPause(){
        DispatchQueue.main.async{
            self.updateUI.invalidate()
            self.playButton.updateButtonByState(state: .pause)
            self.musicPlayerVC.musicOnPause()
        }
    }
    
    deinit {
        let postPlaying = Notification.Name.init(rawValue: "MusicIsPlaying")
        let postPause = Notification.Name.init(rawValue: "MusicOnPause")
        NotificationCenter.default.removeObserver(self, name: postPlaying, object: commander)
        NotificationCenter.default.removeObserver(self, name: postPause, object: commander)
        MusicPlayer.shared.cancel()
    }
}

extension TabBarViewController: UIPlayButtonDelegate{
    func playButtonTapped() {
        self.commander.play()
       }
       
    func pauseButtonTapped() {
        self.commander.pause()
    }

}

extension TabBarViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag{
            if self.commander.index < self.commander.trackList.count - 1{
                self.commander.nextTrack()
            }else{
                self.commander.pause()
                DispatchQueue.main.async {
                    self.musicPlayerVC.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
