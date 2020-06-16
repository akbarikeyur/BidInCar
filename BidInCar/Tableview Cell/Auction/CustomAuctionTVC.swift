//
//  CustomAuctionTVC.swift
//  BidInCar
//
//  Created by Keyur on 18/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomAuctionTVC: UITableViewCell {

    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var addressLbl: Label!
    @IBOutlet weak var schedulaerbtn: Button!
    @IBOutlet weak var makeFeatureBtn: Button!
    @IBOutlet weak var reminderBtn: Button!
    @IBOutlet weak var eyeBtn: Button!
    @IBOutlet weak var bookmarkBtn: Button!
    @IBOutlet weak var currentBidLbl: Label!
    @IBOutlet weak var lotLbl: Label!
    @IBOutlet weak var bidNowBtn: Button!
    @IBOutlet weak var bidLbl: Label!
    
    @IBOutlet weak var winnerLbl: Label!
    @IBOutlet weak var winnerStatusLbl: Label!
    @IBOutlet weak var winnerPriceLbl: Label!
    
    @IBOutlet weak var withdrawView: View!
    @IBOutlet weak var withdrawBtn: UIButton!
    @IBOutlet weak var winningPriceView: UIView!
    @IBOutlet weak var payNowVew: UIView!
    @IBOutlet weak var payNowBtn: UIButton!
    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var winnerBottomView: UIView!
    
    @IBOutlet weak var winnerBtn: UIButton!
    
    @IBOutlet weak var leftActionView: UIView!
    @IBOutlet weak var constraintWidthLeftActionView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var newFrame = withdrawView.frame
        newFrame.size.width = SCREEN.WIDTH - 20
        withdrawView.frame = newFrame
        winningPriceView.frame = newFrame
        payNowVew.frame = newFrame
        winnerView.frame = newFrame
        
        withdrawView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        winningPriceView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        payNowVew.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)

        winnerBottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
