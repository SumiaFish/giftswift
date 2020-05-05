//
//  DanmuPlayer.swift
//  giftswift
//
//  Created by kevin on 2020/5/5.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol DanMUItemViewProtocol: NSObjectProtocol {
                
    func play(msg: MsgProtocol)
    
    func stop()
    
    func getMsg() -> MsgProtocol?
        
}

protocol DanmuViewProtocol: NSObjectProtocol {
            
    func play(msgs: [MsgProtocol])
    
    func stop()
    
    func getMsgs() -> [MsgProtocol]
    
}

protocol DanmuPlayerProtocol: NSObjectProtocol {
    
    
    
}

class DanmuPlayer: NSObject, MsgReceiverProtocl {

    weak var view: DanmuViewProtocol? {
        didSet {
            queue.view = view
        }
    }
    
    private let queue = DanmuQueue()
    
    deinit {
        MsgManager.sharedInstance.remove(listener: self)
    }
    
    override init() {
        super.init()
        MsgManager.sharedInstance.add(listener: self)
    }
    
    func receive(msg: MsgProtocol) {
        queue.add(msg: msg)
    }
    
    
    
}

class DanmuQueue: NSObject, DanmuPlayerProtocol {
    
    weak var view: DanmuViewProtocol?
        
    private var secondsMap: [TimeInterval: [String]] = [:]
    
    private var map: [String: MsgProtocol] = [:]

    private var offsetTime: TimeInterval = 0
    
    private var timer: Timer?
    
    deinit {
        timer?.invalidate()
        
    }
    
    override init() {
        super.init()

        timer = Timer(timeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.render()
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func add(msg: MsgProtocol) {
        
        if offsetTime == 0 {
            offsetTime = Date().timeIntervalSince1970 - msg.receiveTime
        }
        
        let t = Date().floorValue
        if var arr = secondsMap[t] {
            arr.append(msg.id)
            secondsMap[t] = arr
        } else {
            var arr: [String] = []
            arr.append(msg.id)
            secondsMap[t] = arr
        }
        map[msg.id] = msg
        
    }
    
    func render() {
        
        let t = Date().floorValue - floor(offsetTime)
        var arr: [MsgProtocol] = []
        let ss = secondsMap.filter({ (time, _) in time < t })
        _ = ss.values.map { (it)  in
            it.forEach { (it) in
                if let m = self.map[it] {
                    arr.append(m)
                }
            }
        }
        ss.forEach { (key, _) in
            secondsMap.removeValue(forKey: key)
        }
        view?.play(msgs: arr)
        
    }

    
}

