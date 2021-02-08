//
//  PaymentBuyerVC.swift
//  BidInCar
//
//  Created by Keyur on 20/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class PaymentBuyerVC: UIViewController {
    
    @IBOutlet weak var depositBtn: Button!
    @IBOutlet weak var withdrawBtn: Button!
    @IBOutlet weak var bidsBtn: Button!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var withdrawView: UIView!
    @IBOutlet weak var auctionView: UIView!
    
    @IBOutlet weak var depositeTbl: UITableView!
    @IBOutlet weak var constraintHeightDepositeTbl: NSLayoutConstraint!
    @IBOutlet weak var withdrawTbl: UITableView!
    @IBOutlet weak var constraintHeightWithdrawTbl: NSLayoutConstraint!
    @IBOutlet weak var auctionTblView: UITableView!
    @IBOutlet weak var constraintHeightAuctionTbl: NSLayoutConstraint!
    
    @IBOutlet weak var depositeAmountLbl: UILabel!
    @IBOutlet var depositeView: UIView!
    @IBOutlet weak var depositeTxt: FloatingTextfiledView!
    
    @IBOutlet var withdrrawView: UIView!
    @IBOutlet weak var withdrawTxt: FloatingTextfiledView!
    
    @IBOutlet weak var totalDepositLbl: Label!
    @IBOutlet weak var totalWithdrawLbl: Label!
    
    var arrBidAuction = [BidAuctionModel]()
    var arrDeposite = [DepositeModel]()
    var arrWithdraw = [WithdrawModel]()
    var depositeCellheight = 30
    var withdrawCellheight = 30
    var auctionCellheight = 130
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateDepositeAmount), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        depositeTbl.register(UINib.init(nibName: "DepositHistoryTVC", bundle: nil), forCellReuseIdentifier: "DepositHistoryTVC")
        withdrawTbl.register(UINib.init(nibName: "WithdrawHistoryTVC", bundle: nil), forCellReuseIdentifier: "WithdrawHistoryTVC")
        auctionTblView.register(UINib.init(nibName: "CustomBidAuctionTVC", bundle: nil), forCellReuseIdentifier: "CustomBidAuctionTVC")
        
        resetAllData()
        clickToSelectOption(depositBtn)
        clickToSelectOption(withdrawBtn)
        clickToSelectOption(bidsBtn)
        
        depositeTxt.myTxt.keyboardType = .numberPad
        updateDepositeAmount()
        if isUserBuyer() {
            serviceCallToGetBidAuction()
            serviceCallToGetDepositeHistory()
            serviceCallToGetWithdrawHistory()
        }
    }
    
    @objc func updateDepositeAmount()
    {
        depositeAmountLbl.text = getTranslate("info_deposit_amount") + displayPriceWithCurrency(AppModel.shared.currentUser.user_deposit)
        depositeAmountLbl.attributedText = attributedStringWithColor(depositeAmountLbl.text!, [getTranslate("info_deposit_amount")], color: LightGrayColor)
    }
    
    //MARK:- Button click event
    @IBAction func clickToSelectOption(_ sender: UIButton) {
        //resetAllData()
        sender.isSelected = !sender.isSelected
        if sender == depositBtn {
            setDepositViewheight()
        }
        else if sender == withdrawBtn {
            setWithdrawViewheight()
        }
        else if sender == bidsBtn {
            setAuctionViewheight()
        }
    }
    
    func setDepositViewheight()
    {
        if depositBtn.isSelected {
            depositView.isHidden = false
            depositeTbl.reloadData()
            constraintHeightDepositeTbl.constant = CGFloat((Int(depositeCellheight) * arrDeposite.count) + 42)
            if arrDeposite.count > 0 {
                constraintHeightDepositeTbl.constant += 80
            }
        }else{
            depositView.isHidden = true
            constraintHeightDepositeTbl.constant = 0
        }
    }
    
    func setWithdrawViewheight()
    {
        if withdrawBtn.isSelected {
            withdrawView.isHidden = false
            withdrawTbl.reloadData()
            constraintHeightWithdrawTbl.constant = CGFloat((Int(withdrawCellheight) * arrWithdraw.count) + 42)
            if arrWithdraw.count > 0 {
                constraintHeightWithdrawTbl.constant += 80
            }
        }else{
            withdrawView.isHidden = true
            constraintHeightWithdrawTbl.constant = 0
        }
    }
    
    func setAuctionViewheight()
    {
        if bidsBtn.isSelected {
            auctionView.isHidden = false
            auctionTblView.reloadData()
            constraintHeightAuctionTbl.constant = CGFloat((Int(auctionCellheight) * arrBidAuction.count) + 55)
        }else{
            auctionView.isHidden = true
            constraintHeightAuctionTbl.constant = 0
        }
    }
    
    func resetAllData()
    {
        depositBtn.isSelected = false
        withdrawBtn.isSelected = false
        bidsBtn.isSelected = false
        depositView.isHidden = true
        withdrawView.isHidden = true
        auctionView.isHidden = true
        constraintHeightDepositeTbl.constant = 0
        constraintHeightAuctionTbl.constant = 0
        constraintHeightWithdrawTbl.constant = 0
    }
    
    @objc @IBAction func clickToViewAction(_ sender: UIButton) {
        let dict = arrBidAuction[sender.tag]
        let tempAuction = AuctionModel.init()
        tempAuction.auctionid = dict.auctionid
        let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        vc.auctionData = tempAuction
        vc.isFromPayment = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
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
            displayToast("enter_deposite")
        }
        else if Int(depositeTxt.myTxt.text!) == nil || Int(depositeTxt.myTxt.text!) == 0 {
            displayToast("enter_deposite")
        }
        else{
            depositeView.removeFromSuperview()
            
            var param = [String : Any]()
            param["userid"] = AppModel.shared.currentUser.userid
            param["deposite_amount"] = depositeTxt.myTxt.text
            let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
            vc.paymentType = PAYMENT.DEPOSITE
            vc.paymentParam = param
            vc.amount = Double(depositeTxt.myTxt.text!)!
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func clickToWithdraw(_ sender: Any) {
        withdrawTxt.myTxt.text = ""
        displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: withdrrawView)
    }
    
    @IBAction func clickToSubmitWithdraw(_ sender: Any) {
        self.view.endEditing(true)
        let limit = AppModel.shared.getDoubleValue(getBuyerTopData(), "remain_biding_limit")
        if withdrawTxt.myTxt.text?.trimmed == "" {
            displayToast("withdraw_amount")
        }
        else if (limit/5) < Double(withdrawTxt.myTxt.text!)! {
            displayToast("withdraw_remaining_bidding_limit")
        }
        else {
            var param = [String : Any]()
            param["userid"] = AppModel.shared.currentUser.userid
            param["amount"] = withdrawTxt.myTxt.text
            
            APIManager.shared.serviceCallToWithdrawAmount(param) {
                self.withdrrawView.removeFromSuperview()
                displayToast("withdrawl_request_sent")
                self.serviceCallToGetWithdrawHistory()
            }
        }
    }
    
    @IBAction func clickToCloseWithdraw(_ sender: Any) {
        withdrrawView.removeFromSuperview()
    }
    
    func serviceCallToGetBidAuction()
    {
        APIManager.shared.serviceCallToGetBidAuction(["userid":AppModel.shared.currentUser.userid!]) { (data) in
            self.arrBidAuction = [BidAuctionModel]()
            for temp in data {
                self.arrBidAuction.append(BidAuctionModel.init(dict: temp))
            }
            self.setAuctionViewheight()
        }
    }
    
    func serviceCallToGetDepositeHistory() {
        APIManager.shared.serviceCallToGetDepositeHistory(["userid":AppModel.shared.currentUser.userid!]) { (data) in
            self.arrDeposite = [DepositeModel]()
            for temp in data {
                self.arrDeposite.append(DepositeModel.init(dict: temp))
            }
            if self.arrDeposite.count > 0 {
                self.totalDepositLbl.isHidden = false
                var price : Float = 0
                for temp in self.arrDeposite {
                    price += Float(temp.deposite_amount) ?? 0
                }
                self.totalDepositLbl.text = getTranslate("total_deposit") + displayPriceWithCurrency(setFlotingPrice(Double(price)))
            }else{
                self.totalDepositLbl.isHidden = true
            }
            
            self.setDepositViewheight()
        }
    }

    func serviceCallToGetWithdrawHistory() {
        APIManager.shared.serviceCallToGetWithdrawHistory(["userid":AppModel.shared.currentUser.userid!]) { (data) in
            self.arrWithdraw = [WithdrawModel]()
            for temp in data {
                self.arrWithdraw.append(WithdrawModel.init(dict: temp))
            }
            if self.arrWithdraw.count > 0 {
                self.totalWithdrawLbl.isHidden = false
                var price : Float = 0
                for temp in self.arrWithdraw {
                    price += Float(temp.withdrawl_amount) ?? 0
                }
                self.totalWithdrawLbl.text = getTranslate("total_withdrawal") + displayPriceWithCurrency(setFlotingPrice(Double(price)))
            }else{
                self.totalWithdrawLbl.isHidden = true
            }
            
            self.setWithdrawViewheight()
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

//MARK:- Tableview Method
extension PaymentBuyerVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == depositeTbl {
            return arrDeposite.count
        }
        else if tableView == withdrawTbl {
            return arrWithdraw.count
        }
        else {
            return arrBidAuction.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == auctionTblView {
            return 130
        }
        else {
            if indexPath.row == 0 {
                return 70
            }
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == depositeTbl {
            let cell : DepositHistoryTVC = depositeTbl.dequeueReusableCell(withIdentifier: "DepositHistoryTVC") as! DepositHistoryTVC
            cell.topView.isHidden = (indexPath.row > 0)
            cell.setupDetails(arrDeposite[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == withdrawTbl {
            let cell : WithdrawHistoryTVC = withdrawTbl.dequeueReusableCell(withIdentifier: "WithdrawHistoryTVC") as! WithdrawHistoryTVC
            cell.topView.isHidden = (indexPath.row > 0)
            cell.setupDetails(arrWithdraw[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell : CustomBidAuctionTVC = tableView.dequeueReusableCell(withIdentifier: "CustomBidAuctionTVC") as! CustomBidAuctionTVC
            let dict = arrBidAuction[indexPath.row]
            cell.dateLbl.text = dict.bidon
            cell.auctionNameLbl.text = dict.auction_title
            cell.currentBidLbl.text = dict.auction_price
            cell.yourBidLbl.text = dict.bidprice
            cell.statusLbl.text = dict.auction_status
            cell.viewBtn.tag = indexPath.row
            cell.viewBtn.addTarget(self, action: #selector(clickToViewAction(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
}
