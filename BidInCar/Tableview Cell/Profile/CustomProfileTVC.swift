//
//  CustomProfileTVC.swift
//  BidInCar
//
//  Created by Keyur on 19/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

protocol CustomProfileDelegate {
    func updateProfileData(_ title : String, _ value : String)
}

class CustomProfileTVC: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var valueLbl: Label!
    @IBOutlet weak var valueTxt: TextField!
    @IBOutlet weak var seperatorImg: ImageView!
    @IBOutlet weak var valueBtn: UIButton!
    
    var delegate : CustomProfileDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateProfileData(titleLbl.text!, valueTxt.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
