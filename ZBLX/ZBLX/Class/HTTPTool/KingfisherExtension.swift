//
//  KingfisherExtension.swift
//  ZBLX
//
//  Created by sia on 2017/11/4.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import Foundation

import Kingfisher

extension UIImageView{
    func setImage(_ URLString : String? , _ placeHolderName : String?){
        
        guard let URLString = URLString else {
            return
        }
        
        guard let placeHolderName  = placeHolderName else {
            return
        }
        
        guard let url = URL(string : URLString) else {return}
        kf.setImage(with: url, placeholder: UIImage(named : placeHolderName))
    }
}
