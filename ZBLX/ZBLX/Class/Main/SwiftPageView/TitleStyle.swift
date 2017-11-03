//
//  TitleStyle.swift
//  ContentViewSwift
//
//  Created by sia on 2017/10/31.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class TitleStyle {

    var titleHeight : CGFloat = 44
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    var selectColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    var fontSize : CGFloat = 15.0
    
    var isScrollEnable : Bool = false
    var itemMargin : CGFloat = 30
    
    var isShowScrollLine : Bool = false
    var scrollLineH : CGFloat = 2
    var scrollLineColor : UIColor = .orange
    
    var isShowShadow : Bool = false
    var shadowColor : UIColor = UIColor.black
    var shadowAlpha : CGFloat = 0.3
    var shadowH : CGFloat = 30
}
