//
//  EnmticonPackage.swift
//  ZBLX
//
//  Created by sia on 2017/11/16.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
// 用到表情模型数组 

import UIKit

class EnmticonPackage {
    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(listName : String){
        guard let path = Bundle.main.path(forResource: listName, ofType: nil) else{ return }
        guard let emoticonArray = NSArray(contentsOfFile: path) as? [String] else{ return }
        
        for emoticonName in emoticonArray {
            emoticons.append(Emoticon(enmoticonName: emoticonName))
        }
    }
}
