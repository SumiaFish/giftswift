//
//  KVCollectionView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol KVCollectionViewProtocol: KVCollectionView {
    
}

protocol KVCollectionViewPresentProtocol: NSObjectProtocol {
    
    func loadData(for collectionView: KVCollectionView, isRefresh: Bool)

}

class KVCollectionView: UICollectionView {

    var present: KVCollectionViewPresentProtocol?

}

extension KVCollectionView: KVStateViewProtocl {
    
    private static var KVStateViewKey: Void?
    var stateView: KVStateViewProtocl? {
        set {
            objc_setAssociatedObject(self, &KVCollectionView.KVStateViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &KVCollectionView.KVStateViewKey) as? KVStateViewProtocl
        }
    }
    
    var defaultStateView: KVListViewStateView? {
        return self.stateView as? KVListViewStateView
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
