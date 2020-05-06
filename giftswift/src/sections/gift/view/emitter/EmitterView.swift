//
//  EmitterView.swift
//  giftswift
//
//  Created by kevin on 2020/5/6.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class EmitterView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if button.frame.contains(point) && self.alpha == 1 && self.isHidden == false {
            return button
        }
        return nil
    }
    
    let button = UIButton(type: .system)
    
    init() {
        super.init(frame: .zero)
        
        button.setImage(UIImage(named: "good2_30x30")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = CGRect(x: self.bounds.width-30-40, y: self.bounds.height-280, width: 40, height: 40)
    }
    
    @objc func buttonAction() {
        play()
    }
    
    @objc func play(duration: TimeInterval = 3) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stop), object: nil)
        emited()
        self.perform(#selector(stop), with: nil, afterDelay: duration)
    }
    
    @objc func stop() {
        self.layer.sublayers?.forEach({ (it) in
            if let layer = it as? CAEmitterLayer {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    private func emited() {
        self.layer.addSublayer(self.getOneEmitter(scale: 0.5))
        
//        DispatchQueue.global().async {
//            for i in (0..<3).reversed() {
//                Thread.sleep(forTimeInterval: Double(i)*1)
//                DispatchQueue.main.async {
//                    self.layer.addSublayer(self.getOneEmitter(scale: CGFloat(i+1)*0.5))
//                }
//            }
//        }
    }
    
    private func getOneEmitter(scale: CGFloat) -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
  
        emitterLayer.frame = self.bounds
        emitterLayer.emitterPosition = button.center
        // 发射器在xy平面的中心位置
//        emitterLayer.emitterPosition = CGPoint(x: self.bounds.width - 20, y: self.bounds.height-100)
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSize(width: 20, height: 20)
         // 渲染模式
        emitterLayer.renderMode = .unordered
        // 从哪个部位发射
        emitterLayer.emitterMode = .volume
        emitterLayer.scale = 1// Float(scale)
        emitterLayer.emitterCells = Array()
        for _ in 0..<1 {
            let cell = self.getOneCell(scale: scale)
            emitterLayer.emitterCells?.append(cell)
        }
        
        return emitterLayer
    }
    
    private func getOneCell(scale: CGFloat) -> CAEmitterCell {
        let cell = CAEmitterCell()
        // 粒子的创建速率，默认为1/s
        cell.birthRate = 1
        // 粒子存活时间
        cell.lifetime = 3// Float(i+1)// Float(arc4random_uniform(4)) + 1.0
        // 粒子的生存时间容差
        cell.lifetimeRange = 0.5
        // 粒子显示的内容
//            cell.color = UIColor.systemPink.cgColor
        cell.contents = UIImage(named: "good\(2)_30x30")?.cgImage
        // 粒子的运动速度
        cell.velocity = 200// CGFloat(arc4random_uniform(100) + 100);
        // 粒子速度的容差
        cell.velocityRange = 80
        // 粒子在xy平面的发射角度
        cell.emissionLongitude = CGFloat(Double.pi+Double.pi/2)
        // 粒子发射角度的容差
        cell.emissionRange = CGFloat(Double.pi/2/6)
        // 缩放比例
        cell.scale = scale
        cell.scaleRange = 0.5
//        cell.scale = CGFloat(emitterLayer.scale) * CGFloat(i+1) * 0.2
        
        return cell
    }

}
