//
//  CustomCarCVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomCarCVC: UICollectionViewCell {

    @IBOutlet weak var outerView: View!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var starBtn: Button!
    @IBOutlet weak var titleLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : AuctionModel) {
        for temp in dict.pictures {
            if temp.type == "auction" {
                setImageViewImage(imgView, temp.path, IMAGE.AUCTION_PLACEHOLDER)
                break
            }
        }
        starBtn.isSelected = true
        titleLbl.text = dict.auction_title
    }
}
