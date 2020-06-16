//
//  CustomPackageTVC.swift
//  BidInCar
//
//  Created by Keyur on 19/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomPackageTVC: UITableViewCell {

    @IBOutlet weak var title1Lbl: Label!
    @IBOutlet weak var title2Lbl: Label!
    @IBOutlet weak var title3Lbl: Label!
    @IBOutlet weak var value1Lbl: Label!
    @IBOutlet weak var value2Lbl: Label!
    @IBOutlet weak var value3Lbl: Label!
    @IBOutlet weak var topLineImg: ImageView!
    @IBOutlet weak var bottomLineImg: ImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
