//
//  MsgListView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class MsgListView: UIView, MsgListViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var present: MsgPrensent?
    
    private var rows: Int = 0
    
    private var autoScroll = true
    private var autoInsert = true
    private var didRead = 0
    private var unread = 0 {
        didSet {
            unreadButton.setTitle(String(unread)+"条未读", for: .normal)
            unreadButton.alpha = unread > 0 ? 1 : 0
//            unreadButton.sizeToFit()
//            let rect = (unreadButton.titleLabel?.text ?? "").boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: unreadButton.bounds.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
//            var frame = unreadButton.frame
//            frame.size.width = rect.width + 8
//            unreadButton.frame = frame
        }
    }
    
    private let queue: MsgListQueue = MsgListQueue()
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var unreadButton: UIButton!
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        if self.bounds.contains(point) && view != unreadButton {
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(tryAutoScroll), object: nil)
            autoScroll = false
            self.perform(#selector(tryAutoScroll), with: nil, afterDelay: 0.3)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.tryAutoInsert), object: nil)
                self.autoInsert = false
                self.perform(#selector(self.tryAutoInsert), with: nil, afterDelay: 1)
            }
        }

        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        
        tableView.register(UINib(nibName: MsgListCell.className, bundle: nil), forCellReuseIdentifier: MsgListCell.className)
        
        unread = 0
        unreadButton.layer.cornerRadius = 15
        unreadButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        queue.update = { [weak self] in
            self?.impShowMsg()
        }
    }
        
    func showMsg(msg: MsgProtocol) {
        
    }

    private func impShowMsg() {
        if !autoInsert {
            self.tableView.indexPathsForVisibleRows?.forEach({ (indexPath) in
                if indexPath.row > didRead {
                    didRead = indexPath.row
                }
            })
            let n = (present?.msgs.count ?? 0)-didRead
            unread = (n) >= 0 ? n : 0
            return
        }

        var indexPaths: [IndexPath] = []
        for i in rows..<(present?.msgs.count ?? rows) {
            let indexPath = IndexPath(row: i, section: 0)
            indexPaths.append(indexPath)
        }
        
        rows = present?.msgs.count ?? 0
        
        unread = 0
        didRead = rows
        
        if indexPaths.count > 0 {
            UIView.performWithoutAnimation {
                tableView.insertRows(at: indexPaths, with: .bottom)
            }
        }
        
        if rows > 0, autoScroll {
            tableView.scrollToRow(at: IndexPath(row: rows-1, section: 0), at: .bottom, animated: false)
        }
    }
    
    @IBAction func unreadAction(_ sender: Any) {
        autoScroll = true
        autoInsert = true
        unread = 0
        
        impShowMsg()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            stoppedScrolling()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        tryAutoScroll()
    }
    
    func stoppedScrolling() {
        tryAutoScroll()
        tryAutoInsert()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MsgListCell.className, for: indexPath) as! MsgListCell
        cell.contentLab.text = present?.msgs[indexPath.row].text
        
        return cell
    }
    
    @objc func tryAutoScroll() {
        var isInBot = false
        tableView.indexPathsForVisibleRows?.forEach({ (indexPath) in
            if isInBot == false {
                isInBot = indexPath.row >= self.rows - 1
            }
        })
        autoScroll = isInBot
    }
    
    @objc func tryAutoInsert() {
        var isInBot = false
        tableView.indexPathsForVisibleRows?.forEach({ (indexPath) in
            if isInBot == false {
                isInBot = indexPath.row >= self.rows - 1
            }
        })
        autoInsert = isInBot
    }
    
}


class MsgListQueue: NSObject {
    
    var update: (()->Void)?
    
    private var displayLink: CADisplayLink?
    
    deinit {
        displayLink?.invalidate()
        displayLink?.remove(from: .current, forMode: .common)
    }
    
    override init() {
        super.init()
        
        displayLink = CADisplayLink(target: self, selector: #selector(run))
        if #available(iOS 10, *) {
            displayLink?.preferredFramesPerSecond = 5
        } else {
            displayLink?.frameInterval = 5
        }
        
        displayLink?.add(to: .current, forMode: .common)
    }
    
    @objc private func run() {
        update?()
    }
    
}
