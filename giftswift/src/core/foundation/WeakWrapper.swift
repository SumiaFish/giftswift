//
//  WeakWrapper.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

public class WeakWrapper : NSObject {
    weak var weakObject : NSObject?

    init(_ weakObject: NSObject?) {
        self.weakObject = weakObject
    }
}
