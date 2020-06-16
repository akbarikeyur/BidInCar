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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
