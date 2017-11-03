//
//  NSDate+Extention.swift
//  ZBLX
//
//  Created by sia on 2017/11/3.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import Foundation

extension Date{
    static func getCurrentTime()->String{
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return"\(interval)"
    }
}
