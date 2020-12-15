//
//  AlbumsViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/11/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {
    var links: [String?] = []
    var albumIdToPass: Int?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        registerTableView()
    }
    func configureNavigationBar(){
           self.title = "Albums"
           self.navigationController?.navigationBar.prefersLargeTitles = false
       }
    
    func registerTableView(){
        tableView.register(UINib(nibName: "AlbumSearchResultCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
    }

}

extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.shared.userStoreData?.userLikedAlbumIDs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumSearchResultCell
        guard let albumIDs = UserData.shared.userStoreData?.userLikedAlbumIDs, !albumIDs.isEmpty else {return UITableViewCell()}
        let albumID = albumIDs[indexPath.row]
        let getAlbumByID = CommunicateWithAPI()
        getAlbumByID.getAlbumById(id: albumID){
            [weak self]() -> Void in
            guard let strongSelf = self else {return}
            let url = URL(string: getAlbumByID.album?.cover_xl ?? "https://s3-eu-west-1.amazonaws.com/magnet-wp-avplus/app/uploads/2019/08/21211744/apple-music.jpg")
                cell.avatar.kf.setImage(with: url)
            cell.albumtitle.text = getAlbumByID.album?.title ?? ""
            cell.artistName.text = getAlbumByID.album?.artist.name ?? ""
            strongSelf.albumIdToPass = getAlbumByID.album?.id
            strongSelf.links.append(getAlbumByID.album?.tracklist)
            strongSelf.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let link = self.links[indexPath.row]{
            let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailAlbumViewController") as! DetailAlbumViewController
            detailView.link = link
            detailView.albumID = self.albumIdToPass
            self.navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
}

