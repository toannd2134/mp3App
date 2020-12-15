//
//  DetailMPmenuTableViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/15/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class DetailMPmenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("TrackSearchResultCell", owner: self, options: nil)?.first as! TrackSearchResultCell
        header.track_title.textColor = .white
        header.artist_album.textColor = .white
        header.contentView.backgroundColor = UIColor.purple
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
}
