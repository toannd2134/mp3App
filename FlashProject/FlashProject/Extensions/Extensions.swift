//
//  Extensions.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/5/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation

extension String{
    var isEmail: Bool {
        get{
            let emailFormat = "[A-Za-z0-9+-_.%]+\\@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailFormat)
            
            return emailTest.evaluate(with: self)
        }
    }
    
    var isUsername: Bool{
        get{
            let usernameFormat = "[A-Za-z0-9+-_.]{8,20}"
            let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameFormat)
            return usernameTest.evaluate(with: self)
        }
    }
    
    var isPassword: Bool{
        get{
            let passwordFormat = "[A-Z]{1,}+[A-Za-z0-9 ]{7,19}"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
            
            return passwordTest.evaluate(with: self)
        }
    }
}
