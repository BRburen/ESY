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
    
    fileprivate var titles : [String]
    fileprivate var titleStyle : TitleStyle
    
    fileprivate lazy var currentIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    //线
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.titleStyle.scrollLineColor
        bottomLine.frame.size.height = self.titleStyle.scrollLineH
        bottomLine.frame.origin.y = self.bounds.height - self.titleStyle.scrollLineH
        return bottomLine
    }()
    //阴影
    fileprivate lazy var shadowLabel : UILabel = {
      let shadowLabel = UILabel()
        shadowLabel.frame.size.height = self.titleStyle.shadowH
        shadowLabel.frame.origin.y = (self.titleStyle.titleHeight - self.titleStyle.shadowH) / 2
        shadowLabel.backgroundColor = self.titleStyle.shadowColor
        shadowLabel.layer.cornerRadius = 3
        shadowLabel.layer.masksToBounds = true
        shadowLabel.alpha = self.titleStyle.shadowAlpha
        return shadowLabel
    }()
    
    init(frame: CGRect , titles : [String], titleStyle : TitleStyle) {
        self.titles = titles
        self.titleStyle = titleStyle
        super.init(frame: frame)
        
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
        
        if titleStyle.isShowScrollLine{
            //添加滚动条
            scrollView.addSubview(bottomLine)
        }
        if titleStyle.isShowShadow {
            scrollView.addSubview(shadowLabel)
        }
    }
    private func setupTitleLabel(){
        for (i, title) in titles.enumerated(){
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = titleStyle.normalColor
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: titleStyle.fontSize)
            titleLabel.tag = i
            titleLabel.textColor = i == 0 ? titleStyle.selectColor : titleStyle.normalColor
            scrollView.addSubview(titleLabel)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLaabelClick(_ :)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
            
            titleLabels.append(titleLabel)
        }
    }
    
    private func setupTitleLabelFrame(){
        let count = titleLabels.count
        for (i, label) in titleLabels.enumerated(){
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            if titleStyle.isScrollEnable {  //可以滚动
                w = (titles[i] as NSString).boundingRect(with:CGSize(width: CGFloat(MAXFLOAT), height: 0) , options:.usesLineFragmentOrigin , attributes: [NSAttributedStringKey.font : label.font] ,context: nil).width
                if i == 0{
                    x = titleStyle.itemMargin * 0.5
                    
                    //设置bottomLine的X
                    if titleStyle.isShowScrollLine{
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                    //设置shadowLabel的X
                    if titleStyle.isShowShadow{
                        shadowLabel.frame.origin.x = x
                        shadowLabel.frame.size.width = w
                    }
                }else{
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + titleStyle.itemMargin
                }
            }else{      //不滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                
                if i == 0 && titleStyle.isShowScrollLine{
                    //如果不能滚动X从0开始
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                    //设置ShadowLabel的frame
                    shadowLabel.frame.origin.x = 0
                    shadowLabel.frame.size.width = w
                }
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = titleStyle.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + titleStyle.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}
// MARK: - 监听事件
extension TitleView{
    // _ 表示不需要外部参数
    @objc fileprivate func titleLaabelClick(_ tapGes : UITapGestureRecognizer){
        //取出用户点击的View
        let targetLabel = tapGes.view as! UILabel
        
        //2调整TitleLabel
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        //3跳正bottomLine
        if titleStyle.isShowScrollLine{
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        //调整shadowLabel
        if titleStyle.isShowShadow{
            UIView.animate(withDuration: 0.25) {
                self.shadowLabel.frame.origin.x = targetLabel.frame.origin.x
                self.shadowLabel.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        //4通知contentView进行调整
        delegate?.titleView(self, targetIndex: currentIndex)
    }
    
// MARK: - 抽取代码
    fileprivate func adjustTitleLabel(targetIndex : Int){
        if currentIndex == targetIndex {return}
        //1 取出Label
        let targetLabel = titleLabels[targetIndex]
        
        //2切换文字颜色 为了解决快速滑动BUG
        for (i , label) in titleLabels.enumerated(){
            label.textColor = i == targetIndex ? titleStyle.selectColor : titleStyle.normalColor
            if i == targetIndex {
                bottomLine.frame.origin.x = label.frame.origin.x
                bottomLine.frame.size.width = label.frame.size.width
                
                shadowLabel.frame.origin.x = label.frame.origin.x
                shadowLabel.frame.size.width = label.frame.size.width
            }
            
        }
        
        currentIndex = targetIndex
        
        
        
        
        //5调整位置
        if titleStyle.isScrollEnable {
            var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            
            if offsetX < 0{
                offsetX = 0
            }
            //如果大于 他最大的滚动距离 直接让他等于 最大滚动距离
            if offsetX > scrollView.contentSize.width - scrollView.bounds.width{
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x :offsetX, y : 0), animated: true)
        }
    }
    
}


// MARK: - ContentViewDelegate
extension TitleView : ContentViewDelegate{
    func contentView(_ contentView: ContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: ContentView, targetIndex: Int,sourceIndex : Int, progress: CGFloat) {
        //1 取出Label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[sourceIndex]
        
        //2颜色渐变
        let deltaRGB = UIColor.getRGBDelta(titleStyle.selectColor, titleStyle.normalColor)
        let selectedRGB = titleStyle.selectColor.getRGB()
        let normalRGB = titleStyle.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.1 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        
        
//        print("---\(progress)---\(targetIndex)---\(currentIndex)---\(sourceIndex)")
        
        //bottomLine的渐变过程
        if titleStyle.isShowScrollLine{
            //获取总共可移动长度
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            //获取总共可变化的长度
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.size.width + deltaW * progress
        }
        
        if titleStyle.isShowShadow{
            //获取总共可移动长度
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            //获取总共可变化的长度
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            shadowLabel.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            shadowLabel.frame.size.width = sourceLabel.frame.size.width + deltaW * progress
        }
    }

}
