//
//  ClientSocket.swift
//  ClientSockt
//
//  Created by sia on 2017/11/17.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit



import SwiftSocket

protocol ClientSocketDelegate : class{
    func socket(_ socket : ClientSocket, joinRoom user : UserInfo)
    func socket(_ socket : ClientSocket, leaveRoom user : UserInfo)
    func socket(_ socket : ClientSocket, textMessage : TextMessage)
    func socket(_ socket : ClientSocket, giftMessage : GirftMessage)
}


class ClientSocket: NSObject {
    fileprivate var tcpClient : TCPClient
    var delegate : ClientSocketDelegate?
    fileprivate var userInfo : UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "why\(arc4random_uniform(10))"
        userInfo.level = 20
        userInfo.iconUrl = "url"
        return userInfo
    }()
    
    init(addr : String , port : Int) {
        tcpClient = TCPClient(address: addr, port: Int32(port))
    }
}


extension ClientSocket {
    @discardableResult
    func connectSever() -> (Bool){
        let result = tcpClient.connect(timeout: 5)
        if result.isSuccess {
            return true
        }else{
         return false
        }
    }
    
   
    
    func startReadMsg(){
        DispatchQueue.global().async {
            while true {
                guard let msg = self.tcpClient.read(4) else {continue}
                
                    //读取Header的长度
                    let headerData = Data(bytes: msg, count: 4)
                    var length : Int = 0
                    (headerData as NSData).getBytes(&length, length: 4)
                    
                    //读取类型
                    guard let messageType = self.tcpClient.read(2) else { return }
                    let typeData = Data(bytes: messageType, count: 2)   //把类型转换成Data
                    var type : Int = 0
                
                    (typeData as NSData).getBytes(&type, length: 2)     //获取类型的长度
//                    print("type = \(type)")                             //获取类型
                
                    //                print(length)
                    //根据长度读取真正的消息
                    guard let trueMsg = self.tcpClient.read(length) else { return }
                    let data = Data(bytes: trueMsg, count: length)
                    
                    //处理消息
                DispatchQueue.main.async {
                    self.handleMsg(type: type, data: data)
                }
            }
        }
    }
    fileprivate func handleMsg(type : Int ,data : Data){
        switch type {
        case 0, 1:
            let user = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            let textMessage = try! TextMessage.parseFrom(data: data)
            delegate?.socket(self, textMessage: textMessage)
        case 3:
            let giftMessage = try! GirftMessage.parseFrom(data: data)
            delegate?.socket(self, giftMessage: giftMessage)
        default:
            print("位置消息")
        }
    }
}


extension ClientSocket {
    func sendJionRoom(){
        //转成data
        let msgData = (try! userInfo.build()).data()
        //发送消息
        sendMsg(data: msgData, type: 0)
    }
    
    func sendLeaveRoom(){
        //转成data
        let msgData = (try! userInfo.build()).data()
        //发送消息
        sendMsg(data: msgData, type: 1)
    }
    
    func sendTextMsg(message : String){
        
        let textMsg = TextMessage.Builder()
        textMsg.user = userInfo.buildPartial()
        textMsg.text = message
        //转成data
        let messageData = (try! textMsg.build()).data()
        //发送消息
        sendMsg(data: messageData, type: 2)
    }
    
    func sendGiftMsg(giftName : String ,giftUrl : String ,giftCount : Int){
        let giftMessage = GirftMessage.Builder()
        giftMessage.user = userInfo.buildPartial()
        giftMessage.giftName = giftName
        giftMessage.giftUrl = giftUrl
        giftMessage.giftCount = Int64(giftCount)
        
        //转成data
        let messageData = (try! giftMessage.build()).data()
        //发送消息
        sendMsg(data: messageData, type: 3)
    }
    
    func sendHeartBeat(){
        //获取心跳包的数据
        let heartString = "I am is heart beat;"
        let heartData = heartString.data(using: .utf8)
        //发送数据
        sendMsg(data: heartData!, type: 100)
    }
    
   fileprivate func sendMsg( data : Data ,type : Int){
        
        //将消息的长度,写入到Data里面
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)     //count 是HeaderData 的固定长度 方便服务器读取
        
        //设定类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        //完整消息 消息 + 消息类型 + 消息头
        let total = headerData + typeData + data
        
        tcpClient.send(data: total)
    }
}












