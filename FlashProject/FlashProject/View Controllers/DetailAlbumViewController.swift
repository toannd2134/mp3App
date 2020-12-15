//
//  AlbumViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/11/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit
import Kingfisher
class DetailAlbumViewController: UIViewController {
    var trackList: [Track]?
    var albumID: Int?
    var link: String?
    var imageURL: URL?
    @IBOutlet weak var tableView: UITableView!
    let likeButton = UILikeButton(frame: .zero, originState: .unlike, unlikeImageName: "icons8-heart-50", likedImageName: "icons8-redheart-50")
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
    }
    
    override func loadView(){
        super.loadView()
        if let link = self.link{
            let getAlbumTracks = CommunicateWithAPI()
            getAlbumTracks.getTrackListByLink(link: link){
                self.trackList = getAlbumTracks.trackList
                self.reloadDataInSubViews()
                self.tableView.reloadData()
            }
        }
    }
    
    func reloadDataInSubViews(){
        if let albumId = trackList?.first?.album?.id{
            guard let likedAlbumIds = UserData.shared.userStoreData?.userLikedAlbumIDs else{return}
            self.likeButton.updateButtonByState(state: .unlike)
            for id in likedAlbumIds{
                if albumId == id{
                    self.likeButton.updateButtonByState(state: .liked)
                }
            }
        }
    }
    
    
    func registerTableView(){
        tableView.register(UINib(nibName: "TrackSearchResultCell", bundle: nil), forCellReuseIdentifier: "TrackCell")
    }
}

extension DetailAlbumViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else{
            return trackList?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            if let data = trackList?[indexPath.row]{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackSearchResultCell
                cell.track_title.text = data.title
                cell.artist_album.text = data.artist.name
                let url = URL(string:data.album?.cover_xl ?? "https://s3-eu-west-1.amazonaws.com/magnet-wp-avplus/app/uploads/2019/08/21211744/apple-music.jpg")
                cell.avatar.kf.setImage(with: url)
                return cell
            }else{
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let track = self.trackList?[indexPath.row] else{return}
        MusicPlayer.shared.restartMusicPlayerWithTrackList(tracklist: [track])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 360
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let detailAlbumView = Bundle.main.loadNibNamed("Artist_Album_detailView", owner: self, options: nil)?.first as! Artist_Album_detailView
            guard let trackList = trackList , !trackList.isEmpty else {return UIView()}
            detailAlbumView.avatar.kf.setImage(with: self.imageURL)
            detailAlbumView.playButton.setTitle("PLAY ALBUM MIX", for: .normal)
            detailAlbumView.likeButton.likeButtonDelegate = self
            detailAlbumView.playButtonAction = {
                [weak self]() -> Void in
                guard let strongSelf = self else {return}
                if let trackList = strongSelf.trackList{
                    MusicPlayer.shared.restartMusicPlayerWithTrackList(tracklist: trackList)
                }
            }
            return detailAlbumView as UIView
        }else{
            let header = Bundle.main.loadNibNamed("HeaderMusicView", owner: self, options: nil)?.first as! HeaderMusicView
            header.headerTitle.text = "Top tracks"
            header.headerDescription.text = ""
            return header as UIView
        }
    }
}

extension DetailAlbumViewController: UILikeButtonDelegate{
    func likeButtonTapped() {
        if let albumId = self.albumID{
        UserData.shared.addFavoriteAlbumId(id: albumId)
        }
    }
    
    func unlikeButtonTapped() {
        if let albumId = self.albumID{
            UserData.shared.removefavoriteAlbumById(id: albumId)
        }
    }
}

