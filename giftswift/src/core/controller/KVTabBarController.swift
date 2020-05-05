//
//  KVTabBarController.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVTabbarController : UITabBarController {
    override var prefersStatusBarHidden: Bool {  return self.viewControllers?.last?.prefersStatusBarHidden ?? false }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.viewControllers?.last?.preferredStatusBarStyle ?? UIStatusBarStyle.lightContent }
}

