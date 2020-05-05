//
//  GiftPlayer.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

/// 礼物列表显示时间
let GiftDisplayTime: TimeInterval = 3

/// 侧边礼物列表最大显示数量
let GiftDisplayListMaxCount: Int = 5

/// 侧边礼物列表动画方式
let GiftDisplayDefaultAnimationType: GiftListAnimationType = .asc

protocol GiftPlayerProtocol: NSObjectProtocol {
    
}

/// gif播放视图
protocol GiftRenderGifViewProtocol: NSObjectProtocol {
    
    var player: GiftPlayerProtocol? { get }
    
    var giftMsg: GiftMsg? { get }
    
    func play(giftMsg: GiftMsg, isUpdate: Bool)
    
    func stop(key: String)
    
}

/// 侧边栏礼物列表视图
protocol GiftRenderListViewProtocol: NSObjectProtocol {
        
    var player: GiftPlayerProtocol? { get }
    
    var giftMsgs: [GiftMsg] { get }
    
    var maxCount: Int { get set }
    
    var animationType: GiftListAnimationType { get set }
        
    func play(giftMsgs: [GiftMsg], player: GiftPlayerProtocol)
    
    func stop(key: String)
}

/// 侧边栏礼物列表动画视图
protocol GiftRenderViewProtocol: NSObjectProtocol {

    var giftMsg: GiftMsg? { get }

    func play(giftMsg: GiftMsg)

    func stop()

}

enum GiftListAnimationType {
    case asc
    case keep
    case drop
}

class GiftListPlayer: NSObject, MsgReceiverProtocl, GiftPlayerProtocol {
    
    weak var view: GiftRenderListViewProtocol? {
        didSet {
            view?.animationType = animationType
            view?.maxCount = maxCount
        }
    }
    
    var animationType: GiftListAnimationType = .asc {
        didSet {
            view?.animationType = animationType
        }
    }
    
    private var _maxCount = 1
    var maxCount: Int {
        set {
            if newValue < 1 {
                _maxCount = 1
            } else {
                _maxCount = newValue
            }
            queue.maxPlayCount = _maxCount
            view?.maxCount = _maxCount
        }
        get {
            return _maxCount
        }
    }
    
    private var _playTime: TimeInterval = 1
    var playTime: TimeInterval {
        set {
            if newValue < 1 {
                _playTime = 1
            } else {
                _playTime = newValue
            }
            queue.itemPlayTime = _playTime
        }
        get {
            return _playTime
        }
    }
    
    weak var gifView: GiftRenderGifViewProtocol?
        
    private var queue = GiftPlayQueue()
    
    deinit {
        MsgManager.sharedInstance.remove(listener: self)
    }
    
    override init() {
        super.init()
        
        MsgManager.sharedInstance.add(listener: self)
        
        self.animationType = GiftDisplayDefaultAnimationType
        self.maxCount = GiftDisplayListMaxCount
        self.playTime = GiftDisplayTime
        
        weak var weakself = self
        queue.onUpdate = { msgs in
            weakself?.update(msgs: msgs)
        }
        queue.onRemove = { (key) in
            weakself?.remove(key: key)
        }
    }

    // MARK: -
    func receive(msg: MsgProtocol) {
        if var msg = msg as? GiftMsg {
            queue.add(giftMsg: &msg)
        }
    }

    // MARK: -
    
    private func update(msgs: [GiftMsg]) {
        guard let view = self.view else {
            return
        }

        view.play(giftMsgs: msgs, player: self)

        if let msg = msgs.first, let gifView = self.gifView  {
            if let lastMsg =  gifView.giftMsg {
                gifView.play(giftMsg: msg, isUpdate: lastMsg.playKey != msg.playKey)
            } else {
                gifView.play(giftMsg: msg, isUpdate: true)
            }
        }
    }
    
    private func remove(key: String) {
        view?.stop(key: key)
        gifView?.stop(key: key)
    }

}

private class GiftPlayQueue: NSObject {
    
    var onUpdate: (([GiftMsg])->Void)?
    
    var onRemove: ((_ key: String)->Void)?
    
    var maxPlayCount = 1
    
    var itemPlayTime: TimeInterval = 1
    
    /// key: msg
    private var tasksMap: [String: GiftMsg] = [:]
        
    /// keys
    private var currentTasks: [String] = []
                        
    private var queue: OperationQueue?
    
    deinit {
        
    }
    
    override init() {
        super.init()
        
        queue  = OperationQueue()
    }
    
    func add(giftMsg: inout GiftMsg) {
        impAdd(giftMsg: &giftMsg, isSerial: true)
    }

    /// 消息; 是否是连击
    private func impAdd(giftMsg: inout GiftMsg, isSerial: Bool) {
        
        let key = giftMsg.playKey
        
        if currentTasks.contains(key) {
            // 当前任务
            // 取消上次发送的隐藏设定
            queue?.operations.forEach { (it) in
                if let op = it as? GiftDismissOpration, op.key == key {
                    op.cancel()
                }
            }
            
        } else {
            // 非当前任务
            // 尝试设为当前任务
            if currentTasks.count < maxPlayCount {
                // 加入当前任务
                currentTasks.append(key)
            }
    
        }

        // 更新连击数
        if isSerial {
            saveGiftMsg(giftMsg: &giftMsg)
        }
        
        // 此时是当前任务
        if currentTasks.contains(key) {
            // 排序当前任务
            sortTasks(tasks: &currentTasks)
            // 告诉上层更新
            onUpdate?(getCurrentTaskMsgs())
            // 设定隐藏
            queue?.addOperation(GiftDismissOpration(key: giftMsg.playKey, afterTime: itemPlayTime, { [weak self] (op) in
                self?.remove(key: op.key)
            }) { (op) in
                KLog("cancel...")
            })
            
        }

    }

    private func remove(key: String) {
        tasksMap.removeValue(forKey: key)
        
        for i in 0..<currentTasks.count {
            let e = currentTasks[i]
            if e == key {
                currentTasks.remove(at: i)
                break
            }
        }
        
        onRemove?(key)
        
        /// 继续延迟任务
        doDelayTask()
    }
    
    private func doDelayTask() {
        
        let sorted = tasksMap.values.sorted { (m1, m2) -> Bool in
            if m1.serialCount > m2.serialCount {
                return true
            }
            let t1: TimeInterval = m1.receiveTime ?? 0
            let t2: TimeInterval = m2.receiveTime ?? 0
            return t1 < t2
        }
        let count = sorted.count// > maxPlayCount-currentTasks.count ? maxPlayCount-currentTasks.count : sorted.count
        for i in 0..<count {
            var msg = sorted[i]
            self.impAdd(giftMsg: &(msg), isSerial: false)
        }
        
    }
    
    private func saveGiftMsg(giftMsg: inout GiftMsg) {
        let key = giftMsg.playKey
        
        if let msg = tasksMap[key] {
            giftMsg.serialCount = msg.serialCount + 1
        } else {
            giftMsg.serialCount = 1
        }
        
        tasksMap[key] = giftMsg // giftMsg是struct，所以操作过后要重新put in map
    }

    private func getCurrentTaskMsgs() -> [GiftMsg] {
        var arr: [GiftMsg] = []
        currentTasks.forEach { (it) in
            if let msg = tasksMap[it] {
                arr.append(msg)
            }
        }
        return arr
    }
    
    private func sortTasks(tasks: inout [String]) {
        let arr = tasks.sorted { (s1, s2) -> Bool in
            if let m1 = tasksMap[s1], let m2 = tasksMap[s2] {
                return m1.serialCount > m2.serialCount
            }
            return false
        }
        tasks.removeAll()
        tasks.append(contentsOf: arr)
    }
}

private class GiftDismissOpration: Operation {
    
    private var onCancel: ((_ op: GiftDismissOpration)->Void)?
    
    private var onTimesUp: ((_ op: GiftDismissOpration)->Void)?
    
    private var after: TimeInterval = 0.1
    
    private(set) var key: String = ""
    
    private var _isExecuting: Bool = false {
        /**
        自定义异步需要我们自己通过KVO来通知Operation的isExecuting（是否正在进行中），以及isFinished（是否已经完成）
        */
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }
    
    private var _isFinished: Bool = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }
    
    private let semap = DispatchSemaphore(value: 1)
    
    override init() {
        super.init()
    }
    
    init(key: String, afterTime: TimeInterval, _ onTimesUp: ((_ op: GiftDismissOpration)->Void)?, _ onCancel: ((_ op: GiftDismissOpration)->Void)?) {
        self.key = key
        self.after = afterTime
        self.onTimesUp = onTimesUp
        self.onCancel = onCancel
    }
        
    override var isExecuting: Bool {
       return _isExecuting
    }

    override var isFinished: Bool {
       return _isFinished
    }

    override var isAsynchronous: Bool {
       return true
    }
    
    override func start() {
        semap.wait()
        defer {
            semap.signal()
        }
        
        if isCancelled {
            onCancel?(self)
            _isFinished = true
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.todo()
        }
        
        _isExecuting = true
    }
    
    override func cancel() {
        semap.wait()
        defer {
            semap.signal()
        }
        
        guard !isFinished else {
            return
        }
        
        super.cancel()
        onCancel?(self)
        if isExecuting {
            _isExecuting = false
        }
        if !isFinished {
            _isFinished = true
        }
    }
    
    func todo() {
        semap.wait()
        defer {
            semap.signal()
        }
        
        // 已经被取消
        if isCancelled || _isFinished {
            return
        }
        
        self._isFinished = true
        self.onTimesUp?(self)
        
    }
    
}
