//
//  KVViewController.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVViewController : UIViewController {
    
    /// 是否隐藏导航栏
    private(set) var navigationBarHiddenWhenAppear = false
    
    override var prefersStatusBarHidden: Bool { false }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {.lightContent}
    
    deinit {
        // 这里不能用 self.xxx
        /**
         self.xxx会 == nil，会导致崩溃
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(self.navigationBarHiddenWhenAppear, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(!self.navigationBarHiddenWhenAppear, animated: animated)
    }
}
