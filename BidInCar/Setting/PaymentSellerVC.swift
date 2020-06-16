//
//  PaymentSellerVC.swift
//  BidInCar
//
//  Created by Keyur on 19/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class PaymentSellerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var packageBtn: Button!
    @IBOutlet weak var auctionBtn: Button!
    @IBOutlet weak var featuredBtn: Button!
    @IBOutlet weak var packageView: UIView!
    @IBOutlet weak var auctionView: UIView!
    @IBOutlet weak var featuredView: UIView!
    @IBOutlet weak var packageTblView: UITableView!
    @IBOutlet weak var constraintHeightPackageTbl: NSLayoutConstraint!
    @IBOutlet weak var auctionTblView: UITableView!
    @IBOutlet weak var constraintHeightAuctionTbl: NSLayoutConstraint!
    @IBOutlet weak var featureTblView: UITableView!
    @IBOutlet weak var constraintHeightFeatureTbl: NSLayoutConstraint!
    
    var arrFeatureAuction = [FeatureAuctionModel]()
    var arrPackage = [PackageModel]()
    var packageCellheight : CGFloat = 190
    var featureCellheight : CGFloat = 130
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        packageTblView.register(UINib.init(nibName: "CustomPackageHistoryTVC", bundle: nil), forCellReuseIdentifier: "CustomPackageHistoryTVC")
        auctionTblView.register(UINib.init(nibName: "CustomPackageTVC", bundle: nil), forCellReuseIdentifier: "CustomPackageTVC")
        featureTblView.register(UINib.init(nibName: "CustomFeaturedAuctionTVC", bundle: nil), forCellReuseIdentifier: "CustomFeaturedAuctionTVC")
        
        packageTblView.backgroundColor = WhiteColor
        auctionTblView.backgroundColor = WhiteColor
        featureTblView.backgroundColor = WhiteColor
        
        resetAllData()
        clickToSelectOption(packageBtn)
        clickToSelectOption(auctionBtn)
        clickToSelectOption(featuredBtn)
        
        serviceCallToGetFeaturedAuction()
        serviceCallToGetPackageHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.arrFeatureAuction.count > 0 {
            self.featuredView.isHidden = false
            self.featureTblView.reloadData()
        }
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == featureTblView {
            return arrFeatureAuction.count
        }
        else if tableView == packageTblView {
            return arrPackage.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == featureTblView {
            return featureCellheight
        }
        else if tableView == packageTblView {
            return packageCellheight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == featureTblView {
            let cell : CustomFeaturedAuctionTVC = featureTblView.dequeueReusableCell(withIdentifier: "CustomFeaturedAuctionTVC") as! CustomFeaturedAuctionTVC
            let dict = arrFeatureAuction[indexPath.row]
            cell.dateLbl.text = dict.createdon
            cell.paymentMethodLbl.text = "Paypal"
            cell.amountLbl.text = "AED " + dict.deposite_amount
            cell.auctionnameLbl.text = dict.auction_title
            cell.statusLbl.text = dict.deposite_status.capitalized
            cell.contentView.backgroundColor = WhiteColor
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == packageTblView {
            let cell : CustomPackageHistoryTVC = packageTblView.dequeueReusableCell(withIdentifier: "CustomPackageHistoryTVC") as! CustomPackageHistoryTVC
            let dict = arrPackage[indexPath.row]
            cell.purchaseDatelbl.text = dict.package_boughton
            cell.packageNameLbl.text = dict.package_title
            cell.totalAuctionLbl.text = dict.auction_history.total_auction
            cell.auctionPostedLbl.text = dict.auction_history.auction_posted
            cell.remainingAuctionLbl.text = String(dict.remaining_auction)
            cell.expireLbl.text = dict.package_expireon
            cell.priceLbl.text = "AED " + dict.package_price
            cell.contentView.backgroundColor = WhiteColor
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell : CustomPackageTVC = tableView.dequeueReusableCell(withIdentifier: "CustomPackageTVC") as! CustomPackageTVC
            cell.contentView.backgroundColor = WhiteColor
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToSelectOption(_ sender: UIButton) {
        //resetAllData()
        sender.isSelected = !sender.isSelected
        if sender == packageBtn {
            if packageBtn.isSelected {
                packageView.isHidden = false
                packageTblView.reloadData()
                setpackageViewheight()
            }else{
                packageView.isHidden = true
                constraintHeightPackageTbl.constant = 0
            }
        }
        else if sender == auctionBtn {
            auctionView.isHidden = true
            constraintHeightAuctionTbl.constant = 0
        }
        else if sender == featuredBtn {
            if featuredBtn.isSelected {
                featuredView.isHidden = false
                featureTblView.reloadData()
                setFeatureViewheight()
            }else{
                featuredView.isHidden = true
                constraintHeightFeatureTbl.constant = 0
            }
        }
    }
    
    func setpackageViewheight()
    {
        constraintHeightPackageTbl.constant = CGFloat((Int(packageCellheight) * arrPackage.count) + 42)
    }
    
    func setFeatureViewheight()
    {
        constraintHeightFeatureTbl.constant = CGFloat((Int(featureCellheight) * arrFeatureAuction.count) + 52)
    }
    
    func resetAllData()
    {
        packageBtn.isSelected = false
        auctionBtn.isSelected = false
        featuredBtn.isSelected = false
        packageView.isHidden = true
        auctionView.isHidden = true
        featuredView.isHidden = true
        constraintHeightPackageTbl.constant = 0
        constraintHeightAuctionTbl.constant = 0
        constraintHeightFeatureTbl.constant = 0
    }
    
    func serviceCallToGetFeaturedAuction()
    {
        if !isUserLogin() {
            return
        }
        APIManager.shared.serviceCallToGetFeaturedAuction(["userid":AppModel.shared.currentUser.userid!]) { (data) in
            self.arrFeatureAuction = [FeatureAuctionModel]()
            for temp in data {
                self.arrFeatureAuction.append(FeatureAuctionModel.init(dict: temp))
            }
            if self.arrFeatureAuction.count > 0 {
                self.featuredView.isHidden = false
                self.featureTblView.reloadData()
                self.constraintHeightFeatureTbl.constant = CGFloat((120*self.arrFeatureAuction.count) + 72)
            }
            
        }
    }
    
    func serviceCallToGetPackageHistory()
    {
        if !isUserLogin() {
            return
        }
        APIManager.shared.serviceCallToGetPackageHistory(["userid":AppModel.shared.currentUser.userid!]) { (data) in
            savePackageHistory(data)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
            self.arrPackage = [PackageModel]()
            for temp in data {
                self.arrPackage.append(PackageModel.init(dict: temp))
            }
            if self.arrPackage.count > 0 {
                self.packageView.isHidden = false
                self.packageTblView.reloadData()
                self.setpackageViewheight()
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
