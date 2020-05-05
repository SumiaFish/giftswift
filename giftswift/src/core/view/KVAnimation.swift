//
//  KVAnimation.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

extension UIView {
    
    static let animationTimeval: TimeInterval = 0.31
    
    static func kv_animate(animations: @escaping ()->Void) {
        self.kv_animate(animations: animations, completion: nil)
    }
    
    static func kv_animate(animations: @escaping ()->Void, completion: ((_ finish: Bool)->Void)?) {
//        UIView.animate(withDuration:UIView.animationTimeval, animations: animations, completion: completion)
        UIView.animate(withDuration: UIView.animationTimeval, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 5, options: .curveEaseOut, animations: animations, completion: completion)
    }
    
    static func kv_animate2(animations: @escaping ()->Void, completion: ((_ finish: Bool)->Void)?) {
    //        UIView.animate(withDuration:UIView.animationTimeval, animations: animations, completion: completion)
        
        UIView.animate(withDuration: UIView.animationTimeval/2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseOut, animations: animations, completion: completion)
        }
    
    static func kv_animate3(animations: @escaping ()->Void, completion: ((_ finish: Bool)->Void)?) {
    //        UIView.animate(withDuration:UIView.animationTimeval, animations: animations, completion: completion)
        
        UIView.animate(withDuration: UIView.animationTimeval/3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseOut, animations: animations, completion: completion)
        }
}
