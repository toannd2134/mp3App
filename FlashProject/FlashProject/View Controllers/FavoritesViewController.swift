//
//  FavoritesViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/6/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var historyTracks: [Track] = []
    
    @IBOutlet weak var tableView: UITableView!
    private struct SectionInfo{
        enum SectionCellType{
            case History
            case Themes
        }
        var type: SectionCellType
        var titleHeader: String
        var themes: [Theme]?
        var heightForRowInSection: CGFloat
    }
    
    private struct Theme{
        var themeTitle: String
        var count: Int
        var responseSelectAction: (() -> Void)?
    }
    
    private var sectionInfo: [SectionInfo] = []
    
    private lazy var collectionViewForRegister: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    var collectionView: UICollectionView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.separatorStyle = .none
        configureNavigationBar()
        tableViewRegister()
        tableViewConfigureSection()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.addObservers()
    }
    
    func addObservers(){
         let historyTrackChanged = Notification.Name.init("historyTrackChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHistoryData), name: historyTrackChanged, object: UserData.shared)
        let likedTrackChanged = Notification.Name.init("likedTrackChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTracksNumberCount), name: likedTrackChanged, object: UserData.shared)
        let likedAlbumChanged = Notification.Name.init("likedAlbumChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAlbumsNumberCount), name: likedAlbumChanged, object: UserData.shared)
        let likedArtistChanged = Notification.Name.init("likedArtistChanged")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadArtistNumberCount), name: likedArtistChanged, object: UserData.shared)
    }
    
    @objc func reloadHistoryData(){
        self.collectionView?.reloadData()
    }
    
    @objc func reloadTracksNumberCount(){
        tableViewConfigureSection()
    }
    
    @objc func reloadAlbumsNumberCount(){
        tableViewConfigureSection()
    }
    
    @objc func reloadArtistNumberCount(){
        tableViewConfigureSection()
    }
    
    func configureNavigationBar(){
        self.title = "Favorites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    func tableViewRegister(){
        // tableview register
        tableView.register(UINib(nibName: "MusicCollectionView", bundle: nil), forCellReuseIdentifier: "HistoryView")
        tableView.register(UINib(nibName: "FavoriteThemeCell", bundle: nil), forCellReuseIdentifier: "ThemeCell")
        // history view register cell
        collectionViewForRegister.register(UINib(nibName: "RecentlyPlayedCell", bundle: nil), forCellWithReuseIdentifier: "RecentlyPlayedCell")
    }
    
    func tableViewConfigureSection(){
        //configure history section
        let historySection = SectionInfo(type: .History, titleHeader: "Recently Played", themes: nil , heightForRowInSection: 250)
        // configure themes section
        let favoriteTracks = Theme(themeTitle: "Favorite Tracks", count: UserData.shared.userStoreData?.userLikedTrackIDs.count ?? 0) {
            [unowned self] () -> Void in
            if let favoriteTracksVC = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteTracksViewController") as? FavoriteTracksViewController{
                self.navigationController?.pushViewController(favoriteTracksVC, animated: true)
            }
        }
        let albums = Theme(themeTitle: "Albums", count: UserData.shared.userStoreData?.userLikedAlbumIDs.count ?? 0) {
            [unowned self] () -> Void in
            if let albumsVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumsViewController") as? AlbumsViewController{
                self.navigationController?.pushViewController(albumsVC, animated: true)
            }
        }
        let artists = Theme(themeTitle: "Artists", count: UserData.shared.userStoreData?.userLikedArtistIDs.count ?? 0) {
            [unowned self] () -> Void in
            if let artistsVC = self.storyboard?.instantiateViewController(withIdentifier: "ArtistsViewController") as? ArtistsViewController{
                self.navigationController?.pushViewController(artistsVC, animated: true)
            }
        }
        let themesSection = SectionInfo(type: .Themes, titleHeader: "", themes: [favoriteTracks, albums, artists], heightForRowInSection: 80)
        sectionInfo.append(historySection)
        sectionInfo.append(themesSection)
    }
    
    deinit {
        let historyTrackChanged = Notification.Name.init("historyTrackChanged")
        NotificationCenter.default.removeObserver(self, name: historyTrackChanged, object: UserData.shared)
        let likedTrackChanged = Notification.Name.init("likedTrackChanged")
        NotificationCenter.default.removeObserver(self, name: likedTrackChanged, object: UserData.shared)
        let likedAlbumChanged = Notification.Name.init("likedAlbumChanged")
        NotificationCenter.default.removeObserver(self, name: likedAlbumChanged, object: UserData.shared)
        let likedArtistChanged = Notification.Name.init("likedArtistChanged")
        NotificationCenter.default.removeObserver(self, name: likedArtistChanged, object: UserData.shared)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRow = sectionInfo[section].themes?.count{
            return numberOfRow
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionInfo[indexPath.section].type {
            
        case .History:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryView") as! MusicCollectionView
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            self.collectionView = cell.collectionView
            return cell
        case .Themes:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell") as! FavoriteThemeCell
            if let theme = sectionInfo[indexPath.section].themes?[indexPath.row]{
                cell.themeTitle.text = theme.themeTitle
                cell.count.text = String(theme.count)
                return cell
            }else{
                return cell
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sectionInfo[indexPath.section].heightForRowInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderMusicView", owner: self, options: nil)?.first as! HeaderMusicView
        headerView.headerTitle.text = sectionInfo[section].titleHeader
        headerView.headerDescription.text = ""
        return headerView as UIView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let responseSelectAction = sectionInfo[indexPath.section].themes?[indexPath.row].responseSelectAction{
            responseSelectAction()
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserData.shared.userStoreData?.historyTrackIDs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewForRegister.dequeueReusableCell(withReuseIdentifier: "RecentlyPlayedCell", for: indexPath) as! RecentlyPlayedCell
        let getHistoryTrackById = CommunicateWithAPI()
        guard let trackId = UserData.shared.userStoreData?.historyTrackIDs[indexPath.item] else {return UICollectionViewCell()}
        getHistoryTrackById.getTrackById(id: trackId) {
            guard let track = getHistoryTrackById.track else {return}
            self.historyTracks.append(track)
            let url = URL(string: track.album?.cover_xl ?? "https://s3-eu-west-1.amazonaws.com/magnet-wp-avplus/app/uploads/2019/08/21211744/apple-music.jpg")
            cell.avatar.kf.setImage(with: url)
            cell.trackTitle.text = track.title
            cell.artistName.text = track.artist.name
            self.tableView.reloadData()
        }
        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MusicPlayer.shared.restartMusicPlayerWithTrackList(tracklist: [self.historyTracks[indexPath.item]])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 230)
    }
    
}

