//
//  CustomAuctionCategoryCVC.swift
//  BidInCar
//
//  Created by Keyur on 09/03/20.
//  Copyright © 2020 Keyur. All rights reserved.
//

import UIKit

class CustomAuctionCategoryCVC: UICollectionViewCell {

    @IBOutlet weak var catImgBtn: UIButton!
    @IBOutlet weak var catLbl: Label!
    @IBOutlet weak var seperatorImg: ImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetail(_ dict : AuctionTypeModel) {
        setButtonImage(catImgBtn, dict.img)
        catLbl.text = dict.name
    }
}
