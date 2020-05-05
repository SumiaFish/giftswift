//
//  MsgPrensent.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol MsgListViewProtocol: NSObjectProtocol {
    
    func showMsg(msg: MsgProtocol)
        
}

class MsgPrensent: NSObject, MsgSenderProtocol, MsgReceiverProtocl {

    weak var msgListView: MsgListViewProtocol?
        
    private(set) var msgs: [MsgProtocol] = []
        
    deinit {
        MsgManager.sharedInstance.remove(listener: self)
    }
    
    override init() {
        super.init()
        
        MsgManager.sharedInstance.add(listener: self)
    }
    
    func sendMsg(msg: MsgProtocol) {
        MsgManager.sharedInstance.sendMsg(msg: msg)
    }
    
    func receive(msg: MsgProtocol) {
        msgs.append(msg)
        msgListView?.showMsg(msg: msg)
    }

}
