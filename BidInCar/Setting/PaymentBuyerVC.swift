//
//  PaymentBuyerVC.swift
//  BidInCar
//
//  Created by Keyur on 20/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class PaymentBuyerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var auctionView: UIView!
    @IBOutlet weak var auctionTblView: UITableView!
    @IBOutlet weak var constraintHeightAuctionTbl: NSLayoutConstraint!
    
    @IBOutlet weak var depositeAmountLbl: UILabel!
    @IBOutlet var depositeView: UIView!
    @IBOutlet weak var depositeTxt: FloatingTextfiledView!
    
    var arrBidAuction = [BidAuctionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateDepositeAmount), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        auctionTblView.register(UINib.init(nibName: "CustomBidAuctionTVC", bundle: nil), forCellReuseIdentifier: "CustomBidAuctionTVC")
        
        depositeTxt.myTxt.keyboardType = .numberPad
        updateDepositeAmount()
        serviceCallToGetBidAuction()
    }
    
    @objc func updateDepositeAmount()
    {
        depositeAmountLbl.text = "Deposit Amount : AED " + AppModel.shared.currentUser.user_deposit
        depositeAmountLbl.attributedText = attributedStringWithColor(depositeAmountLbl.text!, ["Deposit Amount :"], color: LightGrayColor)
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBidAuction.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomBidAuctionTVC = tableView.dequeueReusableCell(withIdentifier: "CustomBidAuctionTVC") as! CustomBidAuctionTVC
        let dict = arrBidAuction[indexPath.row]
        cell.dateLbl.text = dict.bidon
        cell.auctionNameLbl.text = dict.auction_title
        cell.currentBidLbl.text = dict.auction_price
        cell.yourBidLbl.text = dict.bidprice
        cell.statusLbl.text = dict.auction_status
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:- Button click event
    @IBAction func clickToAddDeposite(_ sender: Any) {
        self.view.endEditing(true)
        depositeTxt.myTxt.text = ""
        displaySubViewtoParentView(self.view, subview: depositeView)
    }
    @IBAction func clickToCloseDepositeView(_ sender: Any) {
        depositeView.removeFromSuperview()
    }
    
    @IBAction func clickToDepositeNow(_ sender: Any) {
        self.view.endEditing(true)
        if depositeTxt.myTxt.text?.trimmed == "" {
            displayToast("Please enter deposite amount")
        }
        else if Int(depositeTxt.myTxt.text!) == nil || Int(depositeTxt.myTxt.text!) == 0 {
            displayToast("Please enter deposite amount")
        }
        else{
            depositeView.removeFromSuperview()
            
            var param = [String : Any]()
            param["userid"] = AppModel.shared.currentUser.userid
            param["deposite_amount"] = depositeTxt.myTxt.text
            let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
            vc.paymentType = PAYMENT.DEPOSITE
            vc.paymentParam = param
            vc.amount = Int(depositeTxt.myTxt.text!)!
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func serviceCallToGetBidAuction()
    {
        APIManager.shared.serviceCallToGetBidAuction(["userid":AppModel.shared.currentUser.userid!]) { (data) in
            self.arrBidAuction = [BidAuctionModel]()
            for temp in data {
                self.arrBidAuction.append(BidAuctionModel.init(dict: temp))
            }
            if self.arrBidAuction.count > 0 {
                self.auctionView.isHidden = false
                self.auctionTblView.reloadData()
                self.constraintHeightAuctionTbl.constant = CGFloat((130*self.arrBidAuction.count) + 42)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
