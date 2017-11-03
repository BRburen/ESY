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
        
        view.backgroundColor = UIColor.randomColor()
        setupUI()
        setupNavigationBar()
    }
}

// MARK: - 设置UI界面
extension HomeViewController{
    fileprivate func setupUI(){
        
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
    
    
    
}
// MARK: - 事件监听
extension HomeViewController{
    @objc fileprivate func collectImageClick(){
        
    }
}




