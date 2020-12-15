//
//  ArtistViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/11/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit
import Kingfisher
class DetailArtistViewController: UIViewController {
    var trackList: [Track]?
    var imageURL : URL?
    var link: String?
    @IBOutlet weak var tableView: UITableView!
    let likeButton = UILikeButton(frame: .zero, originState: .unlike, unlikeImageName: "icons8-heart-50", likedImageName: "icons8-redheart-50")
    
    override func loadView(){
        super.loadView()
        if let link = self.link{
            let getArtistTracks = CommunicateWithAPI()
            getArtistTracks.getTrackListByLink(link: link){
                self.trackList = getArtistTracks.trackList
                self.reloadDataInSubViews()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
    }
    
    func registerTableView(){
        tableView.register(UINib(nibName: "TrackSearchResultCell", bundle: nil), forCellReuseIdentifier: "TrackCell")
    }
    
    func reloadDataInSubViews(){
        if let artistId = self.trackList?.first?.artist.id{
            guard let likedArtistIds = UserData.shared.userStoreData?.userLikedArtistIDs else{return}
            self.likeButton.updateButtonByState(state: .unlike)
            for id in likedArtistIds{
                if artistId == id{
                    self.likeButton.updateButtonByState(state: .liked)
                }
            }
        }
    }

}

extension DetailArtistViewController: UITableViewDelegate, UITableViewDataSource{
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
            let detailArtistView = Bundle.main.loadNibNamed("Artist_Album_detailView", owner: self, options: nil)?.first as! Artist_Album_detailView
            guard let trackList = trackList , !trackList.isEmpty else {return UIView()}
            detailArtistView.avatar.kf.setImage(with: self.imageURL)
            detailArtistView.playButton.setTitle("PLAY ARTIST MIX", for: .normal)
            detailArtistView.likeButton.likeButtonDelegate = self
            detailArtistView.playButtonAction = {
                [weak self]() -> Void in
                guard let strongSelf = self else {return}
                if let trackList = strongSelf.trackList{
                    MusicPlayer.shared.restartMusicPlayerWithTrackList(tracklist: trackList)
                }
            }
            return detailArtistView as UIView
        }else{
        let header = Bundle.main.loadNibNamed("HeaderMusicView", owner: self, options: nil)?.first as! HeaderMusicView
        header.headerTitle.text = "Top tracks"
        header.headerDescription.text = ""
        return header as UIView
        }
    }
    
}


extension DetailArtistViewController: UIPlayButtonDelegate{
    func playButtonTapped() {
        MusicPlayer.shared.play()
    }
    
    func pauseButtonTapped() {
        MusicPlayer.shared.pause()
    }
    
    
}

extension DetailArtistViewController: UILikeButtonDelegate{
    func likeButtonTapped() {
        if let artistId = self.trackList?.first?.artist.id{
            UserData.shared.addFavoriteArtistId(id: artistId)
        }
    }
    
    func unlikeButtonTapped() {
        if let artistId = self.trackList?.first?.artist.id{
            UserData.shared.removefavoriteArtistById(id: artistId)
        }
    }
    
    
}
