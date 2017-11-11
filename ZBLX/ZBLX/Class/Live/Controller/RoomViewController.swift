//
//  RoomViewController.swift
//  ZBLX
//
//  Created by sia on 2017/11/10.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//
//粒子系统 : 粒子系统是由总体具有相同的表现规律,个体却随机表现不同的特征的大量显示元素构成的集合 ,三要素 1群体性 2 统一性 3随机性
//应用中表现 1主播房间右下角粒子动画  2 天气预报: 雪花/下雨/烟花等效果/    3QQ生日快乐一堆表情的跳动

import UIKit

class RoomViewController: UIViewController,EmitterAnimation {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

// MARK: - 事件
extension RoomViewController {
    @IBAction func outLive(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomButtonClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("聊天")
        case 1:
            print("分享")
        case 2:
            print("礼物")
        case 3:
            print("菜单")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? emitterStart(point) : emitterStop()
            print("空间")
        default: break
        }
        
    }
}
