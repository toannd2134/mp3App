//
//  ArtistsViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/11/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class ArtistsViewController: UIViewController {
    var links: [String?] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        registerTableView()
    }
    
    func configureNavigationBar(){
           self.title = "Artists"
           self.navigationController?.navigationBar.prefersLargeTitles = false
       }
    func registerTableView(){
        tableView.register(UINib(nibName: "ArtistSearchResultCell", bundle: nil), forCellReuseIdentifier: "ArtistCell")
    }
}

extension ArtistsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.shared.userStoreData?.userLikedArtistIDs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell") as! ArtistSearchResultCell
        guard let artistIDs = UserData.shared.userStoreData?.userLikedArtistIDs, !artistIDs.isEmpty else {return UITableViewCell()}
        let artistID = artistIDs[indexPath.row]
        let getArtistByID = CommunicateWithAPI()
        getArtistByID.getArtistById(id: artistID){
            [weak self]() -> Void in
            guard let strongSelf = self else {return}
            let url = URL(string: getArtistByID.artist?.picture_xl ?? "https://s3-eu-west-1.amazonaws.com/magnet-wp-avplus/app/uploads/2019/08/21211744/apple-music.jpg")
            cell.avatar.kf.setImage(with: url)
            cell.artistname.text = getArtistByID.artist?.name ?? ""
            cell.numberOfFans.text = String(getArtistByID.artist?.numberOfFan ?? 0)
            strongSelf.links.append(getArtistByID.artist?.tracklist)
            strongSelf.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let link = self.links[indexPath.row]{
            let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailArtistViewController") as! DetailArtistViewController
            detailView.link = link
            self.navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
}

