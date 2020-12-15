//
//  UserInfo.swift
//  FlashProject
//
//  Created by Techmaster on 7/31/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation

class UserData{
    
    struct UserInfo{
        var name: String
        var email: String
        var userID: String
        var userPassword: String
        init(name: String, email: String, userID: String, userPassword: String){
            self.name = name
            self.email = email
            self.userID = userID
            self.userPassword = userPassword
        }
    }
    
    struct UserStoredData{
        var userLikedTrackIDs: [Int]{
            didSet{
                let likedTrackChanged = Notification.Name.init("likedTrackChanged")
                NotificationCenter.default.post(name: likedTrackChanged, object: self)
            }
        }
        var userLikedArtistIDs: [Int] {
            didSet{
                let likedArtistChanged = Notification.Name.init("likedArtistChanged")
                NotificationCenter.default.post(name: likedArtistChanged, object: self)
            }
        }
        var userLikedAlbumIDs: [Int] {
            didSet{
                let likedAlbumChanged = Notification.Name.init("likedAlbumChanged")
                NotificationCenter.default.post(name: likedAlbumChanged, object: self)
            }
        }
        var historyTrackIDs: [Int] {
            didSet{
                let historyTrackChanged = Notification.Name.init("historyTrackChanged")
                NotificationCenter.default.post(name: historyTrackChanged, object: self)
            }
        }
        init(likedTrackIds: [Int], likedAlbumIds: [Int], likedArtistIds: [Int], historyTrackIds: [Int]){
            self.userLikedTrackIDs = likedTrackIds
            self.userLikedAlbumIDs = likedAlbumIds
            self.userLikedArtistIDs = likedArtistIds
            self.historyTrackIDs = historyTrackIds
        }
    }
    
    static let shared = UserData()
    
    var userStoreData: UserStoredData?
    var userInfo: UserInfo?
    
    private let likedTrackSemaphore = DispatchSemaphore.init(value: 1)
    private let likedAlbumSemaphore = DispatchSemaphore.init(value: 1)
    private let likedArtistSemaphore = DispatchSemaphore.init(value: 1)
    private let historyTrackSemaphore = DispatchSemaphore.init(value: 1)
    
    func addFavoriteTrackId(id: Int){
        self.removefavoriteTrackById(id: id)
        likedTrackSemaphore.wait()
        self.userStoreData?.userLikedTrackIDs.insert(id, at: 0)
        likedTrackSemaphore.signal()
    }
    func addFavoriteAlbumId(id: Int){
        self.removefavoriteAlbumById(id: id)
        likedAlbumSemaphore.wait()
        self.userStoreData?.userLikedAlbumIDs.insert(id, at: 0)
        likedAlbumSemaphore.signal()
    }
    func addFavoriteArtistId(id: Int){
        self.removefavoriteArtistById(id: id)
        likedArtistSemaphore.wait()
        self.userStoreData?.userLikedArtistIDs.insert(id, at: 0)
        likedArtistSemaphore.signal()
    }
    
    func removefavoriteTrackById(id: Int){
        if let trackIds = self.userStoreData?.userLikedTrackIDs{
            for (index,_) in trackIds.enumerated(){
                if trackIds[index] == id{
                    likedTrackSemaphore.wait()
                   self.userStoreData?.userLikedTrackIDs.remove(at: index)
                    likedTrackSemaphore.signal()
                }
            }
        }
    }
    
    func removefavoriteAlbumById(id: Int){
        if let albumIds = self.userStoreData?.userLikedAlbumIDs{
            for (index,_) in albumIds.enumerated(){
                if albumIds[index] == id{
                    likedAlbumSemaphore.wait()
                    self.userStoreData?.userLikedAlbumIDs.remove(at: index)
                    likedAlbumSemaphore.signal()
                }
            }
        }
    }
    
    func removefavoriteArtistById(id: Int){
        if let artistIds = self.userStoreData?.userLikedArtistIDs{
            for (index,_) in artistIds.enumerated(){
                if artistIds[index] == id{
                    likedArtistSemaphore.wait()
                    self.userStoreData?.userLikedArtistIDs.remove(at: index)
                    likedArtistSemaphore.signal()
                }
            }
        }
    }
    
    func addHistoryTrackId(id: Int){
        if let historyTracks = self.userStoreData?.historyTrackIDs{
            for (index,trackId) in historyTracks.enumerated(){
                if trackId == id{
                    historyTrackSemaphore.wait()
                    self.userStoreData?.historyTrackIDs.remove(at: index)
                    historyTrackSemaphore.signal()
                }
            }
            if historyTracks.count >= 10{
                historyTrackSemaphore.wait()
                self.userStoreData?.historyTrackIDs.removeLast()
                self.userStoreData?.historyTrackIDs.insert(id, at: 0)
                historyTrackSemaphore.signal()
            }else{
                historyTrackSemaphore.wait()
                self.userStoreData?.historyTrackIDs.insert(id, at: 0)
                historyTrackSemaphore.signal()
            }
        }
    }
    
    func getTop10NewTracksForYou() -> [Track]?{
        guard let artistIds = self.userStoreData?.userLikedArtistIDs else{return nil}
         var tracks: [Track] = []
        if artistIds.count >= 10{
            let semaphore = DispatchSemaphore.init(value: 1)
            for index in 0...9{
                let getTrackById = CommunicateWithAPI()
                getTrackById.getTrackById(id: artistIds[index]) {
                    if let track = getTrackById.track{
                        semaphore.wait()
                         tracks.append(track)
                        semaphore.signal()
                    }
                }
                return tracks
            }
        }else{
            let semaphore = DispatchSemaphore.init(value: 1)
            for id in artistIds{
                let getTrackById = CommunicateWithAPI()
                getTrackById.getTrackById(id: id) {
                    if let track = getTrackById.track{
                        semaphore.wait()
                        tracks.append(track)
                        semaphore.signal()
                    }
                }
                return tracks
            }
        }
        return nil
    }
    
    func getTop10AlbumsForYou() -> [Album]?{
       guard let artistIds = self.userStoreData?.userLikedArtistIDs else{return nil}
        var albums: [Album] = []
        if artistIds.count >= 10{
            let semaphore = DispatchSemaphore.init(value: 1)
            for index in 0...9{
                let getAlbumById = CommunicateWithAPI()
                getAlbumById.getAlbumById(id: artistIds[index]) {
                    if let album = getAlbumById.album{
                        semaphore.wait()
                        albums.append(album)
                        semaphore.signal()
                    }
                }
                return albums
            }
        }else{
            let semaphore = DispatchSemaphore.init(value: 1)
            for id in artistIds{
                let getAlbumById = CommunicateWithAPI()
               getAlbumById.getAlbumById(id: id) {
                    if let album = getAlbumById.album{
                        semaphore.wait()
                        albums.append(album)
                        semaphore.signal()
                    }
                }
                return albums
            }
        }
        return nil
    }
    
   
    
    private init(){}
    
}
