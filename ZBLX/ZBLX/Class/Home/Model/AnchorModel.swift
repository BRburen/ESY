//
//  AnchorModel.swift
//  XMGTV
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit
class AnchorModel: BaseModel {
    @objc var roomid : Int = 0
    @objc var name : String = ""
    @objc var pic51 : String = ""
    @objc var pic74 : String = ""
    @objc var live : Int = 0 // 是否在直播
    @objc var push : Int = 0 // 直播显示方式
    @objc var focus : Int = 0 // 关注数
    
    @objc var isEvenIndex : Bool = false
}
