//
//  CustomMultiAuctionPackageTVC.swift
//  BidInCar
//
//  Created by Keyur on 19/11/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomMultiAuctionPackageTVC: UITableViewCell {

    @IBOutlet weak var topSeperatorImg: UIImageView!
    @IBOutlet weak var bottomSeperatorImg: UIImageView!
    @IBOutlet weak var outerDotView: View!
    @IBOutlet weak var innerDotView: View!
    
    @IBOutlet weak var typeLbl: Label!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var totalAuctionLbl: Label!
    @IBOutlet weak var validityLbl: Label!
    @IBOutlet weak var amountLbl: Label!
    @IBOutlet weak var vatLbl: Label!
    @IBOutlet weak var descLbl: Label!
    @IBOutlet weak var savingLbl: Label!
    @IBOutlet weak var totalLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
