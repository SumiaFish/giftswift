//
//  GiftListCell.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class GiftListCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    private lazy var selectedView = UIView()
    
    var gist: Gift? {
        didSet {
            if let icon = gist?.icon {
                imageView.sd_setImage(with: URL(string: icon), completed: nil)
            }
            nameLab.text = gist?.name
            selectedView.isHidden = !(gist?.isSelected ?? false) 
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.selectedBackgroundView = UIView()
//        self.selectedBackgroundView?.backgroundColor = .orange
        
        selectedView.backgroundColor = .orange
        self.contentView.insertSubview(selectedView, at: 0)
        selectedView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedView.frame = self.contentView.bounds
    }

}
