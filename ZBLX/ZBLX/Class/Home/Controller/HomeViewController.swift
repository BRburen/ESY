//
//  HomeViewController.swift
//  ZBLX
//
//  Created by sia on 2017/10/30.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
}

// MARK: - 设置UI界面
extension HomeViewController{
    fileprivate func setupUI(){
        setupNavigationBar()
        setupContenerView()
    }
    
    private func setupNavigationBar(){
        //1左侧LogoItem
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        //设置右侧收藏按钮
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectImageClick))
        
        //搜索 
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
        
    }
    
    fileprivate func setupContenerView(){
        //获取数据
        let homeTypes = loadTypesData()
        
        //2创建主题内容
        let styl = TitleStyle()
        styl.isShowShadow = true
        styl.isScrollEnable = true
        styl.isShowScrollLine = true
        styl.isNeedScale = true
        let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH)
        /*
         var titles = [String]()
         for type in homeTypes {
         titles.append(type.title)
         }
         */
        
        /*
         let titles = homeTypes.map { (type : HomeType) -> String in
         return type.title
         }
         */
        let titles = homeTypes.map({ $0.title })
        var childVcs = [AnchorViewController]()
        for type in homeTypes{
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        let pageView = ContenerView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, titleStyle: styl)
        view.addSubview(pageView)
    }
    
    fileprivate func loadTypesData() ->[HomeType]{
        
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [HomeType]()
        for dict in dataArray{
            tempArray.append(HomeType(dict: dict))
        }
        return tempArray
    }
}
// MARK: - 事件监听
extension HomeViewController{
    @objc fileprivate func collectImageClick(){
        
    }
}




