//
//  CustomSideMenuTVC.swift
//  BidInCar
//
//  Created by Keyur on 17/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomSideMenuTVC: UITableViewCell {

    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var langSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //langSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        if L102Language.currentAppleLanguage() == "ar" || L102Language.currentAppleLanguage().contains("ar") {
            self.langSwitch.setOn(true, animated: false)
        }
        else{
            self.langSwitch.setOn(false, animated: false)
        }
    }

    @IBAction func clickToChangeLang(_ sender: UISwitch) {
        AppDelegate().sharedDelegate().changeLanguage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
