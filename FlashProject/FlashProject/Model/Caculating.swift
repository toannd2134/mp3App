//
//  Caculating.swift
//  FlashProject
//
//  Created by Luong Quang Huy on 7/16/20.
//  Copyright © 2020 Luong Quang Huy. All rights reserved.
//

import Foundation

class Caculating{
    static let shared = Caculating()
    func doubleToMiniute(double: Double) -> String{
        let miniute = Int(double) / 60
        let second = Int(double) % 60
        if second <= 9{
            return "\(miniute):0\(second)"
        }else{
            return "\(miniute):\(second)"
        }
    }
    private init(){}
}
