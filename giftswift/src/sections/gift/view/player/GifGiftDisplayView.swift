//
//  GifGiftDisplayView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class GifGiftDisplayView: UIView, GiftRenderGifViewProtocol {
    
    weak var player: GiftPlayerProtocol?
    
    var giftMsg: GiftMsg?

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.animationRepeatCount = 0
    }
    
    func play(giftMsg: GiftMsg, isUpdate: Bool) {
        if !isUpdate {
            self.display(isDisplay: true)
            return
        }
        
        self.giftMsg = giftMsg
        imageView.image = nil
        guard let iconGif = giftMsg.gift.iconGif else {
            return
        }
        imageView.sd_setImage(with: URL(string: iconGif), completed: nil)
        imageView.sd_setImage(with: URL(string: iconGif)) { (image, error, cacheType, url) in
            
        }
        self.display(isDisplay: true)
    }
    
    func stop(key: String) {
//        imageView.stopAnimating()
//        imageView.image = nil
        if let msg = self.giftMsg, key == msg.playKey {
            self.display(isDisplay: false)
        }
    }

}

/**
 
 guard let data = image?.pngData() else {
     return
 }
 
 let nsData = NSData(data: data)
 
 let bytes = nsData.bytes.assumingMemoryBound(to: UInt8.self)
 // CFData object
 guard let cfData = CFDataCreate(kCFAllocatorDefault, bytes, nsData.length) else {
     return
 }

 // 2.根据Data获取CGImageSource对象
 guard let imageSource = CGImageSourceCreateWithData(cfData, nil) else { return }
         
 // 3.获取gif图片中图片的个数
 let frameCount = CGImageSourceGetCount(imageSource)
 // 记录播放时间
 var duration : TimeInterval = 0
 var images = [UIImage]()
 for i in 0..<frameCount {
     // 3.1.获取图片
     guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
     // 3.2.获取时长
     guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) , let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
     let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else { continue }
     duration += frameDuration.doubleValue
     let image = UIImage(cgImage: cgImage)
     images.append(image)
     // 设置停止播放时现实的图片
     if i == frameCount - 1 {
         self.imageView.image = image
     }
 }
 // 4.播放图片
 self.self.imageView.animationImages = images
 // 播放总时间
 self.self.imageView.animationDuration = duration
 // 播放次数, 0为无限循环
 self.imageView.animationRepeatCount = 0
 // 开始播放
 self.imageView.startAnimating()
 
 */
