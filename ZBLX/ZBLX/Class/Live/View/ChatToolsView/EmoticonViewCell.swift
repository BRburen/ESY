//
//  EmoticonViewCell.swift
//  ZBLX
//
//  Created by sia on 2017/11/16.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    var emotion : Emoticon?{
        didSet{
            
            iconImageView.image = UIImage(named: emotion!.emoticonName)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
