//
//  HomeViewCell.swift
//  ZBLX
//
//  Created by sia on 2017/11/5.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class HomeViewCell: UICollectionViewCell {
    // MARK: - 空间属性 
    @IBOutlet weak var alibumImageView: UIImageView!
    @IBOutlet weak var livieImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlinePeopleLabel: UIButton!
    
    var anchorModel : AnchorModel?{
        didSet{
            alibumImageView.setImage(anchorModel!.isEvenIndex ? anchorModel?.pic74 : anchorModel?.pic51, "home_pic_default")
            livieImageView.isHidden = anchorModel?.live == 0
            nickNameLabel.text = anchorModel?.name
            onlinePeopleLabel.setTitle("\(anchorModel?.focus ?? 0)", for: .normal)
        }
    }
}
