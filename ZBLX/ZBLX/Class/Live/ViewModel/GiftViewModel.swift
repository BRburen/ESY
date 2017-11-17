//
//  GiftViewModel.swift
//  ZBLX
//
//  Created by sia on 2017/11/17.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class GiftViewModel {
    lazy var giftlistData : [GiftPackage] = [GiftPackage]()
}

extension GiftViewModel {
    func loadGiftData(finishedCallBack: @escaping () -> ()){
        if giftlistData.count != 0 {finishedCallBack()}
        NetworkToos.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios", parameters: ["type" : 0,"page" : 1,"rows" : 150],finishiedCallback: { result in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataDict = resultDict["message"] as? [String : Any] else { return }
            
            for i in 0..<dataDict.count {
                guard let dict = dataDict["type\(i + 1)"] as? [String : Any] else { continue }
                self.giftlistData.append(GiftPackage(dict: dict))
            }
            /*          函数是变成
             在接口中可以看到有些是没有表情数组的就是说空
             t属性表示里面有多少个表情 如果t == 0 那么就不要了 Filter 筛选
             按表情 个数 排序 比较所有模型 t 大的排在前面 sorted
             */
            self.giftlistData = self.giftlistData.filter({return $0.t != 0}).sorted(by: {return $0.t > $1.t})
            
            finishedCallBack()
        })
    }
}
