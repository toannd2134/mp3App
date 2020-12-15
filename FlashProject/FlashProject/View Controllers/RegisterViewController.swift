//
//  RegisterViewController.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/5/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    enum InvalidInput: Error{
        case invalidPassword
        case invalidEmail
        case ignoreField
        case incorrectRePassword
    }
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSubviews()
    }
    
    func layoutSubviews(){
        registerView.layer.cornerRadius = 20.0
        registerButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
    }
    
    func tryRegister(){
        func validateInput() throws{
            if firstname.text!.isEmpty || emailAddress.text!.isEmpty || password.text!.isEmpty || rePassword.text!.isEmpty{
                throw InvalidInput.ignoreField
            }
            if !emailAddress.text!.isEmail{
                throw InvalidInput.invalidEmail
            }
            if !password.text!.isPassword{
                throw InvalidInput.invalidPassword
            }
            if password.text! != rePassword.text!{
                throw InvalidInput.incorrectRePassword
            }
        }
        
        func popupAlert(){
            do{
                try validateInput()
                let alert = UIAlertController(title: "Register Success!!", message: "Đăng ký thành công", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.dismiss(animated: false, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }catch InvalidInput.ignoreField{
                let alert = UIAlertController(title: "Nhập thiếu trường thông tin", message: "Điền đầy đủ các trường thông tin trước khi bấm đăng ký", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }catch InvalidInput.invalidEmail{
                let alert = UIAlertController(title: "Email không đúng cấu trúc", message: "cấu trúc như ví dụ sau: abcd1234@gmail.com", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }catch InvalidInput.invalidPassword{
                let alert = UIAlertController(title: "Password không đúng form", message: " ký tự đầu của password phải là chữ in hoa và độ dài từ 8 - 20 kí tự", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }catch InvalidInput.incorrectRePassword{
                let alert = UIAlertController(title: "Confirm password sai", message: "Confirm password và password không trùng nhau", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                self.password.text! = ""
                self.rePassword.text! = ""

            }catch let error as NSError{
                let alert = UIAlertController(title: "Unexpected Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)

            }
        }
        popupAlert()
    }

    @IBAction func registerTapped(_ sender: Any) {
        tryRegister()
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
