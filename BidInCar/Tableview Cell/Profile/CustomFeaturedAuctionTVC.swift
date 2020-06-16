//
//  CustomFeaturedAuctionTVC.swift
//  BidInCar
//
//  Created by Keyur on 26/01/20.
//  Copyright © 2020 Keyur. All rights reserved.
//

import UIKit

class CustomFeaturedAuctionTVC: UITableViewCell {

    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var paymentMethodLbl: Label!
    @IBOutlet weak var amountLbl: Label!
    @IBOutlet weak var auctionnameLbl: Label!
    @IBOutlet weak var statusLbl: Label!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
