//
//  LoginViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/5/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

   
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
       
    }
    
    func layoutSubviews(){
        loginView.layer.cornerRadius = 20.0
        loginButton.layer.cornerRadius = 5.0
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        guard let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") else {return}
        tabBarVC.modalPresentationStyle = .fullScreen
        UserData.shared.userInfo = UserData.UserInfo(name: "Luong Quang Huy", email: "quanghuy0606999@gmail.com", userID: "1234567890", userPassword: "LuongQuanggHuy")
        UserData.shared.userStoreData = UserData.UserStoredData(likedTrackIds: [], likedAlbumIds: [], likedArtistIds: [], historyTrackIds: [])
        present(tabBarVC, animated: true, completion: nil)
    }
    @IBAction func registerTapped(_ sender: Any) {
        guard let registerVC = storyboard?.instantiateViewController(withIdentifier: "Register Screen") else {return}
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: false, completion: nil)
    }
}
