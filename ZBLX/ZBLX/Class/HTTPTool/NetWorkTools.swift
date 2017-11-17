//
//  NetWorkTools.swift
//  ZBLX
//
//  Created by sia on 2017/11/4.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import Foundation
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkToos{
    class func requestData(_ type : MethodType,URLString : String ,parameters : [String : Any]? = nil,finishiedCallback : @escaping (_ result : Any) -> ()){
        //  1获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finishiedCallback(result)
        }
    }
}
