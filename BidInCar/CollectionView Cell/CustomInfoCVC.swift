//
//  CustomInfoCVC.swift
//  BidInCar
//
//  Created by Keyur Akbari on 02/11/20.
//  Copyright © 2020 Amisha. All rights reserved.
//

import UIKit

class CustomInfoCVC: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDetails(_ dict : InfoModel) {
        imgView.image = UIImage(named: dict.image)
        titleLbl.text = getTranslate(dict.name) + " " + dict.value
        
        if dict.link != "" {
            titleLbl.text = titleLbl.text! + " " + getTranslate(dict.link)
            titleLbl.attributedText = getAttributeStringWithColor(titleLbl.text!, [getTranslate(dict.link)], color: BlueColor, font: titleLbl.font, isUnderLine: true)
        }
    }
}
