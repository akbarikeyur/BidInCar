//
//  CustomCardCVC.swift
//  BidInCar
//
//  Created by Keyur on 19/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class CustomCardCVC: UICollectionViewCell {

    @IBOutlet weak var grayView: View!
    @IBOutlet weak var yellowView: View!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var primaryLbl: Label!
    @IBOutlet weak var numberLbl: Label!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var editBtn: Button!
    @IBOutlet weak var deleteBtn: Button!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
