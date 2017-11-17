//
//  GiftListView.swift
//  ZBLX
//
//  Created by sia on 2017/11/16.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

let kGifyCellID = "GifyCellID"



protocol GiftListViewDelegate : class {
    func giftListView(_ giftListView : GiftListView , _ giftModel : GiftModel)
}

class GiftListView: UIView,Nibloadable{

    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    
    weak var delegate : GiftListViewDelegate?
    
    fileprivate var pageCollectionView : PageCollectionView!
    fileprivate var giftViewModel = GiftViewModel()
    fileprivate var titleView : TitleView!
    fileprivate var currentIndex : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //初始化礼物 View
        setupGiftView()
        
        //加载数据
        loadData()
    }

}

extension GiftListView {
    func setupGiftView(){
        
        let style = TitleStyle()
        style.isScrollEnable = false
        style.isShowScrollLine = true
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        
        let laout = PageCollectionViewLayout()
        laout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        laout.minimumLineSpacing = 5
        laout.minimumInteritemSpacing = 5
        laout.cols = 4
        laout.rows = 2
        
        var pageCollectionViewFrame = giftView.bounds
        pageCollectionViewFrame.size.width = kScreenW
        print(pageCollectionViewFrame)
        pageCollectionView = PageCollectionView(frame: pageCollectionViewFrame, titles: ["热门","高级","豪华","专属"], styl: style, isTitleInTop: true, layout: laout)
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.register(nib: UINib(nibName: "GiftViewCell", bundle: nil), identifier: kGifyCellID)
        giftView.addSubview(pageCollectionView)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var pageCollectionViewFrame = giftView.bounds
        pageCollectionViewFrame.size.width = kScreenW
        pageCollectionView.frame = pageCollectionViewFrame
    }

}



extension GiftListView {
    func loadData(){
        giftViewModel.loadGiftData {
            self.pageCollectionView.reloadData()
        }
    }
}


extension GiftListView : PageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: PageCollectionView) -> Int {
        return giftViewModel.giftlistData.count
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftViewModel.giftlistData[section].list.count
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGifyCellID, for: indexPath) as! GiftViewCell
        cell.giftModel = giftViewModel.giftlistData[indexPath.section].list[indexPath.item]
        return cell
    }
    
    
}

extension GiftListView : PageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: PageCollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath
        sendGiftBtn.isEnabled = true
    }
    
    @IBAction func sendGiftBtnClick(_ sender: UIButton) {
        let giftModel = giftViewModel.giftlistData[(currentIndex?.section)!].list[(currentIndex?.item)!]
        self.delegate?.giftListView(self, giftModel)
    }
    
}



















