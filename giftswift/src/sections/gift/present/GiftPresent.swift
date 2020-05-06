//
//  GiftPresent.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol GiftListViewProtocol: KVStateViewProtocl {
    
    func reloadData()
    
}

class GiftListPresent: NSObject {
    
    private(set) var gifts: [Gift] = []
    
    weak var listView: GiftListViewProtocol?
    
    weak var msgSender: MsgSenderProtocol?
    
    func loadGifts() -> Promise<[Gift]> {
        self.listView?.loadding()
        return GiftData.loadData().then { (data) -> [Gift] in
            if let data = data.data {
                self.gifts.append(contentsOf: data)
                self.listView?.complete(errorMsg: nil)
            }
            return self.gifts
        }.catch { (error) in
            if let error = error as? KVError {
                self.listView?.complete(errorMsg: error.msg)
            }
        }
    }
    
    func selected(idx: Int) {
        for i in 0..<gifts.count {
            if i == idx {
                gifts[i].isSelected = true
            } else {
                gifts[i].isSelected = false
            }
        }
        listView?.reloadData()
    }
    
    func unselected() {
        for i in 0..<gifts.count {
            gifts[i].isSelected = false
        }
        listView?.reloadData()
    }
    
    func getSelectedGift() -> Gift? {
        for i in 0..<gifts.count {
            if gifts[i].isSelected {
                return gifts[i]
            }
        }
        
        return nil
    }
    
    func sendGift() {
//        DispatchQueue.global().async {
//            for _ in 0..<10000 {
//                let idx = getRandom(from: 6, to: self.gifts.count-1)
//                if idx == 6 {
//                    continue
//                }
//                let gift = self.gifts[idx]
//                let t = Double(getRandom(from: 100, to: 300))*0.001
//                Thread.sleep(forTimeInterval: t)
//                self.msgSender?.sendMsg(msg: GiftMsg(text: "\(gift.username ?? "")送出\(gift.name ?? "")", gift: gift, receiveTime: Date().timeIntervalSince1970))
//
//            }
//        }
        
//        let btBlock = { (index: Int) in
//            DispatchQueue.global().async {
//                for _ in 0..<100 {
//                    let idx = index
//                    if idx == 6 {
//                        continue
//                    }
//                    let gift = self.gifts[idx]
//                    let t = Double(getRandom(from: 100, to: 300))*0.001
//                    Thread.sleep(forTimeInterval: t)
//                    self.msgSender?.sendMsg(msg: GiftMsg(text: "\(gift.username ?? "")送出\(gift.name ?? "")", gift: gift, receiveTime: Date().timeIntervalSince1970))
//
//                }
//            }
//        }
        
//        btBlock(8)
//        btBlock(11)
        
        
        if let gift = getSelectedGift() {
            msgSender?.sendMsg(msg: GiftMsg(id: UUID().uuidString, text: "\(gift.username ?? "")送出\(gift.name ?? "")", gift: gift, receiveTime: Date().timeIntervalSince1970))
        }
        
    }
    
}


class AutoSenderGift: NSObject {
    
    var gifts: [Gift] = []
    
    var queue = OperationQueue()
    
    let sem = DispatchSemaphore(value: 1)
        
    func start() {

        queue.maxConcurrentOperationCount = 10
        if gifts.count == 0 || gifts.count <= 6 {
            return
        }
        
        DispatchQueue.global().async {
            self.sem.wait()
            defer {
                self.sem.signal()
            }
            
            self.stop()
            self.todo()
        }
   
    }

        
        
    func stop() {
        queue.cancelAllOperations()
    }
    
    func todo() {
        
        for _ in 0..<500 {
            let idx = getRandom(from: 6, to: self.gifts.count-1)
            if idx == 6 {
                continue
            }
            let gift = self.gifts[idx]
            Thread.sleep(forTimeInterval: Double(getRandom(from: 60, to: 1000))*0.001)
            var text = "\(gift.username ?? "")送出\(gift.name ?? "")"
            for _ in 0..<getRandom(from: 0, to: 5) {
                /**
                    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

                    NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);

                    NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);

                    NSInteger number = (randomH<<8)+randomL;
                    NSData *data = [NSData dataWithBytes:&number length:2];

                    NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];

                    NSLog(@"%@",string);
                    */
                
                let gbkEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
                let randomH = 0xA1+arc4random()%(0xFE - 0xA1+1)
                let randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1)
                var number = (randomH<<8)+randomL
                let data = Data(bytes: &number, count: getRandom(from: 10, to: 50))
                let string = String(data: data, encoding: String.Encoding(rawValue: gbkEncoding))
            
                text += string ?? ""
            }
            
            queue.addOperation {
                let _ = MsgManager.sharedInstance.sendMsg(msg: GiftMsg(id: UUID().uuidString, text: text, gift: gift, receiveTime: Date().timeIntervalSince1970))
            }
        }
        
    }
    
}


class SVGAGiftPresent: NSObject {
    
    
    
    
}


