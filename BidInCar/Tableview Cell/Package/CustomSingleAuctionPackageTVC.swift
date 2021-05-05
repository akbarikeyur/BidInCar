//
//  CustomSingleAuctionPackageTVC.swift
//  BidInCar
//
//  Created by Keyur on 18/11/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomSingleAuctionPackageTVC: UITableViewCell {

    @IBOutlet weak var topSeperatorImg: UIImageView!
    @IBOutlet weak var bottomSeperatorImg: UIImageView!
    @IBOutlet weak var outerDotView: View!
    @IBOutlet weak var innerDotView: View!
    @IBOutlet weak var typeLbl: Label!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var totalAuctionLbl: Label!
    @IBOutlet weak var validityLbl: Label!
    @IBOutlet weak var bidderLbl: Label!
    @IBOutlet weak var vatLbl: Label!
    @IBOutlet weak var amountLbl: Label!
    @IBOutlet weak var featuredTitleLbl: Label!
    @IBOutlet weak var featuredValueLbl: Label!
    @IBOutlet weak var socialTitleLbl: Label!
    @IBOutlet weak var socialValueLbl: Label!
    @IBOutlet weak var featureBtn: UIButton!
    @IBOutlet weak var socialBtn: UIButton!
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
