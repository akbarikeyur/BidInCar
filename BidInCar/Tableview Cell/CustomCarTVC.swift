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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
