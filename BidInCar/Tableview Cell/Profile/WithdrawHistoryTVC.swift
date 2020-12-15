//
//  WithdrawHistoryTVC.swift
//  BidInCar
//
//  Created by Keyur Akbari on 15/12/20.
//  Copyright © 2020 Amisha. All rights reserved.
//

import UIKit

class WithdrawHistoryTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dateLbl: Label!
    @IBOutlet weak var amountLbl: Label!
    @IBOutlet weak var feeLbl: Label!
    @IBOutlet weak var statusLbl: Label!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDetails(_ dict : WithdrawModel) {
        dateLbl.text = dict.created_at
        amountLbl.text = displayPriceWithCurrency(dict.withdrawl_amount)
        feeLbl.text = "5%"
        statusLbl.text = dict.status.capitalized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
