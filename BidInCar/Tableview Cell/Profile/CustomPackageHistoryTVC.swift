//
//  CustomPackageHistoryTVC.swift
//  BidInCar
//
//  Created by Keyur on 27/01/20.
//  Copyright © 2020 Keyur. All rights reserved.
//

import UIKit

class CustomPackageHistoryTVC: UITableViewCell {

    @IBOutlet weak var purchaseDatelbl: Label!
    @IBOutlet weak var packageNameLbl: Label!
    @IBOutlet weak var totalAuctionLbl: Label!
    @IBOutlet weak var auctionPostedLbl: Label!
    @IBOutlet weak var remainingAuctionLbl: Label!
    @IBOutlet weak var expireLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
