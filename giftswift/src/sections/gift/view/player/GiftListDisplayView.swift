//
//  GiftListDisplayView.swift
//  giftswift
//
//  Created by kevin on 2020/5/3.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

let ItemSpace: CGFloat = 5

class GiftListDisplayView: UIView, GiftRenderListViewProtocol {

    var animationType: GiftListAnimationType = .asc
    
    var maxCount: Int = 1
    
    weak var player: GiftPlayerProtocol?
    
    var rowH: CGFloat {
        return (self.bounds.height - CGFloat(maxCount-1)*ItemSpace) / CGFloat(maxCount)
    }
    
    private(set) var giftMsgs: [GiftMsg] = []

    private var viewsPool: Set = Set<GiftItemDisplayView>()

    private let queue: OperationQueue = OperationQueue()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.clipsToBounds = true
        queue.maxConcurrentOperationCount = self.maxCount
    }

    func play(giftMsgs: [GiftMsg], player: GiftPlayerProtocol) {
        
        self.updateData(giftMsgs: giftMsgs, player: player)
        self.layoutItems(animate: true, {
            
        })
        
        let op = GiftDisplayViewOpration { [weak self] (complete) in
            
            let currentGiftMsgs = self?.giftMsgs ?? []
            let okeys = currentGiftMsgs.map{ it in it.playKey }
            let willAdd = giftMsgs.filter{ it in !okeys.contains(it.playKey) }
            
            self?.giftMsgs.removeAll()
            self?.giftMsgs.append(contentsOf: giftMsgs)

            if willAdd.count > 0 {
                
                let nkeys = giftMsgs.map{ $0.playKey }
                let removeKeys = okeys.filter{ it in !nkeys.contains(it) }
                self?.remove(keys: removeKeys, animate: true) {
                    
                    self?.add(willAdd: willAdd, {
                        self?.updateData(giftMsgs: giftMsgs, player: player)
                        self?.layoutItems(animate: true, {
                            complete()
                        })
                    })
                    
                }
                
            } else {
//                self?.updateData(giftMsgs: giftMsgs, player: player)
                complete()

            }
        }
        queue.addOperation(op)
                
    }
    
    func stop(key: String) {

        let op = GiftDisplayViewOpration { [weak self] (complete) in
            
            let arr = self?.giftMsgs.filter({ it in it.playKey != key })
            self?.giftMsgs.removeAll()
            self?.giftMsgs.append(contentsOf: arr ?? [])
            self?.remove(keys: [key], animate: true) {
                self?.layoutItems(animate: true, {
                    complete()
                })
            }
            
        }
        self.queue.addOperation(op)
 
    }

    func add(willAdd: [GiftMsg], _ addComplete: @escaping ()->Void ) {
        
        /// 添加
        if willAdd.count == 0 {
            addComplete()
            return
        }
        
        willAdd.forEach { (it) in
            let view = self.getOneView()
            view.play(giftMsg: it)
            self.addSubview(view)
        }
        addComplete()
    }
    
    func remove(keys: [String] = [], animate: Bool, _ removeComplete: @escaping ()->Void ) {
        
        /// 移除
        if keys.count == 0 {
            removeComplete()
            return
        }
        
        var views: [GiftItemDisplayView] = []
        self.subviews.forEach { (view) in
            guard let view = view as? GiftItemDisplayView, let playKey = view.giftMsg?.playKey  else { return }
            if keys.contains(playKey) {
                views.append(view)
            }
        }
        
        if !animate {
            views.forEach { (view) in
                view.removeFromSuperview()
            }

            removeComplete()
            return
        }
        
        UIView.kv_animate2(animations: {
            
            views.forEach { (view) in
                var frame = view.frame
                frame.origin.x += (self.bounds.width)/3
                view.frame = frame
            }
            
        }) { (finish) in
            
            guard finish else { return }
            UIView.kv_animate2(animations: {
                
                views.forEach { (view) in
                    var frame = view.frame
                    frame.origin.x = -(self.bounds.width)
                    frame.origin.y += (self.rowH)/2
                    frame.size.height = 0
                    view.alpha = 0
                    view.frame = frame
                }
                
            }) { (finish) in
                
                guard finish else { return }
                views.forEach { (view) in
                    view.removeFromSuperview()
                }

                removeComplete()

            }
            
        }
    }
    
    func updateData(giftMsgs: [GiftMsg], player: GiftPlayerProtocol) {
        self.player = player

        var viewsMap: [String: GiftItemDisplayView] = [:]
        self.subviews.forEach { (view) in
            guard let view = view as? GiftItemDisplayView, let key = view.giftMsg?.playKey else { return }
            viewsMap[key] = view
        }
        
        giftMsgs.forEach { (it) in
            guard let view = viewsMap[it.playKey] else { return }
            view.play(giftMsg: it)
        }
    }
    
    func layoutItems(animate: Bool, _ layoutItemsComplete: @escaping ()->Void) {
        /// 做动画
        switch animationType {
        case .asc:
            layoutItemsAsc(animate: animate, layoutItemsComplete)
        case .keep:
            layoutItemsKepp(animate: animate, layoutItemsComplete)
        case .drop:
            layoutItemsDrop(animate: animate, layoutItemsComplete)
        }
    }
    
    func layoutItemsAsc(animate: Bool, _ layoutItemsComplete: @escaping ()->Void) {
        /// 做动画
        if self.subviews.count == 0 {
            layoutItemsComplete()
            return
        }
        
        var viewsMap: [String: GiftItemDisplayView] = [:]
        var frameMap: [String: CGRect] = [:]
        let giftMsgs = self.giftMsgs
        let rowH = self.rowH
        
        self.subviews.forEach { (view) in
            guard let view = view as? GiftItemDisplayView, let key = view.giftMsg?.playKey else { return }
            viewsMap[key] = view
        }
        
        for i in 0..<giftMsgs.count {
            let msg = giftMsgs[i]
            let y: CGFloat = CGFloat((i)) * (rowH+ItemSpace)
            let frame = CGRect(x: 0, y: y, width: self.bounds.width, height: rowH)
            frameMap[msg.playKey] = frame
        }
        
        if !animate {
            viewsMap.forEach { (key, view) in
                if let frame = frameMap[key] {
                    view.frame = frame
                }
            }
            layoutItemsComplete()
            return
        }
        
        giftMsgs.reversed().forEach { (it) in
            if let view = viewsMap[it.playKey] {
                self.bringSubviewToFront(view)
            }
        }

        UIView.kv_animate(animations: {
            viewsMap.forEach { (key, view) in
                if let frame = frameMap[key] {
                    view.frame = frame
                }
            }
        }, completion: { finish in
            
            layoutItemsComplete()
            
        })
    }
    
    func layoutItemsKepp(animate: Bool, _ layoutItemsComplete: @escaping ()->Void) {
        /// 做动画
        if self.subviews.count == 0 {
            layoutItemsComplete()
            return
        }
        
        var viewsMap: [String: GiftItemDisplayView] = [:]
        var frameMap: [String: CGRect] = [:]
        let giftMsgs = self.giftMsgs
        let rowH = self.rowH
        let subviews = self.subviews
        
        for i in 0..<subviews.count {
            let e = subviews[i]
            guard let view = e as? GiftItemDisplayView, let key = view.giftMsg?.playKey else { continue }
            frameMap[key] = view.frame
        }

        var fs: [CGRect] = []
        for i in 0..<maxCount {
            let frame = CGRect(x: 0, y: CGFloat(i)*(rowH+ItemSpace), width: self.bounds.width, height: rowH)
            var hasView = false
            for (_, f) in frameMap {
                if abs(f.origin.y - frame.origin.y) < 0.1 {
                    hasView = true
                    break
                }
            }
            if hasView == false {
                fs.append(frame)
            }
        }
        
        for i in 0..<subviews.count {
            let e = subviews[i]
            guard let view = e as? GiftItemDisplayView, let key = view.giftMsg?.playKey else { continue }
            let frame = view.frame
            if abs(self.bounds.height - frame.origin.y) < 0.1 {
                if let frame = fs.first {
                    frameMap[key] = frame
                    viewsMap[key] = view
                    fs.remove(at: 0)
                }
                
            }
        }
 
        if !animate {
            viewsMap.forEach { (key, view) in
                if let frame = frameMap[key] {
                    view.frame = frame
                }
            }
            layoutItemsComplete()
            return
        }
        
        giftMsgs.reversed().forEach { (it) in
            if let view = viewsMap[it.playKey] {
                self.bringSubviewToFront(view)
            }
        }

        UIView.kv_animate(animations: {
            viewsMap.forEach { (key, view) in
                if let frame = frameMap[key] {
                    view.frame = frame
                }
            }
        }, completion: { finish in
            
            layoutItemsComplete()
            
        })
    }
    
    func layoutItemsDrop(animate: Bool, _ layoutItemsComplete: @escaping ()->Void) {
        /// 做动画
        if self.subviews.count == 0 {
            layoutItemsComplete()
            return
        }
        
        var viewsMap: [String: GiftItemDisplayView] = [:]
        var frameMap: [String: CGRect] = [:]
        let giftMsgs = self.giftMsgs
        let rowH = self.rowH
        let subviews = self.subviews
        
        subviews.forEach { (view) in
            guard let view = view as? GiftItemDisplayView, let key = view.giftMsg?.playKey else { return }
            viewsMap[key] = view
        }
        
        for i in 0..<giftMsgs.count {
            let msg = giftMsgs[i]
            let y: CGFloat = CGFloat((i)) * (rowH+ItemSpace)
            let frame = CGRect(x: 0, y: y, width: self.bounds.width, height: rowH)
            frameMap[msg.playKey] = frame
        }
        
        let drop: CGFloat = self.bounds.height - (frameMap[giftMsgs.last?.playKey ?? ""]?.maxY ?? self.bounds.height)
        if drop != 0 {
            frameMap.forEach { (key, frame) in
                let f = CGRect(x: frame.origin.x, y: frame.origin.y+drop, width: frame.width, height: frame.height)
                frameMap[key] = f
            }
        }
        
        if !animate {
            viewsMap.forEach { (key, view) in
                if let frame = frameMap[key] {
                    view.frame = frame
                }
            }
            layoutItemsComplete()
            return
        }
        
        giftMsgs.reversed().forEach { (it) in
            if let view = viewsMap[it.playKey] {
                self.bringSubviewToFront(view)
            }
        }

        UIView.kv_animate(animations: {
            viewsMap.forEach { (key, view) in
                if let frame = frameMap[key] {
                    view.frame = frame
                }
            }
        }, completion: { finish in
            
            layoutItemsComplete()
            
        })
    }
    
    private func getOneView() -> GiftItemDisplayView {
        var view: GiftItemDisplayView!
        for item in self.viewsPool {
            if !item.isDisplay &&
                !self.subviews.contains(item) {
                view = item
                break
            }
        }

        if view == nil {
            view = Bundle.main.loadNibNamed(GiftItemDisplayView.className, owner: nil, options: nil)?.last as? GiftItemDisplayView
            view.layer.cornerRadius = rowH/2
            viewsPool.insert(view)
        }
        
        view.alpha = 1
        view?.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: rowH)
        
        view.stop()
        
        return view
    }

}

class GiftDisplayViewOpration: Operation {

    var task: ( (_ complete: @escaping ()->Void ) -> Void )?
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    private var _isExecuting: Bool = false {
        willSet {
           willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    override var isExecuting: Bool { _isExecuting }
    
    private var _isFinished: Bool = false {
        willSet {
           willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    override var isFinished: Bool { _isFinished }
    
    override var isAsynchronous: Bool { false }
    
    init(task: @escaping ( (_ complete: @escaping ()->Void ) -> Void )) {
        super.init()
        
        self.task = task
    }
    
    override func start() {
        // 任务将要开始
        self.semaphore.wait()
        defer {
            self.semaphore.signal()
        }
        
        // 已经取消就不进行了
        if isCancelled {
            return
        }
        
        DispatchQueue.main.async {
            self.task?({
                // 任务已经结束
                self.semaphore.wait()
                defer {
                    self.semaphore.signal()
                }

                // 已经取消就不通知上层了
                if self.isCancelled {
                    return
                }

                self._isFinished = true
                self._isExecuting = false
            })
        }
        
        _isExecuting = true
    }
    
    override func cancel() {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        
        // 已经完成了就不能取消
        if isFinished {
            return
        }
        
        super.cancel()
        _isFinished = true
        _isExecuting = false
        
    }

}
