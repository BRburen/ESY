//
//  EmitterAnimation.swift
//  ZBLX
//
//  Created by sia on 2017/11/11.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//
import UIKit
import Foundation

protocol EmitterAnimation {
    
}
// MARK: - 表示继承本功能必须是继承自UIViewController的类
extension EmitterAnimation where Self : UIViewController{
    func emitterStart(_ point : CGPoint){
        //1 创建发射器
        let emitter = CAEmitterLayer()
        //2 设置发射器的位置
        emitter.emitterPosition = point
        
        //3 开启三维效果 (一般会开启 )
        emitter.preservesDepth = true
        
        //3.5   创建Cell数组
        var cellArray = [CAEmitterCell]()
        
        for _ in 0..<10 {
            //4 创建粒子,并且设置相关属性
            let cell = CAEmitterCell()
            
            //4 设置效果
            cell.velocity = 150 //速度
            cell.velocityRange = 100 //Range这个属性配合Velocity用 表示有些Cell的速度 是150 - 100, 有些的是 250 ,也就是说 50 到 250
            //4 设置粒子大小
            cell.scale = 0.7        //缩放
            cell.scaleRange = 0.3   //缩放范围
            
            //4 设置粒子方向
            //        cell.emissionLatitude   //维度 水平方向
            //        cell.emissionLongitude  //精度 垂直方向
            cell.emissionLongitude = CGFloat(-M_PI_2)
            cell.emissionRange = CGFloat(M_PI_2 / 6)
            
            //4 设置粒子存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            //4 设置粒子旋转
            cell.spin = CGFloat(M_PI_2)
            cell.spinRange = CGFloat(M_PI_2 / 6 )
            
            //4 设置每秒中弹出 的个数
            cell.birthRate = 2
            
            //4设置粒子展示图片  int  i=arc4random()%n+1; 返回一个1～n的随机数给你 (不包括N)
            let imageNum = arc4random()%10
            let imageName = String(format : "good%d_30x30",imageNum)
            cell.contents = UIImage(named: imageName)?.cgImage
            
            
            
           
            
            cellArray.append(cell)
        }
        
        //5 将粒子设置到发射器
        emitter.emitterCells = cellArray
        
        view.layer.addSublayer(emitter)
    }
    
    func emitterStop(){
        /*
        for layer in view.layer.sublayers! {
            if layer.isKind(of: CAEmitterLayer.self){
                layer.removeFromSuperlayer()
            }
        }
 */
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self) }).first?.removeFromSuperlayer()
        
    }
}
