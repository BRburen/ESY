//
//  PageCollectionView.swift
//  PageView扩展
//
//  Created by sia on 2017/11/14.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit


// MARK: - 设置数据源
protocol PageCollectionViewDataSource : class {
    func numberOfSections(in pageCollectionView: PageCollectionView) -> Int
    func pageCollectionView(_ pageCollectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: PageCollectionView, _ collectionView : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}


protocol PageCollectionViewDelegate : class{
     func pageCollectionView(_ pageCollectionView: PageCollectionView, didSelectItemAt indexPath: IndexPath)
}


// MARK: - 初始化
class PageCollectionView: UIView {
    
    weak var dataSource : PageCollectionViewDataSource?
    weak var delegate : PageCollectionViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var isTitleInTop : Bool
    fileprivate var layout : PageCollectionViewLayout
    fileprivate var styl : TitleStyle
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageConteroller : UIPageControl!
    fileprivate var currentIndexPath : IndexPath = IndexPath(item: 0, section: 0 )
    fileprivate var titleView : TitleView!
    init(frame : CGRect, titles : [String], styl : TitleStyle , isTitleInTop : Bool, layout : PageCollectionViewLayout){
        
        self.titles = titles
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        self.styl = styl
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - 设置UI
extension PageCollectionView {
    fileprivate func setupUI (){
    //创建TItleView
        let titleY = isTitleInTop ? 0 : bounds.height - styl.titleHeight
        let frame = CGRect(x: 0, y: titleY, width: bounds.size.width, height: styl.titleHeight)
        titleView = TitleView(frame: frame, titles: titles, titleStyle: styl)
        titleView.backgroundColor = UIColor.white
        titleView.delegate = self
        addSubview(titleView)
        
    //创建PageController
        let pageControllerHeight : CGFloat = 20
        let pageControllerY = isTitleInTop ? bounds.height - pageControllerHeight : bounds.height - pageControllerHeight - styl.titleHeight
        let pageCntrollerFrame = CGRect(x: 0, y: pageControllerY, width: bounds.width, height: pageControllerHeight)
        pageConteroller = UIPageControl(frame: pageCntrollerFrame)
        pageConteroller.numberOfPages = 4
        pageConteroller.backgroundColor = UIColor.lightGray
        pageConteroller.isEnabled = false
        addSubview(pageConteroller)
        
    //创建UICollectionView
        let collectionViewY = isTitleInTop ? styl.titleHeight : 0
        let collectionFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - pageControllerHeight - styl.titleHeight)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
    }
}


// MARK: - 数据源赋值
extension PageCollectionView : UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0{
            pageConteroller.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegate
extension PageCollectionView : UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewEndScroll()
    }
    
    func scrollViewEndScroll(){
        let point = CGPoint(x: layout.sectionInset.left + collectionView.contentOffset.x + 1, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        if self.currentIndexPath.section != indexPath.section{
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageConteroller.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            titleView.setTitleWithProgress(targetIndex: indexPath.section, sourceIndex: currentIndexPath.section, progress: 1)
            self.currentIndexPath = indexPath
        }
        pageConteroller.currentPage = (indexPath.item) / (layout.cols * layout.rows)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension PageCollectionView : TitleViewDelegate{
    func titleView(_ titleView: TitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: 0, section: targetIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }
}

// MARK: - 对外暴露方法 注册Cell
extension PageCollectionView {
    func register(cellClass : AnyClass?,identifier : String ){
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    func register(nib: UINib?, identifier : String){
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}









