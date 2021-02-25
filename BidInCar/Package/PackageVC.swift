//
//  PackageVC.swift
//  BidInCar
//
//  Created by Keyur on 18/11/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class PackageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var singleAuctionBtn: Button!
    @IBOutlet weak var packageBtn: Button!
    @IBOutlet weak var singleAuctionImg: ImageView!
    @IBOutlet weak var packageImg: ImageView!
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var descLbl: Label!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var headerView: UIView!
    
    
    var selectedSingle = PackageModel.init()
    var selectedPackage = PackageModel.init()
    
    var singlePackage = PackageDetailModel.init()
    var multiPackage = PackageDetailModel.init()
    
    var arrPurchasPackage = getPurchasePackageData()
    var isFromAuction : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        singleAuctionBtn.setTitleColor(DarkGrayColor, for: .normal)
        singleAuctionBtn.setTitleColor(BlackColor, for: .selected)
        packageBtn.setTitleColor(DarkGrayColor, for: .normal)
        packageBtn.setTitleColor(BlackColor, for: .selected)
        
        tblView.backgroundColor = WhiteColor
        
        tblView.register(UINib.init(nibName: "CustomSingleAuctionPackageTVC", bundle: nil), forCellReuseIdentifier: "CustomSingleAuctionPackageTVC")
        tblView.register(UINib.init(nibName: "CustomMultiAuctionPackageTVC", bundle: nil), forCellReuseIdentifier: "CustomMultiAuctionPackageTVC")
        clickToSelectTab(singleAuctionBtn)
    }
    
    //MARK: - Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        if isFromAuction {
            AppDelegate().sharedDelegate().navigateToDashBoard()
        }else {
            self.navigationController?.popViewController(animated: true)
        }        
    }
    
    @IBAction func clickToSelectTab(_ sender: Button) {
        if sender == singleAuctionBtn {
            singleAuctionBtn.isSelected = true
            packageBtn.isSelected = false
            singleAuctionImg.isHidden = false
            packageImg.isHidden = true
            titleLbl.text = getTranslate("single_package_title")
            descLbl.text = getTranslate("single_package_desc")
            if singlePackage.packages.count == 0 {
                serviceCallToGetPackage()
            }else{
                tblView.reloadData()
            }
        }
        else{
            singleAuctionBtn.isSelected = false
            packageBtn.isSelected = true
            singleAuctionImg.isHidden = true
            packageImg.isHidden = false
            titleLbl.text = getTranslate("upgrad_premier_title")
            descLbl.text = getTranslate("upgrad_premier_desc")
            if multiPackage.packages.count == 0 {
                serviceCallToGetPackage()
            }else{
                tblView.reloadData()
            }
        }
        tblView.reloadData()
    }
    
    @IBAction func clickToCheckout(_ sender: Any) {
        self.view.endEditing(true)
        if selectedSingle.packageid == "" && selectedPackage.packageid == "" {
            displayToast("select_package")
        }
        else{
            var amount = 0
            if singleAuctionBtn.isSelected {
                amount = Int(selectedSingle.package_price) ?? 0
                if selectedSingle.isFeatured {
                    amount += Int(singlePackage.featured_price.featured_price)!
                }
                if selectedSingle.isSocial {
                    amount += Int(singlePackage.social_media_promotion.featured_price)!
                }
            }else{
                amount = Int(selectedPackage.package_price) ?? 0
            }
            
            var param = [String : Any]()
            if singleAuctionBtn.isSelected {
                param["packageid"] = selectedSingle.packageid
                param["featured_plus_social"] = selectedSingle.isSocial ? "true" : "false"
                param["featured"] = selectedSingle.isFeatured ? "true" : "false"
            }else{
                param["packageid"] = selectedPackage.packageid
                param["featured_plus_social"] = selectedPackage.isSocial ? "true" : "false"
                param["featured"] = selectedPackage.isFeatured ? "true" : "false"
            }
            param["userid"] = AppModel.shared.currentUser.userid
            param["total_amount"] = amount
            printData(param)
            let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
            vc.paymentType = PAYMENT.PACKAGE
            vc.paymentParam = param
            vc.amount = Double(amount)
            vc.isFromAuction = isFromAuction
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Tableview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if singleAuctionBtn.isSelected {
            return singlePackage.packages.count
        }else{
            return multiPackage.packages.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if singleAuctionBtn.isSelected {
            let cell : CustomSingleAuctionPackageTVC = tblView.dequeueReusableCell(withIdentifier: "CustomSingleAuctionPackageTVC") as! CustomSingleAuctionPackageTVC
            cell.topSeperatorImg.isHidden = false
            cell.bottomSeperatorImg.isHidden = false
            if indexPath.row == 0 {
                cell.topSeperatorImg.isHidden = true
            }
            else if indexPath.row == (singlePackage.packages.count-1) {
                cell.bottomSeperatorImg.isHidden = true
            }
            cell.innerDotView.backgroundColor = colorFromHex(hex: "4EA2FF")
            cell.outerDotView.backgroundColor = colorFromHex(hex: "4EA2FF", alpha: 0.5)
            cell.contentView.backgroundColor = WhiteColor
            let dict = singlePackage.packages[indexPath.row]
            cell.selectBtn.isSelected = (selectedSingle.packageid == dict.packageid)
            cell.typeLbl.text = getTranslate("single_auction")
            cell.titleLbl.text = dict.package_title
            cell.totalAuctionLbl.text = dict.number_of_auction
            cell.validityLbl.text = dict.days + getTranslate("space_day")
            cell.bidderLbl.text = ""
            cell.amountLbl.text = displayPriceWithCurrency(dict.package_price)
            cell.featuredTitleLbl.text = getTranslate("featured_space") + displayPriceWithCurrency(singlePackage.featured_price.featured_price)
            cell.socialTitleLbl.text = getTranslate("featured_social") + displayPriceWithCurrency(singlePackage.social_media_promotion.featured_price)
            cell.featuredValueLbl.text = ""
            cell.socialValueLbl.text = ""
            if let tempDict : [String : Any] = convertToDictionary(text: dict.extras) {
                if let single_featured_desc : String = tempDict["single_featured_desc"] as? String {
                    cell.featuredValueLbl.text = single_featured_desc
                }
                if let single_social_desc : String = tempDict["single_social_desc"] as? String {
                    cell.socialValueLbl.text = single_social_desc
                }
            }
            var totalPrice : Int = Int(dict.package_price)!
            if dict.isFeatured {
                totalPrice += Int(singlePackage.featured_price.featured_price)!
            }
            if dict.isSocial {
                totalPrice += Int(singlePackage.social_media_promotion.featured_price)!
            }
            cell.totalLbl.text = getTranslate("total_space") + displayPriceWithCurrency(String(totalPrice))
            cell.socialBtn.isSelected = dict.isSocial
            cell.socialBtn.tag = indexPath.row
            cell.socialBtn.addTarget(self, action: #selector(clickToSocialBtn(_:)), for: .touchUpInside)
            cell.featureBtn.isSelected = dict.isFeatured
            cell.featureBtn.tag = indexPath.row
            cell.featureBtn.addTarget(self, action: #selector(clickToFeaturedBtn(_:)), for: .touchUpInside)
            cell.contentView.backgroundColor = WhiteColor
            cell.selectionStyle = .none
            return cell
        }else{
            let cell : CustomMultiAuctionPackageTVC = tblView.dequeueReusableCell(withIdentifier: "CustomMultiAuctionPackageTVC") as! CustomMultiAuctionPackageTVC
            cell.topSeperatorImg.isHidden = false
            cell.bottomSeperatorImg.isHidden = false
            if indexPath.row == 0 {
                cell.topSeperatorImg.isHidden = true
            }
            else if indexPath.row == (multiPackage.packages.count-1) {
                cell.bottomSeperatorImg.isHidden = true
            }
            let dict = multiPackage.packages[indexPath.row]
            cell.selectBtn.isSelected = (selectedPackage.packageid == dict.packageid)
            cell.typeLbl.text = dict.package_title
            cell.totalAuctionLbl.text = dict.number_of_auction
            cell.validityLbl.text = dict.days + getTranslate("space_day")
            cell.amountLbl.text = displayPriceWithCurrency(dict.package_price)
            cell.savingLbl.text = displayPriceWithCurrency(dict.package_savings) + "+"
            cell.descLbl.text = dict.package_decription
            cell.totalLbl.text = getTranslate("total_space") + displayPriceWithCurrency(dict.package_price)
            if let tempExtra : [String] = convertToArray(text: dict.extras) as? [String] {
                for temp in tempExtra {
                    cell.descLbl.text = cell.descLbl.text! + "\n - " + temp
                }
            }
            cell.contentView.backgroundColor = WhiteColor
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if singleAuctionBtn.isSelected {
            selectedSingle = singlePackage.packages[indexPath.row]
        }
        else {
            selectedPackage = multiPackage.packages[indexPath.row]
        }
        tblView.reloadData()
    }
    
    @objc func clickToSocialBtn(_ sender : UIButton)
    {
        if singleAuctionBtn.isSelected {
            singlePackage.packages[sender.tag].isSocial = !singlePackage.packages[sender.tag].isSocial
            selectedSingle = singlePackage.packages[sender.tag]
            tblView.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
        }
    }
    
    @objc func clickToFeaturedBtn(_ sender : UIButton)
    {
        if singleAuctionBtn.isSelected {
            singlePackage.packages[sender.tag].isFeatured = !singlePackage.packages[sender.tag].isFeatured
            selectedSingle = singlePackage.packages[sender.tag]
            tblView.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
        }
    }
    
    //MARK:- Service call
    func serviceCallToGetPackage()
    {
        var param = [String : Any]()
        if singleAuctionBtn.isSelected {
            param["type"] = "single"
        }else{
            param["type"] = "multiple"
        }
        APIManager.shared.serviceCallToGetPackage(param) { (data) in
            if self.singleAuctionBtn.isSelected {
                self.singlePackage = PackageDetailModel.init(dict: data)
            }else{
                self.multiPackage = PackageDetailModel.init(dict: data)
            }
            self.tblView.reloadData()
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
