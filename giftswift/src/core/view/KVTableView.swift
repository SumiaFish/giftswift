//
//  KVTableView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol KVTableViewProtocol: KVTableView {
    
}

protocol KVTableViewPresentProtocol: NSObjectProtocol {
    
    func loadData(for tableView: KVTableView, isRefresh: Bool)

}

class KVTableView: UITableView {

    var present: KVTableViewPresentProtocol?

}

extension KVTableView: KVStateViewProtocl {
    
    private static var KVStateViewKey: Void?
    var stateView: KVStateViewProtocl? {
        set {
            objc_setAssociatedObject(self, &KVTableView.KVStateViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &KVTableView.KVStateViewKey) as? KVStateViewProtocl
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.stateView?.frame = self.bounds
    }
    
    // MARK: -
    
    func useDefaultStateView() {
        if let stateView = Bundle.main.loadNibNamed(KVListViewStateView.className, owner: nil, options: nil)?.last as? KVListViewStateView {
            self.addSubview(stateView)
            self.stateView = stateView
        }
    }
 
    // MARK: -
    
    func loadding() {
        stateView?.loadding()
    }
    
    func complete(errorMsg: String?) {
        if errorMsg == nil {
            self.reloadData()
        }
        stateView?.complete(errorMsg: errorMsg)
    }

    func noData() {
        stateView?.noData()
    }

}
