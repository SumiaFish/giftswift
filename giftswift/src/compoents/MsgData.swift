//
//  MsgData.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol MsgProtocol: Codable {
    
    var id: String! { get }
    
    var text: String? { get }
    
    var receiveTime: TimeInterval! { get }
    
}

protocol MsgSenderProtocol: NSObjectProtocol {
    
    func sendMsg(msg: MsgProtocol)
    
}

protocol MsgReceiverProtocl: NSObjectProtocol {
    
    func receive(msg: MsgProtocol)
    
}

class MsgManager: NSObject, MsgSenderProtocol, MsgReceiverProtocl {
    
    static let sharedInstance = MsgManager()
    
    private override init() {}
    
    private let listeners: WeakArray<MsgReceiverProtocl> = WeakArray()
    
    func sendMsg(msg: MsgProtocol) {
        MsgData.send(msg: msg).then { (_) in
            self.receive(msg: msg)
        }
    }
    
    func receive(msg: MsgProtocol) {
        listeners.excute { (it) in
            it?.receive(msg: msg)
        }
    }
    
    func add(listener: MsgReceiverProtocl) {
        listeners.add(listener)
    }
    
    func remove(listener: MsgReceiverProtocl) {
        listeners.add(listener)
    }
    
}

struct MsgData {
    static func send(msg: MsgProtocol) -> Promise<Void> {
        return Promise<Void> { (filfull, reject) in
            DispatchQueue.global().async {
//                Thread.sleep(forTimeInterval: 0.1)
                Thread.sleep(forTimeInterval: Double(getRandom(from: 60, to: 1000))*0.001)
                DispatchQueue.main.async {
                    filfull(())
                }
            }
        }
    }
}

struct Msg: MsgProtocol {
    let id: String!
    
    let receiveTime: TimeInterval!
    
    let text: String?
}

struct GiftMsg: MsgProtocol {
    let id: String!
    
    let text: String?
    
    let gift: Gift!
    
    let receiveTime: TimeInterval!
    
    /// ---
    /// username+id
    var playKey: String { (self.gift.username ?? "") + "." + (self.gift.id ?? "")}
    /// 连击次数
    var serialCount: Int = 1
    /// 动画消失时间点
    var dismissTime: TimeInterval = 0
    /// ---
}
