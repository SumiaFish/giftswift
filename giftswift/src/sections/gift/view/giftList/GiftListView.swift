//
//  GiftListView.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class GiftListView: KVView, GiftListViewProtocol, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collctionView: KVCollectionView!
        
    var present: GiftListPresent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collctionView.dataSource = self
        collctionView.delegate = self
        collctionView.register(UINib(nibName: GiftListCell.className, bundle: nil), forCellWithReuseIdentifier: GiftListCell.className)
        collctionView.useDefaultStateView()
        collctionView.defaultStateView?.activetyIndicator.color = .white
        collctionView.defaultStateView?.backgroundColor = .black
        collctionView.isPagingEnabled = true
    }
    
    func loadding() {
        collctionView.loadding()
    }
    
    func complete(errorMsg: String?) {
        collctionView.complete(errorMsg: errorMsg)
    }
    
    func noData() {
        collctionView.noData()
    }
    
    func reloadData() {
        collctionView.reloadData()
    }
    
    override func display(isDisplay: Bool) {
        super.display(isDisplay: isDisplay)
        
        if isDisplay == false {
            present?.unselected()
        }
    }
    
    @IBAction func sendGiftAction(_ sender: Any) {
        present?.sendGift()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return present?.gifts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftListCell.className, for: indexPath) as! GiftListCell
        cell.gist = present?.gifts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 4, height: collectionView.bounds.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        present?.selected(idx: indexPath.row)
    }
    
}
