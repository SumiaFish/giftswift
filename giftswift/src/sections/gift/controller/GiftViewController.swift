//
//  GiftViewController.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class GiftViewController: KVViewController, KVViewDisplayContext, UITextFieldDelegate, SVGAPlayerDelegate {

    override var navigationBarHiddenWhenAppear: Bool { true }
    
    private lazy var giftListView: GiftListView? = Bundle.main.loadNibNamed(GiftListView.className, owner: nil, options: nil)?.last as? GiftListView
    
    private lazy var gifDisplayView: GifGiftDisplayView? = Bundle.main.loadNibNamed(GifGiftDisplayView.className, owner: nil, options: nil)?.last as? GifGiftDisplayView
    
    private lazy var msgListView: MsgListView? = Bundle.main.loadNibNamed(MsgListView.className, owner: nil, options: nil)?.last as? MsgListView
    
    private lazy var giftListDisplayView: GiftListDisplayView? = Bundle.main.loadNibNamed(GiftListDisplayView.className, owner: nil, options: nil)?.last as? GiftListDisplayView
    
    private lazy var danmuView: DanMuView = DanMuView()
    
    private lazy var giftListDisplayContainerView = UIView()
    
    private lazy var emitterView = EmitterView()
    
    @IBOutlet weak var tf: UITextField!
    
    @IBOutlet weak var tfBottom: NSLayoutConstraint!
    
    @IBOutlet weak var svgaButtton: UIButton!
        
    private var bg: UIImageView!
    
    private let giftPlayer = GiftListPlayer()
    
    private let danmuPlayer = DanmuPlayer()
    
    private lazy var svgaPlayer = SVGAPlayer()
    
    private let svgaPresent = SVGAPresent()
    
    private var didMoveView = false
    
    private let autoSender = AutoSenderGift()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        bg = UIImageView(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "unnamed.jpg", ofType: nil) ?? ""))
        bg.frame = self.view.bounds
        bg.isUserInteractionEnabled = false
        bg.contentMode = .scaleAspectFill
        self.view.addSubview(bg)
        
        tf.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoaedWillShow(notifi:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoaedWillHide(notifi:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        svgaPlayer.frame = self.view.bounds
        self.view.addSubview(svgaPlayer)
        svgaPlayer.delegate = self
        svgaPlayer.loops = 1
        svgaPlayer.clearsAfterStop = true
        svgaPlayer.isUserInteractionEnabled = false
        
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        svgaButtton.layer.cornerRadius = 22
        svgaButtton.addSubview(ai)
        ai.frame = svgaButtton.bounds
        ai.hidesWhenStopped = true
        ai.stopAnimating()
        
        self.view.addSubview(emitterView)
        emitterView.frame = self.view.bounds
        
        initMsgListView()
        initGiftListView()
        initGifDisplayView()
        initGiftListDisplayView()
        initDanmuView()
        
        giftListDisplayView!.backgroundColor = .clear
        gifDisplayView!.backgroundColor = .clear
        msgListView!.backgroundColor = .clear
        msgListView?.tableView.backgroundColor = .clear
        danmuView.backgroundColor = .clear
        emitterView.backgroundColor = .clear
        
        fixSubviewsZIndex()
                        
        giftPlayer.gifView = gifDisplayView
        giftPlayer.view = giftListDisplayView
        danmuPlayer.view = danmuView
        
        _ = giftListView?.present?.loadGifts().then({ (data) in
            self.autoSender.gifts = data
        })

    }
    
    // MARK: -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @objc func keyBoaedWillShow(notifi: Notification) {
        if let keyboardSize = (notifi.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let t = notifi.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: t) {
                    if #available(iOS 11.0, *) {
                        self.tfBottom.constant = -keyboardSize.height + self.view.safeAreaInsets.bottom
                    } else {
                        self.tfBottom.constant = -keyboardSize.height
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyBoaedWillHide(notifi: Notification) {
        if let _ = (notifi.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let t = notifi.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: t) {
                    self.tf.snp.updateConstraints { (make) in
                        if #available(iOS 11.0, *) {
                            self.tfBottom.constant = 0//self.view.safeAreaInsets.bottom
                        } else {
                            self.tfBottom.constant = 0
                        }
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func onView(displayChange view: UIView, isDisplay: Bool) {
        if view == giftListView {
            UIView.kv_animate(animations: {
                view.snp.updateConstraints { (make) in
                    make.bottom.equalTo(isDisplay ? 0 : 300)
                }
                self.view.layoutIfNeeded()
                view.alpha = isDisplay ? 1 : 0
            })
            self.view.bringSubviewToFront(giftListView!.bgv)
            self.view.bringSubviewToFront(view)
        } else if view == self.gifDisplayView {
            view.alpha = isDisplay ? 1 : 0
        }
    }
    
    @IBAction func showGiftListAction(_ sender: Any) {
        giftListView?.display(isDisplay: !(giftListView?.isDisplay ?? true))
    }
    
    @IBAction func ascAction(_ sender: Any) {
        giftPlayer.animationType = .asc
        
    }
    
    @IBAction func keepAction(_ sender: Any) {
        giftPlayer.animationType = .keep
        
    }
    
    @IBAction func dropAction(_ sender: Any) {
        giftPlayer.animationType = .drop
        
    }
    
    @IBAction func autoSennderAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            autoSender.start()
        } else {
            autoSender.stop()
        }
        
    }
    
    @IBAction func svgaAction(_ sender: Any) {
        svgaButtton.isUserInteractionEnabled = false
        svgaButtton.setTitle("", for: .normal)
        _ = svgaButtton.subviews.map { (it) in
            if let view = it as? UIActivityIndicatorView {
                view.startAnimating()
            }
        }
        svgaPresent.loadData().then { (item) in
           self.svgaPlayer.videoItem = item!
           self.svgaPlayer.startAnimation()
        }.always {
            self.svgaButtton.isUserInteractionEnabled = true
            self.svgaButtton.setTitle("+", for: .normal)
            _ = self.svgaButtton.subviews.map { (it) in
                if let view = it as? UIActivityIndicatorView {
                    view.stopAnimating()
                }
            }
        }
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        let dismiss = sender.direction == .left
        UIView.kv_animate(animations: {
            self.giftListDisplayContainerView.snp.updateConstraints { (make) in
                let left = dismiss ? 0-(240 - (50-8*2+60)) : 20
                make.left.equalToSuperview().offset(left)
            }
            self.view.layoutIfNeeded()
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.count > 0 {
            msgListView?.present?.sendMsg(msg: Msg(id: UUID().uuidString, receiveTime: Date().timeIntervalSince1970, text: text))
        }
        textField.text = ""
        self.view.endEditing(true)
        return true
    }
    
    // MARK: -
    
    func svgaPlayerDidAnimated(toFrame frame: Int) {
        if !didMoveView {
            self.view.bringSubviewToFront(bg)
            self.view.bringSubviewToFront(svgaPlayer)
            didMoveView = true
        }
        
    }
    
    func svgaPlayerDidAnimated(toPercentage percentage: CGFloat) {
        
    }
    
    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        fixSubviewsZIndex()
        didMoveView = false
    }

    
    // MARK: -
    
    private func initGiftListView() {
        if let view = giftListView {
            self.view.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
                make.height.equalTo(300)
            }
            view.displayContext = self
            
            self.view.insertSubview(view.bgv, belowSubview: view)
            view.bgv.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalToSuperview()
            }
            view.bgv.backgroundColor = .clear
            view.present = GiftListPresent()
            view.present?.listView = view
            view.present?.msgSender = msgListView?.present
        }
    }
    
    private func initGifDisplayView() {
        if let view = gifDisplayView {
            self.view.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalTo(0)
                make.height.equalTo(400)
            }
            view.displayContext = self
            
            gifDisplayView = view
        }
    }
    
    private func initMsgListView() {
        if let view = msgListView {
            self.view.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(320)
            }
            view.present = MsgPrensent()
            view.present?.msgListView = view
            
            msgListView = view
        }
    }
    
    private func initGiftListDisplayView() {
        if let view = giftListDisplayView {
            self.view.addSubview(giftListDisplayContainerView)
            giftListDisplayContainerView.snp.makeConstraints { (make) in
                make.bottom.equalTo(0-300-20)
                make.left.equalToSuperview().offset(20)
                make.width.equalTo(240)
                make.height.equalTo(50*GiftDisplayListMaxCount+Int(ItemSpace)*GiftDisplayListMaxCount-1)
            }
            giftListDisplayContainerView.clipsToBounds = true
            let swipeL = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
            let swipeR = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
            swipeL.direction = .left
            swipeR.direction = .right
            giftListDisplayContainerView.addGestureRecognizer(swipeL)
            giftListDisplayContainerView.addGestureRecognizer(swipeR)
            
            giftListDisplayContainerView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.width.equalTo(240)
                make.height.equalToSuperview()
            }
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = false
        }
    }

    private func initDanmuView() {
        self.view.addSubview(danmuView)
        danmuView.snp.makeConstraints { (make) in
            make.top.equalTo(64 + (getIsIPhonexSerious() ? 20 : 0) )
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    private func fixSubviewsZIndex() {
        self.view.sendSubviewToBack(svgaPlayer)
        self.view.sendSubviewToBack(giftListView!)
        self.view.sendSubviewToBack(giftListView!.bgv)
        self.view.sendSubviewToBack(tf)
        self.view.sendSubviewToBack(svgaButtton)
        self.view.sendSubviewToBack(emitterView)
        self.view.sendSubviewToBack(giftListDisplayContainerView)
        self.view.sendSubviewToBack(danmuView)
        self.view.sendSubviewToBack(gifDisplayView!)
        self.view.sendSubviewToBack(msgListView!)
        self.view.sendSubviewToBack(bg)
    }
    
}
