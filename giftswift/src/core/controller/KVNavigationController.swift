//
//  KVNavigationController.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVNavigationController: UINavigationController {

    override var prefersStatusBarHidden: Bool {  return self.viewControllers.last?.prefersStatusBarHidden ?? false }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.viewControllers.last?.preferredStatusBarStyle ?? UIStatusBarStyle.lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
