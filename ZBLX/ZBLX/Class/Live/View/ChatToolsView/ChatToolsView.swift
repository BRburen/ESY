//
//  ChatToolsView.swift
//  ZBLX
//
//  Created by sia on 2017/11/16.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

protocol ChatToolsViewDelegate : class{
    func chatToolsView(toolView : ChatToolsView , message : String)
}

class ChatToolsView: UIView, Nibloadable {

    @IBOutlet weak var inoutTextFiled: UITextField!
    @IBOutlet weak var senMsgBtn: UIButton!
    
    weak var delegate : ChatToolsViewDelegate?
    fileprivate lazy var emoticonBtn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    fileprivate lazy var emoticonView : EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}

// MARK: - 事件监听
extension ChatToolsView {
    //文字发生变化
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
        senMsgBtn.isEnabled = sender.text!.count != 0
    }
    
    //点击发送按钮
    @IBAction func senBtnClick(_ sender: UIButton) {
        let massage = inoutTextFiled.text!
        
        //清空内容
        inoutTextFiled.text = ""
        sender.isEnabled = false
        
        //DelegateSendMassage
        self.delegate?.chatToolsView(toolView: self, message: massage)
    }
    @objc fileprivate func emoticonBtnClick(_ btn : UIButton){
        btn.isSelected = !btn.isSelected
        
        //切换键盘 (表情和文字)
//        inoutTextFiled.inputView = nil //   表示默认键盘
        
        //切换需要先 失去第一响应
        let range = inoutTextFiled.selectedTextRange    //解决光标问题
        inoutTextFiled.resignFirstResponder()
        inoutTextFiled.inputView = inoutTextFiled.inputView == nil ? emoticonView : nil   //如果是默认键盘的时候 切换成UISwitch ,UISwitch的时候切换成nil(也就是默认键盘)
        inoutTextFiled.becomeFirstResponder()
        inoutTextFiled.selectedTextRange = range    //解决光标问题
    }
}

extension ChatToolsView {
    func setupUI(){
        
        //测试代码
        /*
        let attrString = NSAttributedString(string: "hahaha", attributes: [NSForegroundColorAttributeName : UIColor.red])
        inoutTextFiled.attributedText = attrString
        */
        
        //设置表情按钮
        emoticonBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        
        //给TextField设置RightView赋值
        inoutTextFiled.rightView = emoticonBtn
        inoutTextFiled.rightViewMode = .always
        inoutTextFiled.allowsEditingTextAttributes = true
        
        // MARK: - 闭包传值
        emoticonView.emoticonClickCallBack = {[weak self] emoticon -> Void in
            // 判断是否是删除按钮
            if emoticon.emoticonName == "delete-n"{
                self?.inoutTextFiled.deleteBackward()
                return
            }
            //获取光标的位置
            guard let range = self?.inoutTextFiled.selectedTextRange else {return}
            self?.inoutTextFiled.replace(range, withText: emoticon.emoticonName)
            
            //测试代码
//            let attachment = NSTextAttachment()
//            attachment.image = UIImage(named : emoticon.emoticonName)
//            let attrString = NSAttributedString(attachment: attachment)
//            self?.inoutTextFiled.
            
            
            
        }
    }
    
}
