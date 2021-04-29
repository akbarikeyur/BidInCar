//
//  CustomCarTVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomCarTVC: UITableViewCell {

    @IBOutlet weak var imgView: ImageView!
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var minPriceLbl: Label!
    @IBOutlet weak var currentBidLbl: Label!
    @IBOutlet weak var timeLbl: Label!
    @IBOutlet weak var starBtn: Button!
    @IBOutlet weak var bidNowBtn: Button!
    @IBOutlet weak var featureView: View!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : AuctionModel) {
        if dict.get_single_picture.path != "" {
            setImageViewImage(imgView, dict.get_single_picture.path, IMAGE.AUCTION_PLACEHOLDER)
        }else if dict.pictures.count > 0 {
            setImageViewImage(imgView, dict.pictures[0].path, IMAGE.AUCTION_PLACEHOLDER)
        }
        
        featureView.isHidden = (dict.auction_featured != "yes")
        titleLbl.text = dict.auction_title
        timeLbl.text = getRemainingTime(dict.auction_end + " " + dict.auction_end_time) + getTranslate("left_time_space") + getDateStringFromDateWithLocalTimezone(date: getDateFromDateString(strDate: dict.auction_end, format: "YYYY-MM-dd")!, format: "dd MMM, YYYY")
        if dict.auction_bidscount == "" {
            dict.auction_bidscount = "0"
        }
        minPriceLbl.text = getTranslate("bid_count_colon") + dict.auction_bidscount
        
        if dict.active_auction_price == "" {
            dict.active_auction_price = dict.auction_price
        }
        currentBidLbl.text = getTranslate("current_price_space") + displayPriceWithCurrency(dict.active_auction_price)
        
        starBtn.isSelected = (dict.bookmark == "yes")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
