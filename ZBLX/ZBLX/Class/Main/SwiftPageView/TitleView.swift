//
//  TitleView.swift
//  ContentViewSwift
//
//  Created by sia on 2017/10/31.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

protocol TitleViewDelegate : class {
    func titleView(_ titleView : TitleView , targetIndex : Int)
}


class TitleView: UIView {
    //weak 只能修饰对象!!! 如果我们的协议 Protocol TitleViewDelegate {} 这样写的话 !结构体 和 枚举 都可以继承这个协议 那么我们创建delegate 的时候一般使用weak来修饰 解决循环引用 ! 但是 我们的Delegate 有可能是 不是对象 不如是枚举,或者这是结构体 那么就会有冲突 !
    //解决方 我们在协议后面明确表示这个协议只能被Class遵守 !Protocol TitleViewDelegate : class 这样的话我们可以 使用weak 来修饰 delegate 了 !不会冲突
    weak var delegate : TitleViewDelegate?
    
    fileprivate var titles : [String]!
    fileprivate var titleStyle : TitleStyle!
    fileprivate lazy var currentIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    //线
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
//        bottomLine.backgroundColor = self.titleStyle.scrollLineColor
        bottomLine.backgroundColor = UIColor.black
        bottomLine.frame.size.height = self.titleStyle.scrollLineH
        bottomLine.frame.origin.y = self.bounds.height - self.titleStyle.scrollLineH
        return bottomLine
    }()
    //阴影
    fileprivate lazy var shadowLabel : UILabel = {
      let shadowLabel = UILabel()
        shadowLabel.backgroundColor = self.titleStyle.shadowColor
        shadowLabel.layer.cornerRadius = 3
        shadowLabel.layer.masksToBounds = true
        shadowLabel.alpha = self.titleStyle.shadowAlpha
        return shadowLabel
    }()
    
    init(frame: CGRect , titles : [String], titleStyle : TitleStyle) {
        super.init(frame: frame)
        self.titles = titles
        self.titleStyle = titleStyle
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleView {
    fileprivate func setupUI(){
        //将ScrollView添加到view中
        addSubview(scrollView)
        
        //将titleLabel添加到scrollView
        setupTitleLabel()
        
        //设置TItlelabel的frame
        setupTitleLabelFrame()
        
        //添加滚动条
        if titleStyle.isShowScrollLine{
            setupBottomLine()
            
        }
        //阴影添加
        if titleStyle.isShowShadow{
            setupShadow()
        }
    }
    

    // MARK: - 添加TitleLabel设置事件
    private func setupTitleLabel(){
        for (i, title) in titles.enumerated(){
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.font = titleStyle.font
            
            titleLabel.textColor = i == 0 ? titleStyle.selectColor : titleStyle.normalColor
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLaabelClick(_ :)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
//            titleLabel.backgroundColor = UIColor.yellow
            titleLabels.append(titleLabel)
            
            scrollView.addSubview(titleLabel)
        }
    }
    // MARK: - 设置TitleLabel的Frame
    private func setupTitleLabelFrame(){
        let count = titleLabels.count
        
        var titleW : CGFloat = 0
        var titleX : CGFloat = 0
        let titleY : CGFloat = 0
        let titleH : CGFloat = frame.size.height
        
        for (i, label) in titleLabels.enumerated(){
            if titleStyle.isScrollEnable {  //可以滚动
//                w = (titles[i] as NSString).boundingRect(with:CGSize(width: CGFloat(MAXFLOAT), height: 0) , options:.usesLineFragmentOrigin , attributes: [NSAttributedStringKey.font : label.font] ,context: nil).width
                titleW = (titles[i] as NSString).boundingRect(with:CGSize(width: CGFloat(MAXFLOAT), height: 0) , options:.usesLineFragmentOrigin , attributes: [NSFontAttributeName : label.font] ,context: nil).width
                if i == 0{
                    
                    titleX = titleStyle.itemMargin * 0.5

                }else{
                    
                    let preLabel = titleLabels[i - 1]
                    titleX = preLabel.frame.maxX + titleStyle.itemMargin
                    
                }
            }else{      //不滚动
                
                titleW = bounds.width / CGFloat(count)
                titleX = titleW * CGFloat(i)
                
            }
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            // MARK: - 字体方法
            if i == 0 {
                let scale = titleStyle.isNeedScale ? titleStyle.scaleRange : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        
        
//        scrollView.contentSize = titleStyle.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + titleStyle.itemMargin * 0.5, height: 0) : CGSize.zero
        if titleStyle.isScrollEnable{
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + titleStyle.itemMargin * 0.5, height: 0)
        }
    }
    // MARK: - 设置BottomLineFrame
    func setupBottomLine(){
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = titleStyle.scrollLineH
        bottomLine.frame.origin.y = bounds.height - titleStyle.scrollLineH
    }
    // MARK: - 设置ShadowLabelFrame
    func setupShadow(){
        scrollView.insertSubview(shadowLabel, at: 0)
        let firstLabel = titleLabels[0]
        let w = firstLabel.frame.width
        let x = firstLabel.frame.origin.x
        let y = (bounds.height - titleStyle.shadowH) * 0.5
        let h = titleStyle.shadowH
        shadowLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
}
// MARK: - 监听事件
extension TitleView{
    // _ 表示不需要外部参数
@objc fileprivate func titleLaabelClick(_ tapGes : UITapGestureRecognizer){
        //1 取出用户点击的View
        let targetLabel = tapGes.view as! UILabel
        //2 点击同一个Label滚
        if currentIndex == targetLabel.tag { return }
        
        //3 之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        //4 切换文字的颜色
        targetLabel.textColor = titleStyle.selectColor
        oldLabel.textColor = titleStyle.normalColor
        
        //5 更新Index
        currentIndex = targetLabel.tag
    
        //6 通知contentView进行调整
        delegate?.titleView(self, targetIndex: currentIndex)
        
        //7 居中显示
        contentViewDidEndScroll()
        
        //8 跳正bottomLine
        if titleStyle.isShowScrollLine{
            UIView.animate(withDuration: 0.15) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        //9 调整缩放
        if titleStyle.isNeedScale{
            oldLabel.transform = CGAffineTransform.identity //恢复
            targetLabel.transform = CGAffineTransform(scaleX: titleStyle.scaleRange, y: titleStyle.scaleRange) //放大
        }
        
        //10    调整shadowLabel
        if titleStyle.isShowShadow{
            UIView.animate(withDuration: 0.15) {
                self.shadowLabel.frame.origin.x = targetLabel.frame.origin.x
                self.shadowLabel.frame.size.width = targetLabel.frame.size.width
            }
        }
}
    


// MARK: - 居中显示
func contentViewDidEndScroll(){
        //1 不需要滚动 return
        guard titleStyle.isScrollEnable else { return }
        
        //2 获取目标Label
        let targetLabel = titleLabels[currentIndex]
        
        //3 计算和之间位置的偏移
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0{
            offSetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        
        //4 滚动ScrollView
        scrollView.setContentOffset(CGPoint( x : offSetX , y : 0 ), animated: true)
}
    
}


// MARK: - ContentViewDelegate
extension TitleView {
    
     func setTitleWithProgress( targetIndex: Int,sourceIndex : Int, progress: CGFloat) {
        //1 取出Label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2颜色渐变
        let deltaRGB = UIColor.getRGBDelta(titleStyle.selectColor, titleStyle.normalColor)
        let selectedRGB = titleStyle.selectColor.getRGB()
        let normalRGB = titleStyle.normalColor.getRGB()
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.1 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        //3 记录下表
        currentIndex = targetIndex
        
        //获取总共可移动长度
        let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        //获取总共可变化的长度
        let deltaW = targetLabel.frame.width - sourceLabel.frame.width
        
        
        //4 bottomLine的渐变过程
        if titleStyle.isShowScrollLine{
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
        }
        
        //5 阴影位置设置
        if titleStyle.isShowShadow{
            //获取总共可移动长度
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            //获取总共可变化的长度
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            shadowLabel.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            shadowLabel.frame.size.width = sourceLabel.frame.size.width + deltaW * progress
        }
        
        //缩放
        if titleStyle.isNeedScale {
            let scaleData = (titleStyle.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: titleStyle.scaleRange - scaleData, y: titleStyle.scaleRange - scaleData)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleData, y: 1.0 + scaleData)
        }
    }

}
