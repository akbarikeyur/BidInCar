//
//  LuckyDrawUserTVC.swift
//  BidInCar
//
//  Created by Keyur on 08/04/21.
//  Copyright © 2021 Amisha. All rights reserved.
//

import UIKit

class LuckyDrawUserTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var noLbl: Label!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var cityLbl: Label!
    @IBOutlet weak var couponLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
