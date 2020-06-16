//
//  CustomDraftAuctionTVC.swift
//  BidInCar
//
//  Created by Keyur on 14/02/20.
//  Copyright © 2020 Keyur. All rights reserved.
//

import UIKit

class CustomDraftAuctionTVC: UITableViewCell {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var addressLbl: Label!
    @IBOutlet weak var priceLbl: Label!
    @IBOutlet weak var activeBtn: Button!
    @IBOutlet weak var lotLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
