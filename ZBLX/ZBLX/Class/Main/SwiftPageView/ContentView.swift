//
//  ContentView.swift
//  ContentViewSwift
//
//  Created by sia on 2017/10/31.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

protocol ContentViewDelegate : class {
    func contentView(_ contentView : ContentView, targetIndex : Int)
    func contentView(_ contentView : ContentView, targetIndex : Int ,sourceIndex : Int,  progress : CGFloat)
}

private let kContentCellID = "ContentCellID"

class ContentView: UIView {
    
    weak var delegate : ContentViewDelegate?
    
    fileprivate lazy var useDelegate : Bool = true
    
    fileprivate var startOffset : CGFloat = 0
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
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
        return collectionView
    }()
    
    init(frame: CGRect , childVcs : [UIViewController] , parentVc : UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
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
        
        
        addSubview(collectionView)
    }
}

extension ContentView :UICollectionViewDataSource{
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
        cell.contentView .addSubview(childVc.view)
        return cell
    }
}

// MARK: - UIcollectionViewDelegate
extension ContentView : UICollectionViewDelegate{
    

    
    //减速过程
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{     //没有减速过程
            contentEndScroll()
        }
    }

    private func contentEndScroll(){
        //获取滚动到的位置
        let currentIndex = Int (collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentView(self, targetIndex: currentIndex)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !useDelegate {return}
        // 判断
        guard startOffset != scrollView.contentOffset.x else {
            return
        }
        //1 定义targetIndex Progress
        var targerIndex = 0
        let sourceIndex = Int (startOffset / scrollView.bounds.width)
        var progress : CGFloat = 0.0
        
        //2计算
        let currentIndex = Int (startOffset / scrollView.bounds.width)
        if startOffset < scrollView.contentOffset.x{    //左滑
            targerIndex = currentIndex + 1
            if targerIndex > childVcs.count - 1{
                targerIndex = childVcs.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffset) / scrollView.bounds.width
            
        }else{  //右滑
            targerIndex = currentIndex - 1
            if targerIndex < 0 {
                targerIndex = 0
            }
            progress = (startOffset - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        //3通知代理
        delegate?.contentView(self, targetIndex: targerIndex, sourceIndex : sourceIndex, progress: progress)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
    }
    
   
}

// MARK: - TitleViewDelegate
extension ContentView : TitleViewDelegate{
    func titleView(_ titleView: TitleView, targetIndex: Int) {
        useDelegate = false
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        useDelegate = true
    }
}
















































