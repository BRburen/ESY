//
//  EmoticonViewModel.swift
//  ZBLX
//
//  Created by sia on 2017/11/16.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
// 表情包 一共两 设计成单例 

import UIKit

class EmoticonViewModel {
    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EnmticonPackage] = [EnmticonPackage]()
    
    init() {
        packages.append(EnmticonPackage(listName: "QHNormalEmotionSort.plist"))
        packages.append(EnmticonPackage(listName: "QHSohuGifSort.plist"))
    }
}

