//
//  Macro.swift
//  xingfuqiao
//
//  Created by mac on 2020/4/25.
//  Copyright © 2020 kv. All rights reserved.
//

import Foundation
import UIKit

/**
 
 + (BOOL)isIPhonexSerious
 {
     if (@available(iOS 11.0, *)) {
         return ((AppDelegate *)[UIApplication sharedApplication].delegate).window.safeAreaInsets.bottom > 0.0;
     }
     return NO;
 }
 */

func getIsIPhonexSerious() -> Bool {
    if #available(iOS 11.0, *) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.window?.safeAreaInsets.bottom ?? 0 > 0.0
        }
        return false
    }
    return false
}

func getIsPortrait() -> Bool {
    if #available(iOS 13.0, *) {
        return false
    } else {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        return statusBarOrientation == .portrait ||
        statusBarOrientation == .portraitUpsideDown
    }
}

func getSafeInsets() -> UIEdgeInsets {
    if getIsPortrait() {
        return getIsIPhonexSerious() ? UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0) : UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    return getIsIPhonexSerious() ? UIEdgeInsets(top: 0, left: 44, bottom: 21, right: 44) : UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
}

func getConverValue(_ value: Double) -> Double {
    let baseSize: CGSize = CGSize(width: 375.0, height: 667.0)
    if value <= 0 {
        return 0
    }
    let screenSize = UIScreen.main.bounds.size
    return Double(screenSize.width / baseSize.width) * value
}

func getRandom(from: Int, to: Int) -> Int {
    return from + (Int(arc4random()) % (to-from+1))
}
/**
 -(int)getRandomNumber:(int)from to:(int)to {
     return (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
 }
 */

let CV = getConverValue


func KLog<T>(_ message : T, file : String = #file, lineNumber : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
    #endif
}


let AppDefaultRadius: CGFloat = 4.0
let AppDefaultColor: UIColor = UIColor(hexString: "#FF5495")
let AppImagePlaceHolderBgc = UIColor.black.withAlphaComponent(0.4)
