//
//  ContentView.swift
//  ContentViewSwift
//
//  Created by sia on 2017/10/31.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

@objc protocol ContentViewDelegate : class {
    
    func contentView(_ contentView : ContentView, targetIndex : Int ,sourceIndex : Int,  progress : CGFloat)
    
   @objc optional func contentViewEndScroll(_ contentView : ContentView)
}

private let kContentCellID = "ContentCellID"

class ContentView: UIView {
    
    weak var delegate : ContentViewDelegate?
    
    fileprivate var isForbidScrollDelegate : Bool = false
//    fileprivate lazy var useDelegate : Bool = true
    
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var childVcs : [UIViewController]!
    fileprivate var parentVc : UIViewController!
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.frame = self.bounds
        return collectionView
    }()
    
    @objc init(frame: CGRect , childVcs : [UIViewController] , parentVc : UIViewController) {
        
        super.init(frame: frame)
        
        self.childVcs = childVcs
        self.parentVc = parentVc
        setuoUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ContentView{
    fileprivate func setuoUI(){
        //将子控制器添加到夫控制器中
        for childVc in childVcs{
            parentVc.addChildViewController(childVc)
        }
        
        //添加UICollectionView
        addSubview(collectionView)
    }
}

extension ContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK: - UIcollectionViewDelegate
extension ContentView : UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate { return }
        
        //2 定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //3 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {  //左滑
            //1 计算Progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            //2 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            
            //3 计算TargetIndex
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            
            //4 如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            //1 计算Progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //2 计算TargetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //3 计算sourceIndex
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        delegate?.contentView(self, targetIndex: targetIndex, sourceIndex: sourceIndex, progress: progress)
//        print("---\(progress)---\(sourceIndex)---\(targetIndex)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll?(self)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.contentViewEndScroll?(self)
        }
    }
}



// MARK:- 对外暴露的方法
extension ContentView {
    func setCurrentIndex(_ currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}














































