//
//  PageCollectionViewLayout.swift
//  PageView扩展
//
//  Created by sia on 2017/11/14.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class PageCollectionViewLayout: UICollectionViewFlowLayout {
    var cols : Int = 4      //列数 默认4
    var rows : Int = 2      //行数 默认2
    fileprivate lazy var layoutAttributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var maxW : CGFloat = 0
}


extension PageCollectionViewLayout{
    override func prepare() {
        super.prepare()
        
    //计算Item 的 宽度 和高度
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        
        
        let secionCount = collectionView!.numberOfSections
    //获取每组中有多少个页 (一开始前面0页)
        var prePageCont : Int = 0
        for i in 0..<secionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            for j in 0..<itemCount {
                let indexPath = IndexPath(item: j, section: i)
                let collectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            //获取该组(Section)第几页 (默认8个为一页)
                let page = j / (cols * rows)
            //获取该页中的第几个
                let index = j % (cols * rows)
                // MARK: - CGFloat(prePageCont + page)  自己前面的页数 + 本组是否有多页 (也就是说 (cols * rows)是一个 超过的话就是下一页  )
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                let itemX = CGFloat(prePageCont + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                collectionViewLayoutAttributes.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                layoutAttributes.append(collectionViewLayoutAttributes)
            }
            // MARK: - 这是一个算法 利用Item的个数计算前面有多少页
            prePageCont += (itemCount - 1) / (cols * rows) + 1
        }
        maxW = CGFloat(prePageCont) * collectionView!.bounds.width
    }
}


extension PageCollectionViewLayout{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
}


extension PageCollectionViewLayout{
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxW, height: 0)
    }
}
