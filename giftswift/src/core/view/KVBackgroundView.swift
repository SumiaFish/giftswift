//
//  KVBackgroundView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVBackgroundView: UIView {
    
    let defualtColor = UIColor.black.withAlphaComponent(0.1)
    
    var onTap: (()->())?
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = defualtColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        onTap?()
    }
    
}


extension KVView {
    
    private static var KVBackgroundViewKey: Void?
    
    var bgv: KVBackgroundView {
        get {
            if let view = objc_getAssociatedObject(self, &KVView.KVBackgroundViewKey) as? KVBackgroundView {
                return view
            }
            
            let view = KVBackgroundView()
            weak var weakself = self
            view.onTap = {
                weakself?.display(isDisplay: false)
            }
                        
            objc_setAssociatedObject(self, &KVView.KVBackgroundViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
    }
    
    override var alpha: CGFloat {
        didSet {
            self.bgv.alpha = alpha
        }
    }

}
