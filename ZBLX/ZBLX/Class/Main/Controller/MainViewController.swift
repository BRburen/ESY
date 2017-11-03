//
//  MainViewController.swift
//  ZBLX
//
//  Created by sia on 2017/10/29.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVc(storyName: "Home")
        addChildVc(storyName: "Rank")
        addChildVc(storyName: "Discover")
        addChildVc(storyName: "Profile")
        print("aaa")
    }
    
    private func addChildVc(storyName : String){
        //通过storyboard 获取控制器// MARK: -
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        //将ChildVc添加到自控制器// MARK: -
        addChildViewController(childVc)
    }
}
