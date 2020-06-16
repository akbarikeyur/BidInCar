//
//  WelcomeVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var subTitleLbl: Label!
    @IBOutlet weak var catImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleImg.alpha = 0
        subTitleLbl.alpha = 0
        catImg.alpha = 0
        
        UIView.animate(withDuration: 1.0, animations: {
            self.titleImg.alpha = 1.0
        }) { (isDone) in
            UIView.animate(withDuration: 1.0, animations: {
                self.subTitleLbl.alpha = 1.0
            }) { (isDone) in
                UIView.animate(withDuration: 1.0, animations: {
                    self.catImg.alpha = 1.0
                }) { (isDone) in
                    delay(0.5) {
                        AppDelegate().sharedDelegate().navigateToDashBoard()
                    }
                }
            }
        }
        
    }
    
}
