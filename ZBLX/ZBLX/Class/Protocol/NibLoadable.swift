//
//  NibLoadable.swift
//  ZBLX
//
//  Created by sia on 2017/11/11.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//
import UIKit
import Foundation

protocol Nibloadable {
    
}

extension Nibloadable where Self : UIView {
    static func loadFromNib(_ nibName : String? = nil)  -> Self {
        guard nibName != nil else {
            return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
        }
        return Bundle.main.loadNibNamed(nibName!, owner: nil, options: nil)?.first as! Self
    }
}
