//
//  CustomBookmarkTVC.swift
//  BidInCar
//
//  Created by Keyur on 17/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomBookmarkTVC: UITableViewCell {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var addressLbl: Label!
    @IBOutlet weak var lotLbl: Label!
    @IBOutlet weak var currentBidLbl: Label!
    @IBOutlet weak var reminderBtn: Button!
    @IBOutlet weak var eyeBtn: Button!
    @IBOutlet weak var bookmarkBtn: Button!
    @IBOutlet weak var bidLbl: Label!
    @IBOutlet weak var bidBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : AuctionModel) {
        for temp in dict.pictures {
            if temp.type == "auction" {
                setButtonBackgroundImage(profilePicBtn, temp.path, IMAGE.AUCTION_PLACEHOLDER)
                break
            }
        }
        titleLbl.text = dict.auction_title
        addressLbl.text = dict.auction_address
        if dict.active_auction_price == "" {
            dict.active_auction_price = dict.auction_price
        }
        currentBidLbl.text = getTranslate("current_bid_space") + displayPriceWithCurrency(dict.active_auction_price)
        bidLbl.text = getTranslate("bid_id") + String(dict.auction_bidscount)
        lotLbl.text = getTranslate("new_line_lot_id") + dict.auctionid
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
