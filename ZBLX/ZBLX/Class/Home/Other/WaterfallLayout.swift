//
//  WaterfallLayout.swift
//  WaterFalloLayout
//
//  Created by sia on 2017/11/2.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDataSource : class{
    func numberOfCols(_ waterfallLayout : WaterfallLayout) ->Int
    func waterfall(_ waterfallLayout : WaterfallLayout , item : Int) -> CGFloat
}

class WaterfallLayout: UICollectionViewFlowLayout {
    weak var dataSource : WaterfallLayoutDataSource?
    fileprivate lazy var cellAttr = [UICollectionViewLayoutAttributes]()
    
    fileprivate lazy var cols : Int = {
        return self.dataSource?.numberOfCols(self) ?? 2
    }()
    
    fileprivate lazy var totalHeight : [CGFloat] = Array(repeatElement(sectionInset.top, count: self.cols) )

}
// MARK: - 准备布局
extension WaterfallLayout{
    override func prepare() {
        super.prepare()
        
        
        //  !!! 每一个Cell对应一个 -> UICollectionViewLayoutAttributes  Cell的位置和大小是由它来决定的
        
        
        
        //获取Cell的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        //给每一个Cell创建UICollectionViewLayoutAttributes
        let cellW : CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        for i in 0..<itemCount{
            //1根据其创建IndexPath
            let indexPath = IndexPath(item: i, section: 0)
            //根据indexPath创建对应的UIcollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            //3设置attribute的frame
            guard let cellH : CGFloat = dataSource?.waterfall(self, item: i) else{
                fatalError("请实现对应的数据源方法,并返回Cell高度 ")
            }
            
            
            //先计算出最短那一列的高度
            let minH : CGFloat = totalHeight.min()!
            //再计算出是那一列 Index
            let minIndex = totalHeight.index(of: minH)!
            //再计算X
            let cellX : CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            
            
            let  cellY : CGFloat = minH + minimumLineSpacing
            
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            //4保存attributes
            cellAttr .append(attr)
            
            //5 添加昂前的高度
            totalHeight[minIndex] = minH + minimumLineSpacing + cellH
        }
    }
}

// MARK: - 返回准备好的所有布局
extension WaterfallLayout{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttr
    }
}

// MARK: - 设置contentSize {
extension WaterfallLayout{
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 0, height: totalHeight.max()! + sectionInset.bottom)
    }
}
