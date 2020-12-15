//
//  UserAccountTableViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/13/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class UserAccountTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let manageAccountVC = storyboard?.instantiateViewController(withIdentifier: "ManageAccountVC") as! ManageAccountTableViewController
            self.navigationController?.pushViewController(manageAccountVC, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("UserInfoView", owner: self, options: nil)?.first as! UserInfoView
        header.userName.text = UserData.shared.userInfo?.name
        header.userEmailAddress.text = UserData.shared.userInfo?.email
        header.userID.text = UserData.shared.userInfo?.userID
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         let footer = Bundle.main.loadNibNamed("LogOutFooterView", owner: self, options: nil)?.first as! LogOutFooterView
        footer.isUserInteractionEnabled = true
        let logOut = UITapGestureRecognizer(target: self, action: #selector(logOutButtonTapped))
        footer.addGestureRecognizer(logOut)
        return footer as UIView
    }
    
    @objc func logOutButtonTapped(){
        let alert = UIAlertController(title: "Are you sure want to log out?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (_) in
            UserData.shared.userInfo = nil
            UserData.shared.userStoreData = nil
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}
