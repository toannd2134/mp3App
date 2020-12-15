//
//  MusicPlayer.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/16/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MusicPlayer{
    
    static let shared = MusicPlayer()
    var task: URLSessionDownloadTask?
    var audioPlayer: AVAudioPlayer?
    var trackList: [Track] = []
    var index = 0
    
    var progress: Float{
        get{
            if let audioPlayer = self.audioPlayer{
                return Float(audioPlayer.currentTime / audioPlayer.duration)
            }else{
                return 0.0
            }
        }
    }
    
    func restartMusicPlayerWithTrackList(tracklist: [Track]){
        self.cancel()
        self.trackList = tracklist
        startPlayingCurrentTrack()
    }
    
    private func startPlayingCurrentTrack(){
            let request = URLRequest(url: URL(string: trackList[index].preview)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            self.task = URLSession.shared.downloadTask(with: request) { [weak self, weak userData = UserData.shared](url, response, error) in
                guard let strongSelf = self else {return}
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    guard let url = url ,let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {return}
                    do{
                        strongSelf.audioPlayer = try AVAudioPlayer(contentsOf: url)
                        strongSelf.audioPlayer?.prepareToPlay()
                        strongSelf.play()
                        let id = strongSelf.trackList[strongSelf.index].id
                        userData?.addHistoryTrackId(id: id)
                    }catch{
                        print(error)
                    }
                }
            }
            task?.resume()
    }
    
    func play(){
        self.audioPlayer?.play()
        let postPlaying = Notification.Name.init(rawValue: "MusicIsPlaying")
        NotificationCenter.default.post(name: postPlaying, object: self)
    }
    
    func pause(){
        self.audioPlayer?.pause()
        let postPause = Notification.Name.init(rawValue: "MusicOnPause")
        NotificationCenter.default.post(name: postPause, object: self)
    }
    
    func backTrack(){
        self.pause()
        if self.index >= 0{
            if self.index > 0{
                self.index -= 1
            }
        self.startPlayingCurrentTrack()
        }
    }
    
    func nextTrack(){
        self.pause()
        if self.index <= trackList.count - 1{
            if self.index < trackList.count - 1{
                self.index += 1
            }
        self.startPlayingCurrentTrack()
        }
    }
    
    func cancel(){
        self.pause()
        self.task?.cancel()
        self.task = nil
        self.audioPlayer = nil
        self.trackList = []
        self.index = 0
    }
    
    private init(){}
}


