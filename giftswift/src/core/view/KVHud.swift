//
//  KVHud.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol KVHudProtocl: NSObjectProtocol {
    
    init(_ context: UIView)
    func loadding(_ text: String?)
    func showInfo(text: String)
    func showError(text: String)
    func showSuccess(_ text: String?)
    func hide(_ after: TimeInterval?)
    
}

class KVHud: NSObject, KVHudProtocl {
    
    required init(_ context: UIView) {
        
    }
    
    func loadding(_ text: String?) {
        
    }
    
    func showInfo(text: String) {
        
    }
    
    func showError(text: String) {
        
    }
    
    func showSuccess(_ text: String?) {
        
    }
    
    func hide(_ after: TimeInterval?) {
        
    }
    
}

extension UIView {
    private static var KVKVHudKey: Void?
    var hud: KVHudProtocl? {
        set {
            objc_setAssociatedObject(self, &UIView.KVKVHudKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &UIView.KVKVHudKey) as? KVHudProtocl
        }
    }
}
