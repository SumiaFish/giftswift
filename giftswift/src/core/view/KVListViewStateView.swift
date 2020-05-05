//
//  KVListViewStateView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVListViewStateView: UIView, KVStateViewProtocl {

    @IBOutlet weak var activetyIndicator: UIActivityIndicatorView!
   
    @IBOutlet weak var msgLab: UILabel!
    
    var noDataText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activetyIndicator.isHidden = true
        activetyIndicator.hidesWhenStopped = true
        
        msgLab.isHidden = true
    }

    func loadding() {
        activetyIndicator.isHidden = true
        msgLab.isHidden = true
        
        activetyIndicator.startAnimating()
        
        self.isHidden = false
    }
    
    func complete(errorMsg: String?) {
        activetyIndicator.stopAnimating()
        msgLab.isHidden = false
        msgLab.text = noDataText ?? ""
        
        self.isHidden = errorMsg == nil
    }
    
    func noData() {
        activetyIndicator.stopAnimating()
        msgLab.isHidden = false
        msgLab.text = noDataText ?? "空空如也~"
        
        self.isHidden = false
    }

}
