//
//  ContenerView.swift
//  ContentViewSwift
//
//  Created by sia on 2017/10/31.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class ContenerView: UIView {
    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var titleStyle : TitleStyle
    
    fileprivate var titleView : TitleView!
    
    init(frame : CGRect , titles :[String] , childVcs : [UIViewController], parentVc : UIViewController , titleStyle : TitleStyle){
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titleStyle = titleStyle
        // MARK: - 重写便利构造函数必须条用super.init
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI界面
extension ContenerView{
    fileprivate func setupUI(){
        setupTitleView()
        setupContentView()
    }
    private func setupTitleView(){
        
        let titleFrame = CGRect(x: 0, y: 0, width: Int(bounds.width), height: Int(self.titleStyle.titleHeight))
        titleView = TitleView(frame: titleFrame, titles: titles,titleStyle
            : self.titleStyle)
        titleView.backgroundColor = UIColor.white
        
        addSubview(titleView)
    }
    private func setupContentView(){
        let contentViewFrame = CGRect(x: 0, y: titleStyle.titleHeight, width: bounds.width, height: bounds.height - titleStyle.titleHeight)
        let contentView = ContentView(frame: contentViewFrame, childVcs: childVcs, parentVc: parentVc)
        contentView.backgroundColor = UIColor.randomColor()
        addSubview(contentView)
        
        //设置代理
        titleView.delegate = contentView
        
        contentView.delegate = titleView
    }
}
