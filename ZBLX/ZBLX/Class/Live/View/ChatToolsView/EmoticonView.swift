//
//  Emoticon.swift
//  ZBLX
//
//  Created by sia on 2017/11/16.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//  表情键盘

import UIKit

let kEmoticonCellID = "emoticonCellID"


class EmoticonView: UIView {
    
    var emoticonClickCallBack : ((Emoticon) -> Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmoticonView{
    fileprivate func setupUI(){
    //创建PagecollectionView
        let style = TitleStyle()
        style.isShowScrollLine = true
        let layout = PageCollectionViewLayout()
        layout.cols = 7
        layout.rows = 3
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let pagecollectionView = PageCollectionView(frame: bounds, titles: ["普通","粉丝专属"], styl: style, isTitleInTop: false, layout: layout)
        pagecollectionView.dataSource = self
        pagecollectionView.delegate = self
        pagecollectionView.register(nib: UINib(nibName: "EmoticonViewCell", bundle: nil) , identifier: kEmoticonCellID)
        addSubview(pagecollectionView)
    }
}

extension EmoticonView : PageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: PageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonViewModel.shareInstance.packages[section].emoticons.count
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emotion = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
    
     
}

extension EmoticonView : PageCollectionViewDelegate{
    func pageCollectionView(_ pageCollectionView: PageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        if let emoticonClickCallBack = emoticonClickCallBack {  //校验
            emoticonClickCallBack(emoticon)
        }
    }
    
    
}


