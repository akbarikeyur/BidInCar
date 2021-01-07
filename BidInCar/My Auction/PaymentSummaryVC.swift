//
//  PaymentSummaryVC.swift
//  BidInCar
//
//  Created by Keyur on 23/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

let additional_charge : Int = 136

class PaymentSummaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var nameLbl: Label!
    @IBOutlet weak var winnerLbl: Label!
    @IBOutlet weak var lotLbl: Label!
    @IBOutlet weak var remainingTimeLbl: Label!
    @IBOutlet weak var bidCountLbl: Label!
    @IBOutlet weak var odometerLbl: Label!
    @IBOutlet weak var closeDateLbl: Label!
    @IBOutlet weak var auctionDescLbl: Label!
    
    @IBOutlet weak var currentPriceLbl: Label!
    @IBOutlet weak var totalPriceLbl: Label!
    @IBOutlet weak var addressTblView: UITableView!
    @IBOutlet weak var constraintHeightAddressTblView: NSLayoutConstraint!
    @IBOutlet weak var billingTblView: UITableView!
    @IBOutlet weak var constraintHeightBillingTblView: NSLayoutConstraint!
    @IBOutlet weak var faqTblView: UITableView!
    @IBOutlet weak var constraintHeightFAQTblview: NSLayoutConstraint!
    
    @IBOutlet var sellerView: UIView!
    @IBOutlet weak var sellerTblView: UITableView!
    @IBOutlet weak var constraintHeightSellerTbl: NSLayoutConstraint!
    
    @IBOutlet var faqView: UIView!
    @IBOutlet weak var faqFullTblView: UITableView!
    
    var auctionData = AuctionModel.init()
    var sellerData = UserModel.init()
    var arrFaqData = [FaqModel]()
    
    var arrAddressData = [[String : String]]()
    var arrBillingData = [[String : String]]()
    var arrSellerData = [[String : String]]()
    var shippingPrice = ""
    var selectedFaqIndex = 0
    var finalPrice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addressTblView.register(UINib.init(nibName: "CustomCarDetailTVC", bundle: nil), forCellReuseIdentifier: "CustomCarDetailTVC")
        billingTblView.register(UINib.init(nibName: "CustomCarDetailTVC", bundle: nil), forCellReuseIdentifier: "CustomCarDetailTVC")
        faqTblView.register(UINib.init(nibName: "CustomFaqTVC", bundle: nil), forCellReuseIdentifier: "CustomFaqTVC")
        sellerTblView.register(UINib.init(nibName: "CustomCarDetailTVC", bundle: nil), forCellReuseIdentifier: "CustomCarDetailTVC")
        faqFullTblView.register(UINib.init(nibName: "CustomFaqTVC", bundle: nil), forCellReuseIdentifier: "CustomFaqTVC")
        
        billingTblView.backgroundColor = LightPurpleColor
        
        currentPriceLbl.attributedText = attributedStringWithColor(currentPriceLbl.text!, ["Current Price"], color: BlueColor)
        totalPriceLbl.text = "Total AED 0"
        totalPriceLbl.attributedText = attributedStringWithColor(totalPriceLbl.text!, ["Total AED"], color: DarkGrayColor, font: UIFont.init(name: APP_MEDIUM, size: 14))
        
        getSellerDetail()
        setupAuctionData()
        serviceCallToGetFaqList()
        serviceCallToGetAuctionPayment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addressTblView.reloadData()
        billingTblView.reloadData()
        updateFaqTableviewHeight()
    }
    
    func setupAuctionData()
    {
        for temp in auctionData.pictures {
           if temp.type == "auction" {
               setImageViewImage(carImgView, temp.path, IMAGE.AUCTION_PLACEHOLDER)
               break
           }
        }
        nameLbl.text = auctionData.auction_title
        winnerLbl.text = "Winner: " + auctionData.auction_winner.winner_name
        lotLbl.text = "Lot #\n" + auctionData.auctionid
        currentPriceLbl.text = "Current Price AED " + auctionData.auction_winner.winneing_price
        updateRemainingTime()
        bidCountLbl.text = "Bids #" + auctionData.auction_bidscount
        odometerLbl.text = "Odometer " + auctionData.auction_millage + "K.M"
        if let endDate : Date = getDateFromDateString(strDate: auctionData.auction_end, format: "yyyy-MM-dd") {
            closeDateLbl.text = "Closing Date " + getDateStringFromDate(date: endDate, format: "dd MMM yyyy")
        }else{
            closeDateLbl.text = "Closing Date " + auctionData.auction_end
        }
        auctionDescLbl.text = auctionData.auction_desc
        setupBuyerDetail()
    }
    
    func updateRemainingTime()
    {
        if let endDate : Date = getDateFromDateString(strDate: auctionData.auction_end, format: "yyyy-MM-dd") {
            if let time : String = getRemaingTimeInDayHourMinuteSecond(endDate) as? String, time != ""{
                remainingTimeLbl.text = "Time Remaining\n" + time
                delay(1.0) {
                    self.updateRemainingTime()
                }
            }
            else{
                remainingTimeLbl.text = "Expired"
            }
        }
        else{
            remainingTimeLbl.text = "Time Remaining\n" + getRemainingTime(auctionData.auction_end)
        }
    }
    
    func setupBuyerDetail()
    {
        arrAddressData = [[String : String]]()
        var dict = [String:String]()
        dict["title"] = "Street"
        dict["value"] = AppModel.shared.currentUser.user_streetaddress
        arrAddressData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Country"
        dict["value"] = AppModel.shared.currentUser.country_name
        arrAddressData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "City"
        dict["value"] = AppModel.shared.currentUser.city_name
        arrAddressData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Phone"
        dict["value"] = AppModel.shared.currentUser.user_phonenumber
        arrAddressData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Email"
        dict["value"] = AppModel.shared.currentUser.user_email
        arrAddressData.append(dict)
        
        addressTblView.reloadData()
        constraintHeightAddressTblView.constant = CGFloat((arrAddressData.count * 40))
    }
    
    func setupSellerDetail()
    {
        arrSellerData = [[String : String]]()
        var dict = [String:String]()
        dict["title"] = "Name"
        dict["value"] = sellerData.user_name
        arrSellerData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Email"
        dict["value"] = sellerData.user_email
        arrSellerData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Phone"
        dict["value"] = sellerData.user_phonenumber
        arrSellerData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Street"
        dict["value"] = sellerData.user_streetaddress
        arrSellerData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Country"
        dict["value"] = sellerData.country_name
        arrSellerData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "City"
        dict["value"] = sellerData.city_name
        arrSellerData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Total payment"
        dict["value"] = totalPriceLbl.text?.replacingOccurrences(of: "Total ", with: "")
        arrSellerData.append(dict)
        
        sellerTblView.reloadData()
        constraintHeightSellerTbl.constant = CGFloat((arrSellerData.count * 40))
    }
    
    func setupBillingInfo(_ auctionDict : [String : Any])
    {
        arrBillingData = [[String : String]]()
        finalPrice = 0.0
        var dict = [String:String]()
        dict["title"] = "Auction price"
        if let auction = auctionDict["auction"] as? [String : Any] {
            let active_auction_price = AppModel.shared.getStringValue(auction, "active_auction_price")
            dict["value"] = "AED " + active_auction_price
            finalPrice = Double(active_auction_price)!
        }
        arrBillingData.append(dict)
    
        dict = [String:String]()
        dict["title"] = "Deposit amount"
        let deposite = AppModel.shared.getStringValue(auctionDict, "deposite")
        dict["value"] = "AED " + deposite
        finalPrice -= Double(deposite)!
        arrBillingData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Service Fee"
        dict["value"] = "AED 450"
        finalPrice += 450
        arrBillingData.append(dict)
        
        dict = [String:String]()
        dict["title"] = "Platform Charges"
        let servicefee = AppModel.shared.getStringValue(auctionDict, "servicefee")
        dict["value"] = "AED " + servicefee
        finalPrice += Double(servicefee)!
        arrBillingData.append(dict)
        
//        let deposite = Int(AppModel.shared.currentUser.user_deposit)! - Int(fees) + additional_charge
//        dict = [String:String]()
//        dict["title"] = "Amount to be refund"
//        dict["value"] = "AED " + String(deposite)
//        arrBillingData.append(dict)
        
        billingTblView.reloadData()
        constraintHeightBillingTblView.constant = CGFloat((arrBillingData.count * 40))
        totalPriceLbl.text = "Total AED " + setFlotingPrice(finalPrice)
        totalPriceLbl.attributedText = attributedStringWithColor(totalPriceLbl.text!, ["Total AED"], color: DarkGrayColor, font: UIFont.init(name: APP_MEDIUM, size: 14))
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToConfirm(_ sender: Any) {
//        displaySubViewtoParentView(self.view, subview: sellerView)
//        setupSellerDetail()
        let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
        vc.paymentType = PAYMENT.AUCTION
        vc.paymentParam = ["auctionid":auctionData.auctionid!]
        vc.amount = finalPrice
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToCloseSellerView(_ sender: Any) {
        sellerView.removeFromSuperview()
    }
    
    @IBAction func clickToCloseFaqView(_ sender: Any) {
        faqView.removeFromSuperview()
    }
    
    //MARK:- Tablewview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addressTblView {
            return arrAddressData.count
        }
        else if tableView == billingTblView {
            return arrBillingData.count
        }
        else if tableView == sellerTblView {
            return arrSellerData.count
        }
        return arrFaqData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addressTblView {
            let cell : CustomCarDetailTVC = addressTblView.dequeueReusableCell(withIdentifier: "CustomCarDetailTVC") as! CustomCarDetailTVC
            let dict = arrAddressData[indexPath.row]
            cell.titleLbl.text = dict["title"]
            cell.titleLbl.textColor = DarkBlueColor
            cell.valueLbl.text = dict["value"]
            cell.backgroundColor = ClearColor
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == billingTblView {
            let cell : CustomCarDetailTVC = billingTblView.dequeueReusableCell(withIdentifier: "CustomCarDetailTVC") as! CustomCarDetailTVC
            let dict = arrBillingData[indexPath.row]
            cell.titleLbl.text = dict["title"]
            cell.valueLbl.text = dict["value"]
            cell.valueLbl.textAlignment = .right
            if indexPath.row == 0 {
                cell.titleLbl.textColor = YellowColor
            }else{
                cell.titleLbl.textColor = WhiteColor
            }
            cell.valueLbl.textColor = WhiteColor
            cell.titleLbl.font = UIFont.init(name: APP_BOLD, size: 14)
            cell.valueLbl.font = UIFont.init(name: APP_BOLD, size: 14)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = LightPurpleColor
            return cell
        }
        else if tableView == sellerTblView {
            let cell : CustomCarDetailTVC = addressTblView.dequeueReusableCell(withIdentifier: "CustomCarDetailTVC") as! CustomCarDetailTVC
            let dict = arrSellerData[indexPath.row]
            cell.titleLbl.text = dict["title"]
            cell.titleLbl.textColor = WhiteColor
            cell.valueLbl.text = dict["value"]
            cell.valueLbl.textColor = WhiteColor
            cell.titleLbl.font = UIFont.init(name: APP_BOLD, size: 14)
            cell.contentView.backgroundColor = ClearColor
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == faqTblView {
            let cell : CustomFaqTVC = faqTblView.dequeueReusableCell(withIdentifier: "CustomFaqTVC") as! CustomFaqTVC
            let dict = arrFaqData[indexPath.row]
            cell.titleLbl.text = dict.faq_title
            cell.answerLbl.text = dict.faq_desc
            cell.answerView.isHidden = true
            cell.answerLbl.text = ""
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell : CustomFaqTVC = faqFullTblView.dequeueReusableCell(withIdentifier: "CustomFaqTVC") as! CustomFaqTVC
            let dict = arrFaqData[indexPath.row]
            cell.titleLbl.text = dict.faq_title
            cell.answerView.isHidden = false
            cell.answerLbl.text = dict.faq_desc
            if selectedFaqIndex == indexPath.row {
                cell.answerView.isHidden = false
                cell.answerLbl.text = dict.faq_desc
            }
            else{
                cell.answerView.isHidden = true
                cell.answerLbl.text = ""
            }
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == faqTblView {
            displaySubViewtoParentView(self.view, subview: faqView)
        }
        else if tableView == faqFullTblView {
            if selectedFaqIndex == indexPath.row {
                selectedFaqIndex = -1
            }else{
                selectedFaqIndex = indexPath.row
            }
            faqFullTblView.reloadData()
        }
    }
    
    func getSellerDetail()
    {
        APIManager.shared.serviceCallToGetUserProfile(auctionData.userid) { (dict) in
            self.sellerData = UserModel.init(dict: dict)
        }
    }
    
    func serviceCallToGetFaqList()
    {
        APIManager.shared.serviceCallToGetFaqList { (data) in
            self.arrFaqData = [FaqModel]()
            for temp in data {
                self.arrFaqData.append(FaqModel.init(dict: temp))
            }
            self.updateFaqTableviewHeight()
        }
    }
    
    func updateFaqTableviewHeight() {
        constraintHeightFAQTblview.constant = CGFloat.greatestFiniteMagnitude
        faqTblView.reloadData()
        faqTblView.layoutIfNeeded()
        constraintHeightFAQTblview.constant = faqTblView.contentSize.height
    }
    
    func serviceCallToGetAuctionPayment() {
        var param = [String : Any]()
        param["userid"] = AppModel.shared.currentUser.userid
        param["auctionid"] = auctionData.auctionid
        printData(param)
        APIManager.shared.serviceCallToGetAuctionPayment(param) { (dict) in
            self.setupBillingInfo(dict)
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
