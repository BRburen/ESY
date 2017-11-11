//
//  RoomViewController.swift
//  ZBLX
//
//  Created by sia on 2017/11/10.
//  Copyright © 2017年 BR_buren1111. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

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

        
    }
    
    
}

// MARK: - 事件
extension RoomViewController {
    @IBAction func outLive(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
