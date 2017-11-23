//
//  ChatContentView.swift
//  ZBLX
//
//  Created by sia on 2017/11/23.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

let kChatCellID : String = "ChatCellID"

class ChatContentView: UIView ,Nibloadable{
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var dataSource : [NSAttributedString] = [NSAttributedString]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.separatorStyle = .none
        //估算高度
        tableView.estimatedRowHeight = 40
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "ChatContentCell", bundle: nil), forCellReuseIdentifier: kGifyCellID)
    }
}

extension ChatContentView {
    func insertMsg(_ message : NSAttributedString){
        dataSource.append(message)
//        tableView.reloadRows(at: [IndexPath(row: dataSource.count - 1, section: 0)], with: UITableViewRowAnimation.bottom)
        tableView.reloadData()
        let indexPath = IndexPath(row: dataSource.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        
    }
}

extension ChatContentView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kGifyCellID, for: indexPath) as! ChatContentCell
        cell.contentLabel.attributedText = dataSource[indexPath.row]
        return cell
    }
}
