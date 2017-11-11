//
//  AnchorViewController.swift
//  ZBLX
//
//  Created by sia on 2017/11/5.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit
private let kEgeMraign : CGFloat = 8
private let kaAnchorCellID = "kAnchorCellID"
class AnchorViewController: UIViewController {
    
    
    // MARK: - 对外属性
    var homeType : HomeType!
    
    // MARK: - 定义属性
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    fileprivate lazy var collectionView : UICollectionView = {
        let layout : WaterfallLayout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEgeMraign, left: kEgeMraign, bottom: kEgeMraign, right: kEgeMraign)
        layout.minimumLineSpacing = kEgeMraign
        layout.minimumInteritemSpacing = kEgeMraign
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kaAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadData(index: 0)
    }
    
    
    
}

extension AnchorViewController{
    fileprivate func loadData(index : Int){
        homeVM.loadHomeData(type: homeType, index: index , finishedCallback: {
            self.collectionView.reloadData()
        })
    }
}


// MARK: - UI设置
extension AnchorViewController {
    fileprivate func setupUI(){
        view.addSubview(collectionView)
    }
}
// MARK: - 代理协议
extension AnchorViewController : WaterfallLayoutDataSource ,UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVc = RoomViewController()
        navigationController?.pushViewController(roomVc, animated: true)
    }
    
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kaAnchorCellID, for: indexPath) as! HomeViewCell
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        if indexPath.item == homeVM.anchorModels.count - 1{
            loadData(index: homeVM.anchorModels.count)
            
        }
        return cell
    }
}








