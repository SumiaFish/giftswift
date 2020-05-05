//
//  KVStateView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol KVStateViewProtocl: UIView {
    
    func loadding()
    func complete(errorMsg: String?)
    func noData()
    
}


