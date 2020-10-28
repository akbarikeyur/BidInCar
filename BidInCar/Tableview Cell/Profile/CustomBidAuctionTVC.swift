//
//  CustomBidAuctionTVC.swift
//  BidInCar
//
//  Created by Keyur on 27/01/20.
//  Copyright © 2020 Keyur. All rights reserved.
//

import UIKit

class CustomBidAuctionTVC: UITableViewCell {

    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var auctionNameLbl: Label!
    @IBOutlet weak var currentBidLbl: Label!
    @IBOutlet weak var yourBidLbl: Label!
    @IBOutlet weak var statusLbl: Label!
    @IBOutlet weak var viewBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
