//
//  SVGAPresent.swift
//  giftswift
//
//  Created by kevin on 2020/5/5.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class SVGAPresent: NSObject {

    var item: SVGAVideoEntity?
    
    func loadData() -> Promise<SVGAVideoEntity?> {
        if item != nil {
            return Promise{ filfull,_ in filfull(self.item) }
        }
        return SVGAData.loadData().then { (entity) -> SVGAVideoEntity? in
            self.item = entity
            return self.item
        }
    }
    
}

