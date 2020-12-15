//
//  SearchViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/6/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchDatasFromAPI = CommunicateWithAPI()
    
    enum CellType{
        case Track
        case Artist
        case Album
    }
    
    struct NavigateItem{
        var title: String
        var type: CellType
    }
    
    private var navigateItems: [NavigateItem] = []
    
    private var typeState: CellType = .Track
    
    
    
    let defaultView : UIView = {
        let defautView = UIView()
        let searchIcon : UIImageView = {
            let searchIcon = UIImageView()
            searchIcon.image = UIImage(named: "icons8-search-250")
            return searchIcon
        }()
        let title: UILabel = {
            let title = UILabel()
            title.text = "Searching"
            title.textColor = UIColor.lightGray
            title.font = UIFont(name: "OpenSans-Regular.ttf" , size: 32)
            return title
        }()
        
        defautView.addSubview(searchIcon)
        defautView.addSubview(title)
        defautView.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        searchIcon.centerXAnchor.constraint(equalTo: defautView.centerXAnchor).isActive = true
        searchIcon.centerYAnchor.constraint(equalTo: defautView.centerYAnchor, constant: -20).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 125).isActive = true
        searchIcon.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        title.centerXAnchor.constraint(equalTo: defautView.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: searchIcon.bottomAnchor, constant: 20).isActive = true
        
        return defautView
    }()
    let loadingView : UIView = {
        let loadingView = UIView()
        loadingView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        //layout activity indicator view
        loadingView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        indicatorView.startAnimating()
        return loadingView
    }()
    
    let resultsView = UIView()
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(UINib(nibName: "SearchViewNavigateBarCell", bundle: nil), forCellWithReuseIdentifier: "SearchNavigateCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "TrackSearchResultCell", bundle: nil), forCellReuseIdentifier: "TrackCell")
        tableView.register(UINib(nibName: "ArtistSearchResultCell", bundle: nil), forCellReuseIdentifier: "ArtistCell")
        tableView.register(UINib(nibName: "AlbumSearchResultCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
        return tableView
    }()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addNavigateItems()
        searchBar.delegate = self
        layoutDefautView()
    }
    
    //configure navigation bar
    func configureNavigationBar(){
        self.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //add navigate item
    func addNavigateItems(){
        navigateItems.append(NavigateItem(title: "TRACKS", type: .Track))
        navigateItems.append(NavigateItem(title: "ALBUMS", type: .Album))
        navigateItems.append(NavigateItem(title: "ARTISTS", type: .Artist))
    }
    
    func layoutDefautView(){
        view.addSubview(defaultView)
        defaultView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        defaultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        defaultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        defaultView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -62).isActive = true
        view.bringSubviewToFront(defaultView)
    }
    
    func layoutLoadingView(){
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 62).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -62).isActive = true
    }

    func layoutSearchResultsView(){
        //layout search results view
        view.addSubview(resultsView)
        resultsView.translatesAutoresizingMaskIntoConstraints = false
        resultsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        resultsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        resultsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        resultsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //layout collection view
        resultsView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: resultsView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: resultsView.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: resultsView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 62).isActive = true
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
        }
        //configure collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        //layout table view
        resultsView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: resultsView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: resultsView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: resultsView.bottomAnchor).isActive = true
        //configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    // SEARCH BUTTON TAPPED
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if let text = searchBar.text, !text.isEmpty{
            searchBar.endEditing(true)
            self.layoutLoadingView()
            Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self](timer) in
                guard let strongSelf = self else{timer.invalidate();return}
                DispatchQueue.main.async {
                    strongSelf.loadingView.removeFromSuperview()
                }
                timer.invalidate()
            }
            searchDatasFromAPI.search(with: text){
                [weak self]() -> Void in
                guard let strongSelf = self else {return}
                strongSelf.loadingView.removeFromSuperview()
                strongSelf.layoutSearchResultsView()
                strongSelf.tableView.reloadData()
                
            }
        }
    }
    
}

//COLLECTION VIEW
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.navigateItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchNavigateCell", for: indexPath) as! SearchNavigateCell
        let data = navigateItems[indexPath.item]
        cell.label.text = data.title
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 15.0
        if data.type == self.typeState{
            cell.backgroundColor = UIColor.purple
            cell.label.textColor = .white
            cell.layer.borderColor = UIColor.white.cgColor
        }else{
            cell.backgroundColor = UIColor.white
            cell.label.textColor = UIColor.purple
            cell.layer.borderColor = UIColor.purple.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.navigateItems[indexPath.item].type {
        case .Track:
            self.typeState = .Track
            self.collectionView.reloadData()
            self.tableView.reloadData()
        case .Artist:
            self.typeState = .Artist
            self.collectionView.reloadData()
            self.tableView.reloadData()
        case .Album:
            self.typeState = .Album
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
}
//TABLE VIEW
extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let resultComponents = self.searchDatasFromAPI.resultComponents else {return 0}
        switch self.typeState{
            case .Track:
                return resultComponents.tracks.count
            case.Artist:
                return resultComponents.artists.count
            case.Album:
                return resultComponents.albums.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.typeState {
        case .Track:
            guard let data = searchDatasFromAPI.resultComponents?.tracks[indexPath.row] else {return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackSearchResultCell
            cell.track_title.text = data.title
            cell.artist_album.text = data.artist.name + " - " + data.album!.title
            let url = URL(string: data.album!.cover_xl)
            cell.avatar.kf.setImage(with: url)
            return cell
        case .Artist:
            guard let artists = searchDatasFromAPI.resultComponents?.artists.enumerated() else {return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell") as! ArtistSearchResultCell
            for (index, artist) in artists{
                if index == indexPath.row{
                    cell.artistname.text = artist.name
                    cell.numberOfFans.text = ""
                    let url = URL(string: artist.picture_xl!)
                    cell.avatar.kf.setImage(with: url)
                }
            }
            return cell
        case .Album:
            guard let albums = searchDatasFromAPI.resultComponents?.albums.enumerated() else {return UITableViewCell()}
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumSearchResultCell
            for (index, album) in albums{
                if index == indexPath.row{
                    cell.albumtitle.text = album.title
                    cell.artistName.text = ""
                    let url = URL(string: album.cover_xl)
                    cell.avatar.kf.setImage(with: url)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let resultComponents = self.searchDatasFromAPI.resultComponents else {return}
        switch self.typeState{
        case .Track:
            for (index, track) in resultComponents.tracks.enumerated(){
                if index == indexPath.row{
                    MusicPlayer.shared.restartMusicPlayerWithTrackList(tracklist: [track])
                }
            }
        case .Artist:
            for (index, artist) in resultComponents.artists.enumerated(){
                if index == indexPath.row{
                    let artistVC = storyboard?.instantiateViewController(withIdentifier: "DetailArtistViewController") as! DetailArtistViewController
                    artistVC.link = artist.tracklist
                    artistVC.imageURL = URL(string: artist.picture_xl ?? "https://s3-eu-west-1.amazonaws.com/magnet-wp-avplus/app/uploads/2019/08/21211744/apple-music.jpg")
                    self.navigationController?.pushViewController(artistVC, animated: true)
                }
            }
        case .Album:
            for(index, album) in resultComponents.albums.enumerated(){
                if index == indexPath.row{
                    let albumVC = storyboard?.instantiateViewController(withIdentifier: "DetailAlbumViewController") as! DetailAlbumViewController
                    albumVC.link = album.tracklist
                    albumVC.albumID = album.id
                    albumVC.imageURL = URL(string: album.cover_xl)
                    self.navigationController?.pushViewController(albumVC, animated: true)
                }
            }
        
        }
    }
    
    
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        self.resultsView.removeFromSuperview()
        searchBar.resignFirstResponder()
    }
    
}
