//
//  DepositHistoryTVC.swift
//  BidInCar
//
//  Created by Keyur Akbari on 15/12/20.
//  Copyright © 2020 Amisha. All rights reserved.
//

import UIKit

class DepositHistoryTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var paymentLbl: Label!
    @IBOutlet weak var amountLbl: Label!
    @IBOutlet weak var statusLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : DepositeModel) {
        dateLbl.text = dict.createdon
        paymentLbl.text = "Paytabs"
        amountLbl.text = displayPriceWithCurrency(dict.deposite_amount)
        statusLbl.text = dict.deposite_status.capitalized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
