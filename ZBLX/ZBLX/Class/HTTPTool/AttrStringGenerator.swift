//
//  AttrStringGenerator.swift
//  ZBLX
//
//  Created by sia on 2017/11/24.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit
import Kingfisher
class AttrStringGenerator {

}

extension AttrStringGenerator {
    class func generateJoinLeaveRoom(_ userName : String, _ isJoin : Bool) -> NSAttributedString{
        
        let roomString = userName + (isJoin ? "进入房间" : "离开房间")
        let roomMAttr = NSMutableAttributedString(string: roomString)
        roomMAttr.addAttributes([NSForegroundColorAttributeName : UIColor.orange], range: NSRange(location: 0, length: userName.count) )
        return roomMAttr
    }
    
    class func generateTextMessage(_ userName : String, _ message : String) ->NSAttributedString{
        
        //获取整个字符串
        let chatMessage = "\(userName) : \(message)"
        //修改名称
        let chatMessageMAttr = NSMutableAttributedString(string: chatMessage)
        chatMessageMAttr.addAttributes([NSForegroundColorAttributeName : UIColor.orange], range: NSRange(location: 0, length: userName.count) )
        
        //匹配表情 并且替换
        //创建正则表达式 匹配表情 [哈哈]
        /* [] 在正则表达式中有特殊含义 [0-9] 表示0到9 [a-z] a到z
         进行转义 \ 但是 反斜杠在Swift中也有特殊含义 所以 在把反斜杠进行再次转义 \\
         . 点 表示 任意字符
         * 星 表示多个字符
         ? 问号 如果文本是 [哈哈] [嘻嘻] 的话不加问号 只会匹配到一个! 加了?之后 单独匹配
         在Swift中如果参数是枚举 的 话享用默认值的话 可以输入 []
         
         在任何一种语言 中正则表达式变量 regex 表达 规范
         */
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {return chatMessageMAttr}
        
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.count))
        
        //遍历表情
        let font = UIFont.systemFont(ofSize: 15)
        for i in (0..<results.count).reversed(){
            let result = results[i]
            let emoticon = ((chatMessage as NSString).substring(with: result.range))
            //获取图片
            guard let image = UIImage(named: emoticon) else{ continue }
            
            //根据图片创建NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: -2, width: font.lineHeight, height: font.lineHeight)    //他这个Y是从下往上的 所以要减 X是一样的
            //根据NSTextAttachment创建 富文本
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            //之后替换之前文本的位置
            chatMessageMAttr.replaceCharacters(in: result.range, with: imageAttrStr)
            
        }
        return chatMessageMAttr
    }
    
    class func generateGiftMessage( _ giftName : String , _ user : String ,_ url : String) ->NSAttributedString{
        
        let font = UIFont.systemFont(ofSize: 15)
        
        let sendGiftMessage = "\(user)赠送 \(giftName)"
        let sendGfitMAttrMsg = NSMutableAttributedString(string: sendGiftMessage)
        //修改名称
        sendGfitMAttrMsg.addAttributes([NSForegroundColorAttributeName : UIColor.orange], range: NSRange(location: 0, length: user.count))
        
        //修改礼物的名称
        let range = (sendGiftMessage as NSString).range(of: giftName)
        sendGfitMAttrMsg.addAttributes([NSForegroundColorAttributeName : UIColor.red], range: range)
        
        //拼接礼物的图片
        //        guard let giftURL = URL(string: giftMessage.giftUrl)else{ return }
        //        KingfisherManager.shared.downloader.downloadImage(with: giftURL) { (image, error, url, data) in
        //
        //        }
        //内存中取
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: url) else{
            return sendGfitMAttrMsg
        }
        let attacement = NSTextAttachment()
        attacement.image = image
        attacement.bounds = CGRect(x: 0, y: -2, width: font.lineHeight, height: font.lineHeight)
        //获取富文本
        let imageAttrStr = NSAttributedString(attachment: attacement)
        //拼接
        sendGfitMAttrMsg.append(imageAttrStr)
        //发送显示
        return sendGfitMAttrMsg

    }
    
}
