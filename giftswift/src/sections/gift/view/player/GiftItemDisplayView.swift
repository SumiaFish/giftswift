//
//  GiftItemDisplayView.swift
//  giftswift
//
//  Created by kevin on 2020/5/3.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class GiftItemDisplayView: UIView, GiftRenderViewProtocol {

    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var giftView: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var gnameLab: UILabel!
    
    private var countLab: UILabel = UILabel()
    
    private(set) var giftMsg: GiftMsg?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        countLab.font = UIFont.systemFont(ofSize: 18)
        countLab.textColor = .orange
        countLab.textAlignment = .center
        countLab.adjustsFontSizeToFitWidth = true
        self.addSubview(countLab)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        countLab.frame = CGRect(x: giftView.frame.maxX, y: 0, width: self.bounds.width-giftView.frame.maxX, height: self.bounds.height)
    }

    func play(giftMsg: GiftMsg) {
        let animated = giftMsg.serialCount != (self.giftMsg?.serialCount ?? 0)
        
        self.giftMsg = giftMsg
        
        if let icon = giftMsg.gift.icon {
            avatarView.sd_setImage(with: URL(string: icon), completed: nil)
        }
        if let icon = giftMsg.gift.icon {
            giftView.sd_setImage(with: URL(string: icon), completed: nil)
        }
        nameLab.text = giftMsg.gift.username
        gnameLab.text = giftMsg.gift.name
        countLab.text = "x " + String(giftMsg.serialCount)

        if animated {
            setAnimation(view: countLab)
        }
    }

    func stop() {
        avatarView.image = nil
        giftView.image = nil
        gnameLab.text = ""
        nameLab.text = ""
    }
    
    func setAnimation(view: UIView) {
    #if false
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.duration = 0.1
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = NSNumber(floatLiteral: 1.0)
        pulse.fromValue = NSNumber(floatLiteral: 1.5)
        view.layer.add(pulse, forKey: nil)
    #else

        let t: TimeInterval = 0.08
        
        UIView.animate(withDuration: t, animations: {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (finish) in
            UIView.animate(withDuration: t) {
                view.transform = .identity
            }
        }
        
    #endif
    }

}
