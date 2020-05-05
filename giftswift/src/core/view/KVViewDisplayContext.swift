//
//  KVViewDisplayContext.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol KVViewDisplayContext: NSObject {
    
    func onView(displayChange view: UIView, isDisplay: Bool)
    
}

extension UIView {

    private static var KVViewDisplayContextKey: Void?
    
    var displayContext: KVViewDisplayContext? {
        set {
            var weakWrapper: WeakWrapper? = objc_getAssociatedObject(self, &UIView.KVViewDisplayContextKey) as? WeakWrapper
            if weakWrapper == nil {
                weakWrapper = WeakWrapper(newValue)
                objc_setAssociatedObject(self, &UIView.KVViewDisplayContextKey, weakWrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                weakWrapper!.weakObject = newValue
            }
        }
        
        get {
            let weakWrapper: WeakWrapper? = objc_getAssociatedObject(self, &UIView.KVViewDisplayContextKey) as? WeakWrapper
            return weakWrapper?.weakObject as? KVViewDisplayContext
        }
    }
    
    var isDisplay: Bool {
        return self.alpha != 0
    }
    
    @objc func display(isDisplay: Bool) {
        if self.isDisplay == isDisplay {
            return
        }
        
        displayContext?.onView(displayChange: self, isDisplay: isDisplay)
    }

}
