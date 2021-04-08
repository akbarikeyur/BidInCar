//
//  BuyerPackageTVC.swift
//  BidInCar
//
//  Created by Keyur on 08/04/21.
//  Copyright © 2021 Amisha. All rights reserved.
//

import UIKit

class BuyerPackageTVC: UITableViewCell {

    @IBOutlet weak var typeLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    
    @IBOutlet weak var title1Lbl: Label!
    @IBOutlet weak var title2Lbl: Label!
    @IBOutlet weak var title3Lbl: Label!
    @IBOutlet weak var title4Lbl: Label!
    @IBOutlet weak var title5Lbl: Label!
    @IBOutlet weak var title6Lbl: Label!
    
    @IBOutlet weak var value1Lbl: Label!
    @IBOutlet weak var value2Lbl: Label!
    @IBOutlet weak var value3Lbl: Label!
    @IBOutlet weak var value4Lbl: Label!
    @IBOutlet weak var value5Lbl: Label!
    @IBOutlet weak var value6Lbl: Label!
    
    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var bottomImg: UIImageView!
    @IBOutlet weak var selectView: View!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
