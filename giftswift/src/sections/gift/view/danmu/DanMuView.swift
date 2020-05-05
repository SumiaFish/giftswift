//
//  DanMuView.swift
//  giftswift
//
//  Created by kevin on 2020/5/5.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class DanmuItemView: UIButton, DanMUItemViewProtocol {
    
    var msg: MsgProtocol?
    
    func play(msg: MsgProtocol) {
        self.msg = msg
        self.alpha = 1
        self.setTitle(msg.text ?? "", for: .normal)
    }
    
    func stop() {
        self.msg = nil
        self.setTitle("", for: .normal)
        self.alpha = 0
    }
    
    func getMsg() -> MsgProtocol? {
        return msg
    }
    
}

class DanMuView: UIView, DanmuViewProtocol {

    var msgs: [MsgProtocol] = []
    
    var viewsPool: Set = Set<DanmuItemView>()
    
    let rowH: CGFloat = 30
    
    let queue = OperationQueue()
    
    private var currentTrajectory: Int = 0
//    private var trajectoryMap: [Int: Bool] = [ :]
    private var trajectoryStates: [Bool] = []
    
    init() {
        super.init(frame: .zero)
        queue.maxConcurrentOperationCount = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play(msgs: [MsgProtocol]) {

        var arr: [MsgProtocol] = []
        arr.append(contentsOf: msgs)
        
        let sorted: [MsgProtocol] = arr.sorted { (m1, m2) -> Bool in
            return m1.receiveTime < m2.receiveTime
        }
        
        for i in 0..<sorted.count {
            queue.addOperation { [weak self] in
                var t: TimeInterval = 0
                if i != 0 {
                    t = abs(sorted[i].receiveTime - sorted[i-1].receiveTime)
                }
                
                if t > 0 {
                    Thread.sleep(forTimeInterval: t)
                }
                
                DispatchQueue.main.async {
                    guard let view = self?.getOneView() else {
                        return
                    }
                    // 更新弹道
                    let y: CGFloat = self?.upTrajectory() ?? 0
                    let msg = sorted[i]
                    
                    view.play(msg: msg)
                    view.sizeToFit()
                    
                    var frame = view.frame
                    frame.origin.x = self?.bounds.width ?? 0 + frame.width
                    frame.origin.y = y
                    view.frame = frame
                    self?.addSubview(view)
                    
                    let dv = TimeInterval(CGFloat(getRandom(from: 5, to: 8))*1.0)
                    var duration: TimeInterval = dv
                    if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
                        duration = dv
                    } else {
                        duration = TimeInterval(UIScreen.main.bounds.width / UIScreen.main.bounds.height * CGFloat(dv))
                    }
                    let currentTrajectory = self?.currentTrajectory ?? 0
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                        // 释放弹道
//                        self?.releaseTrajectory(i: currentTrajectory)
//                    }
                    UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                        var frame = view.frame
                        frame.origin.x = -frame.width
                         view.frame = frame
                    }) { (finish) in
                        view.removeFromSuperview()
                        view.stop()
                        // 释放弹道
                        self?.releaseTrajectory(i: currentTrajectory)
                    }

                }
                
            }
            
            self.msgs.removeAll()
            self.msgs.append(contentsOf: msgs)
        }

    }

    func stop() {
        self.msgs.removeAll()
        subviews.forEach { (it) in
            it.removeFromSuperview()
        }
    }
    
    func getMsgs() -> [MsgProtocol] {
        return msgs
    }
    
    func getOneView() -> DanmuItemView {
        
        var view: DanmuItemView!
        for item in self.viewsPool {
            if item.msg == nil &&
                item.alpha == 0 &&
                !self.subviews.contains(item) {
                view = item
                break
            }
        }

        if view == nil {
            view = DanmuItemView(type: .custom)
            view.backgroundColor = .clear
            view.setTitleColor(.white, for: .normal)
            view.setTitleShadowColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
            view.titleLabel?.shadowOffset = CGSize(width: 2, height: -1)
            view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            viewsPool.insert(view)
        }
        
        view.alpha = 1
        view?.frame = CGRect(x: self.bounds.width, y: 0, width: 0, height: rowH)
        
        view.stop()
        
        return view
        
    }
    
    func upTrajectory() -> CGFloat {
        if self.trajectoryStates.count == 0 {
            self.currentTrajectory = 0
            self.trajectoryStates.append(true)
            return 0
        }
        
        for i in 0..<self.trajectoryStates.count {
            let ret = self.trajectoryStates[i]
            if ret {
                self.currentTrajectory = i
                self.trajectoryStates[i] = false
                return CGFloat(self.currentTrajectory) * (self.rowH)
            }
        }
        
        self.currentTrajectory += 1
        var y = CGFloat(self.currentTrajectory) * (self.rowH)
        if y >= self.bounds.height {
            self.currentTrajectory = 0
            y = 0
        } else {
            if self.trajectoryStates.count <= self.currentTrajectory {
                self.trajectoryStates.append(false)
            } else {
                self.trajectoryStates[self.currentTrajectory] = false
            }
        }
        return y
    }
    
    func releaseTrajectory(i: Int) {
        if self.trajectoryStates.count <= i {
            return
        } else {
            self.trajectoryStates[i] = false
        }
    }

}
