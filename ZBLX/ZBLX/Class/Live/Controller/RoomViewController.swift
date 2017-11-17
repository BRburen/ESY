//
//  RoomViewController.swift
//  ZBLX
//
//  Created by sia on 2017/11/10.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//
//粒子系统 : 粒子系统是由总体具有相同的表现规律,个体却随机表现不同的特征的大量显示元素构成的集合 ,三要素 1群体性 2 统一性 3随机性
//应用中表现 1主播房间右下角粒子动画  2 天气预报: 雪花/下雨/烟花等效果/    3QQ生日快乐一堆表情的跳动

import UIKit


fileprivate let kChatToolViewHeight : CGFloat = 44
fileprivate let kGiftListViewHeight : CGFloat = kScreenH * 0.5

class RoomViewController: UIViewController,EmitterAnimation {
    
    @IBOutlet weak var bgImageView: UIImageView!
    fileprivate lazy var chatToolView : ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftView : GiftListView = GiftListView.loadFromNib()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        watchKeyBourd()
        
    }
}

// MARK: - 设置UI
extension RoomViewController{
    fileprivate func setupUI(){
        setupBlurView()
        setupBottomView()
        setupGiftLiseView()
    }
    //设置毛玻璃
    private func setupBlurView(){
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    //设置输入框
    private func setupBottomView(){
        chatToolView.frame = CGRect(x: 0, y: kScreenH, width: view.bounds.width, height: kChatToolViewHeight)
        chatToolView.autoresizingMask = [.flexibleTopMargin , .flexibleWidth]
        chatToolView.delegate = self
        view.addSubview(chatToolView)
    }
    
    private func setupGiftLiseView(){
        giftView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftListViewHeight)
        giftView.autoresizingMask = [.flexibleTopMargin , .flexibleWidth]
        giftView.delegate = self
        view.addSubview(giftView)
    }
}

// MARK: - 监听键盘弹出
extension RoomViewController {
    fileprivate func watchKeyBourd (){
        NotificationCenter.default.addObserver(self, selector: #selector(keybourdWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    @objc fileprivate func keybourdWillChangeFrame(_ note : Notification){
        
        let durantion = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolViewHeight
        
        UIView.animate(withDuration: durantion) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue : 7)!)
            let endY = inputViewY == (kScreenH - kChatToolViewHeight) ? kScreenH : inputViewY
            self.chatToolView.frame.origin.y = endY
            
        }
    }
}

// MARK: - 事件
extension RoomViewController {
    @IBAction func outLive(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolView.inoutTextFiled.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.giftView.frame.origin.y = kScreenH 
        })
    }
    
    @IBAction func bottomButtonClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            chatToolView.inoutTextFiled.becomeFirstResponder()
        case 1:
            print("分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.giftView.frame.origin.y = kScreenH - kGiftListViewHeight
            })
        case 3:
            print("菜单")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? emitterStart(point) : emitterStop()
            print("空间")
        default: break
        }
        
    }
}

// MARK: - ChatToolsViewDelegate
extension RoomViewController : ChatToolsViewDelegate{
    func chatToolsView(toolView: ChatToolsView, message: String) {
        print(message)
    }
}

// MARK: - GiftListViewDelegate
extension RoomViewController : GiftListViewDelegate{
    func giftListView(_ giftListView: GiftListView, _ giftModel: GiftModel) {
        print(giftModel.subject)
    }
    
    
}




