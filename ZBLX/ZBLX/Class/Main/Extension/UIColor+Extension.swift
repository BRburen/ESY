//
//  UIColor+Extension.swift
//  ZBLX
//
//  Created by sia on 2017/10/30.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

extension UIColor{
    //在Extension中给系统的类扩展构造函数,只能扩展便利构造函数
    //便利构造函数必须调用self.init
    @objc convenience init(r : CGFloat ,g :CGFloat ,b : CGFloat, a : CGFloat = 1.0){
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    // MARK: - 随机色
    @objc class func randomColor() -> UIColor{
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    @objc convenience init?(hex : String,alpha : CGFloat = 1.0){
        //0xFF0000
        guard hex.count >= 6 else{
            return nil
        }
        
        //2将字符串转成大写
        var tempHex = hex.uppercased()
        
        //3 判断开头 : 0x / # / ##
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from : 2)
        }
        
        if tempHex.hasPrefix("#"){
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        var range = NSMakeRange(0, 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        //将16进制转成 数字
        var r : UInt32 = 0, g :UInt32 = 0, b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
        
    }
    
    // MARK: - 颜色差值
    class func getRGBDelta(_ firstColor : UIColor,_ seccondColor : UIColor) -> (CGFloat , CGFloat, CGFloat){
        let firstRGB = firstColor.getRGB()
        let secondRGB = seccondColor.getRGB()
        
        return (firstRGB.0 - secondRGB.0,firstRGB.1 - secondRGB.1,firstRGB.2 - secondRGB.2)
    }
    
    func getRGB() -> (CGFloat,CGFloat,CGFloat){
        guard let cpms = cgColor.components else{
            fatalError("保证普通颜色是RGB方式传入")
        }
        return (cpms[0] * 255 ,cpms[1] * 255 ,cpms[2] * 255 )
    }
}
