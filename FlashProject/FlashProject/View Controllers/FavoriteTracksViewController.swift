//
//  FavoriteTracksViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/11/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class FavoriteTracksViewController: UIViewController {
    var tracks : [Track?] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureNavigationBar()
        registerTableView()
    }
    
    func configureNavigationBar(){
        self.title = "Favorite Tracks"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func registerTableView(){
        tableView.register(UINib(nibName: "TrackSearchResultCell", bundle: nil), forCellReuseIdentifier: "TrackCell")
    }

}

extension FavoriteTracksViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.shared.userStoreData?.userLikedTrackIDs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackSearchResultCell
        guard let trackIDs = UserData.shared.userStoreData?.userLikedTrackIDs, !trackIDs.isEmpty else {return UITableViewCell()}
        let trackID = trackIDs[indexPath.row]
        let getTrackByID = CommunicateWithAPI()
        getTrackByID.getTrackById(id: trackID) {
            [weak self]() -> Void in
            guard let strongSelf = self else {return}
            let url = URL(string: getTrackByID.track?.album?.cover_xl ?? "https://s3-eu-west-1.amazonaws.com/magnet-wp-avplus/app/uploads/2019/08/21211744/apple-music.jpg")
            cell.avatar.kf.setImage(with: url)
            cell.artist_album.text = "\(getTrackByID.track?.artist.name ?? "") + \(getTrackByID.track?.album?.title ?? "")"
            cell.track_title.text = getTrackByID.track?.title_short ?? ""
            strongSelf.tracks.append(getTrackByID.track)
            strongSelf.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tracks.count > 0 {
            if let track = tracks[indexPath.row]{
                MusicPlayer.shared.restartMusicPlayerWithTrackList(tracklist: [track])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

