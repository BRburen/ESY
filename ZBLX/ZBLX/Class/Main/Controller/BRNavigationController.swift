//
//  BRNavigationController.swift
//  ZBLX
//
//  Created by sia on 2017/10/30.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class BRNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var count = UInt32()
//        let iVar = class_copyIvarList(UIGestureRecognizer.self, &count)!
//        for i in 0..<count {
//            let nameP = ivar_getName(iVar[Int(i)])!
//            let name = String(cString: nameP)
//            print(name)
//        }
        
        guard let targets = interactivePopGestureRecognizer?.value(forKey: "_targets") as? [NSObject] else{ return }
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let painGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(painGes)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: true)
    }
    
    
    
}
