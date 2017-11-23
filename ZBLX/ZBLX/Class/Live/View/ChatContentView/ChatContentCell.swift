//
//  ChatContentCell.swift
//  ZBLX
//
//  Created by sia on 2017/11/23.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class ChatContentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.white
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
