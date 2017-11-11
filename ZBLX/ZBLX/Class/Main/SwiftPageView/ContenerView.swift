//
//  ContenerView.swift
//  ContentViewSwift
//
//  Created by sia on 2017/10/31.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class ContenerView: UIView {
    fileprivate var titles : [String]!
    fileprivate var childVcs : [UIViewController]!
    fileprivate var parentVc : UIViewController!
    fileprivate var titleStyle : TitleStyle!
    
    fileprivate var titleView : TitleView!
    fileprivate var contentView : ContentView!
    init(frame : CGRect , titles :[String] , childVcs : [UIViewController], parentVc : UIViewController , titleStyle : TitleStyle){
        // MARK: - 重写便利构造函数必须条用super.init
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titleStyle = titleStyle
        
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI界面
extension ContenerView{
    fileprivate func setupUI(){
        
        let titleH : CGFloat = 44
        
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = TitleView(frame: titleFrame, titles: titles,titleStyle : self.titleStyle)
        titleView.backgroundColor = UIColor.white
        addSubview(titleView)
        
        let contentViewFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = ContentView(frame: contentViewFrame, childVcs: childVcs, parentVc: parentVc)
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        addSubview(contentView)
        
        //设置代理
        titleView.delegate = self
        contentView.delegate = self
        
        
        
    }
}

extension ContenerView : TitleViewDelegate{
    func titleView(_ titleView: TitleView, targetIndex: Int) {
        contentView.setCurrentIndex(targetIndex)
    }
    
    
}

extension ContenerView : ContentViewDelegate{
    func contentViewEndScroll(_ contentView: ContentView) {
        titleView.contentViewDidEndScroll()
    }
    
    func contentView(_ contentView: ContentView, targetIndex: Int, sourceIndex: Int, progress: CGFloat) {
        
        titleView.setTitleWithProgress(targetIndex: targetIndex, sourceIndex: sourceIndex, progress: progress)
    }
    
    
}
