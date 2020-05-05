//
//  WeakArray.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

public class WeakArray<T> {

    private var contents = NSPointerArray(options: .weakMemory)
    
    /// add item
    public func add(_ item: T) {
        contents.addObject(item as AnyObject)
    }
    
    /// remove item
    public func remove(_ item: T) {
        
        contents.remove(item as AnyObject)
    }
    
    /// excute delegate func
    public func excute(_ block:@escaping ((T?)->Void)) {
        
        contents.allObjects.forEach({
            block($0 as? T)
        })
    }
    
}
