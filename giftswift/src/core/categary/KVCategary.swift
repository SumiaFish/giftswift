//
//  KVCategary.swift
//  xingfuqiao
//
//  Created by mac on 2020/4/25.
//  Copyright © 2020 kv. All rights reserved.
//

import UIKit

extension NSObject {
    // MARK:返回className
    var className:String{
        get{
          let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }

        }
    }
    
    static var className:String{
        get{
            let name =  String(describing: type(of: Self.self))
            if(name.contains(".Type")){
                return name.components(separatedBy: ".Type")[0];
            }else{
                return name;
            }

        }
    }
    
    var fullClassName: String {
        get{
          return type(of: self).description()
        }
    }

}

extension UIColor {
    // MARK: 通过字符串初始化Color
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension UIView {
    
    // MARK: 设置圆角
    func setRadius(_ radius: CGFloat, _ bgc: UIColor? = nil, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        if bgc == nil {
            self.layer.backgroundColor = UIColor.clear.cgColor
        } else {
            self.backgroundColor = bgc
        }
        
        if borderColor == nil {
            self.layer.borderColor = UIColor.clear.cgColor
        } else {
            self.layer.borderColor = borderColor?.cgColor
        }
        
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        
        if self.isKind(of: UILabel.self) {
            self.backgroundColor = UIColor.clear;
            self.layer.backgroundColor = bgc?.cgColor;
        }
        
        if self.isKind(of: UIButton.self) {
            let width = self.bounds.width
            let button = self as! UIButton
            button.imageView?.layer.cornerRadius = radius * (button.imageView?.frame.width ?? 0 / width);
        }
        
    }
    
    func screenShot() -> UIImage? {
        if self.frame.height > 0 &&
            self.frame.width > 0{
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
            if let context = UIGraphicsGetCurrentContext() {
                self.layer.render(in: context)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image
                
            } else {
                UIGraphicsEndImageContext()
                return nil
                
            }
        }
        
        return nil
    }
    
}


extension UIButton {
    func setTitle(_ title: String?, _ titleColor: UIColor?, for state: UIControl.State) {
        self.setTitle(title, for: state)
        self.setTitleColor(titleColor, for: state)
    }
}


extension UITextField {
    // MARK: 去左右空格
    var trimText: String? {
        get {
            return self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}


extension NSPointerArray {
    
    /// add
    func addObject(_ object: AnyObject?) {
        guard let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
    
    /// insert
    func insertObject(_ object: AnyObject?, at index: Int) {
        guard index < count, let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
    
    /// replace
    func replaceObject(at index: Int, withObject object: AnyObject?) {
        guard index < count, let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
    
    /// get index
    func object(at index: Int) -> AnyObject? {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
    
    
    /// remove
    func removeObject(at index: Int) {
        guard index < count else { return }
        
        removePointer(at: index)
    }
    
    /// remove
    func remove(_ object: AnyObject?) {
    
        var index: Int?
        for i in 0..<allObjects.count {
            
            if self.object(at: i)?.hash == object?.hash {
                index = i
            }
        }
        
        if let aIndex = index {
            removeObject(at: aIndex)
        }
    }
}


extension Date {
    
    var floorValue: TimeInterval {
        let v: Double = self.timeIntervalSince1970
        return floor(v)
    }
    
}
