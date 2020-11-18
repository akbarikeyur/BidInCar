//
//  MyAuctionSellerVC.swift
//  BidInCar
//
//  Created by Keyur on 18/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class MyAuctionSellerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activeBtn: Button!
    @IBOutlet weak var activeImg: ImageView!
    @IBOutlet weak var closedBtn: Button!
    @IBOutlet weak var closeImg: ImageView!
    @IBOutlet weak var draftBtn: Button!
    @IBOutlet weak var draftImg: ImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var cancelAuctionPopupView: UIView!
    
    @IBOutlet var featureContainerView: UIView!
    @IBOutlet weak var featuredTitleLbl: Label!
    @IBOutlet weak var featuredPriceLbl: Label!
    
    @IBOutlet weak var noDataFoundLbl: Label!
    
    var arrActiveAuction : [AuctionModel] = [AuctionModel]()
    var arrCloseAuction : [AuctionModel] = [AuctionModel]()
    var arrDraftAuction : [AuctionModel] = [AuctionModel]()
    var selectedAuction = AuctionModel.init()
    var refreshControl = UIRefreshControl.init()
    
    var packagePrice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.AUCTION_FEATURED_DATA), object: nil)
        
        refreshControl.tintColor = BlueColor
        refreshControl.addTarget(self, action: #selector(refreshAuctionList), for: .valueChanged)
        tblView.addSubview(refreshControl)
        setUIDesigning()
    }
    
    func setUIDesigning()
    {
        tblView.register(UINib.init(nibName: "CustomAuctionTVC", bundle: nil), forCellReuseIdentifier: "CustomAuctionTVC")
        tblView.register(UINib.init(nibName: "CustomDraftAuctionTVC", bundle: nil), forCellReuseIdentifier: "CustomDraftAuctionTVC")
        
        clickToSelectTab(activeBtn)
        setupPrice()
    }
    
    @objc func refreshAuctionList()
    {
        refreshControl.endRefreshing()
        if activeBtn.isSelected {
            serviceCallToGetAuction(1)
        }
        else if closedBtn.isSelected {
            serviceCallToGetAuction(2)
        }
        else if draftBtn.isSelected {
            serviceCallToGetAuction(3)
        }
    }
    
    @objc func updateAuctionData(_ noti : Notification)
    {
        if let dict : [String : Any] = noti.object as? [String : Any] {
            if let auctionid = dict["auctionid"] as? String {
                let index = arrActiveAuction.firstIndex { (temp) -> Bool in
                    temp.auctionid == auctionid
                }
                if index != nil {
                    arrActiveAuction[index!].auction_featured = "yes"
                    tblView.reloadData()
                }
            }
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    @IBAction func clickToNotification(_ sender: Any) {
        let vc : NotificationVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSelectTab(_ sender: Button) {
        activeBtn.isSelected = false
        closedBtn.isSelected = false
        draftBtn.isSelected = false
        activeImg.isHidden = true
        closeImg.isHidden = true
        draftImg.isHidden = true
        sender.isSelected = true
        self.noDataFoundLbl.isHidden = true
        noDataFoundLbl.text = "You have no any Auction yet"
        if sender == activeBtn {
            activeImg.isHidden = false
            if arrActiveAuction.count == 0 {
                serviceCallToGetAuction(1)
            }else{
                tblView.reloadData()
            }
        }
        else if sender == closedBtn {
            closeImg.isHidden = false
            if arrCloseAuction.count == 0 {
                serviceCallToGetAuction(2)
            }else{
                tblView.reloadData()
            }
        }
        else if sender == draftBtn {
            noDataFoundLbl.text = "No Auction in Draft"
            draftImg.isHidden = false
            if arrDraftAuction.count == 0 {
                serviceCallToGetAuction(3)
            }else{
                tblView.reloadData()
            }
        }
    }
    
    //MARK:- Tablewview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activeBtn.isSelected {
            return arrActiveAuction.count
        }
        else if closedBtn.isSelected {
            return arrCloseAuction.count
        }
        return arrDraftAuction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if draftBtn.isSelected {
            let cell : CustomDraftAuctionTVC = tblView.dequeueReusableCell(withIdentifier: "CustomDraftAuctionTVC") as! CustomDraftAuctionTVC
            let dict = arrDraftAuction[indexPath.row]
            for temp in dict.pictures {
               if temp.type == "auction" {
                   setButtonImage(cell.profilePicBtn, temp.path)
                   break
               }
            }
            cell.nameLbl.text = dict.auction_title
            cell.addressLbl.text = dict.auction_address
            cell.priceLbl.text = "Price " + displayPriceWithCurrency(dict.active_auction_price)
            cell.lotLbl.text = "Lot #\n" + dict.auctionid
            cell.contentView.backgroundColor = WhiteColor
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell : CustomAuctionTVC = tblView.dequeueReusableCell(withIdentifier: "CustomAuctionTVC") as! CustomAuctionTVC
            cell.withdrawView.isHidden = true
            cell.winningPriceView.isHidden = true
            cell.payNowVew.isHidden = true
            cell.winnerView.isHidden = true
            cell.makeFeatureBtn.isHidden = true
            cell.bidNowBtn.isHidden = true
            cell.leftActionView.isHidden = false
            var dict = AuctionModel.init()
            if activeBtn.isSelected {
                dict = arrActiveAuction[indexPath.row]
                cell.bidLbl.textColor = BlueColor
                
                if isUserLogin() && (dict.userid == AppModel.shared.currentUser.userid) &&  dict.auction_featured == "no" {
                    cell.makeFeatureBtn.isHidden = false
                    cell.makeFeatureBtn.isUserInteractionEnabled = true
                    cell.makeFeatureBtn.setTitle("Make Featured", for: .normal)
                    cell.makeFeatureBtn.tag = indexPath.row
                    cell.makeFeatureBtn.addTarget(self, action: #selector(clickToMakeFeatured(_:)), for: .touchUpInside)
                }else{
//                    cell.schedulaerbtn.isHidden = false
                    if dict.auction_featured == "yes" {
                        cell.makeFeatureBtn.isHidden = false
                        cell.makeFeatureBtn.isUserInteractionEnabled = false
                        cell.makeFeatureBtn.setTitle("Featured", for: .normal)
                    }
                }
                
            }
            else if closedBtn.isSelected {
                dict = arrCloseAuction[indexPath.row]
                cell.bidLbl.textColor = BlueColor
                cell.winnerView.isHidden = false
                cell.winnerBtn.tag = indexPath.row
                cell.winnerBtn.addTarget(self, action: #selector(clickToOpenFeaturedView(_:)), for: .touchUpInside)
                cell.leftActionView.isHidden = true
                cell.winnerLbl.text = "Winner: " + dict.auction_winner.winner_name
                cell.winnerStatusLbl.text = "Winner: " + dict.auction_winner.status
                cell.winnerPriceLbl.text = "AED " + dict.auction_winner.winneing_price
            }
            for temp in dict.pictures {
               if temp.type == "auction" {
                   setButtonImage(cell.profilePicBtn, temp.path)
                   break
               }
            }
            cell.nameLbl.text = dict.auction_title
            cell.addressLbl.text = dict.auction_address
            cell.currentBidLbl.text = "Current Bid " + displayPriceWithCurrency(dict.active_auction_price)
            cell.lotLbl.text = "Lot #\n" + dict.auctionid
            cell.bidLbl.text = "Bid #\n" + dict.auction_bidscount
            cell.bidBtn.tag = indexPath.row
            cell.bidBtn.addTarget(self, action: #selector(clickToSeeBid(_:)), for: .touchUpInside)
            cell.bookmarkBtn.isSelected = (dict.bookmark == "yes")
            cell.bookmarkBtn.tag = indexPath.row
            cell.bookmarkBtn.addTarget(self, action: #selector(clickToBookmark(_:)), for: .touchUpInside)
            
            cell.contentView.backgroundColor = WhiteColor
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if draftBtn.isSelected {
            let vc : PostAuctionDetailVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostAuctionDetailVC") as! PostAuctionDetailVC
            vc.myAuction = arrDraftAuction[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
            vc.auctionData = ((activeBtn.isSelected) ? arrActiveAuction : arrCloseAuction)[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc @IBAction func clickToSeeBid(_ sender: UIButton) {
        let vc : BookmarkDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookmarkDetailVC") as! BookmarkDetailVC
        if activeBtn.isSelected {
            vc.auction = arrActiveAuction[sender.tag]
        }else{
            vc.auction = arrCloseAuction[sender.tag]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Button click event
    @IBAction func clickToOpenCancelAuctionView(_ sender: UIButton) {
        displaySubViewtoParentView(self.view, subview: cancelAuctionPopupView)
    }
    
    @IBAction func clickToCloseCancelAuctionView(_ sender: UIButton) {
        cancelAuctionPopupView.removeFromSuperview()
    }
    
    @IBAction func clickToProceedCancelAuctionView(_ sender: UIButton) {
        cancelAuctionPopupView.removeFromSuperview()
        if self.activeBtn.isSelected {
            let dict = self.arrActiveAuction[sender.tag]
            var param = [String : Any]()
            param["auctionid"] = dict.auctionid
            param["userid"] = AppModel.shared.currentUser.userid
            param["usertype"] = getUserType()
            APIManager.shared.serviceCallToWithdrawAuctionBid(param) {
                displayToast("Auction cancel successfully")
                let index = self.arrActiveAuction.firstIndex { (temp) -> Bool in
                    temp.auctionid == dict.auctionid
                }
                if index != nil {
                    self.arrActiveAuction.remove(at: index!)
                    self.noDataFoundLbl.isHidden = (self.arrActiveAuction.count > 0)
                }
                self.tblView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REMOVE_AUCTION_DATA), object: dict)
            }
        }
    }
    
    //Featured Auction
    @IBAction func clickToOpenFeaturedView(_ sender: UIButton) {
        displaySubViewtoParentView(self.view, subview: featureContainerView)
    }
    
    @IBAction func clickToCloseFeaturedView(_ sender: UIButton) {
        featureContainerView.removeFromSuperview()
    }
    
    @IBAction func clickToMakeFeatured(_ sender: UIButton) {
        if activeBtn.isSelected {
            selectedAuction = arrActiveAuction[sender.tag]
            displaySubViewtoParentView(self.view, subview: featureContainerView)
        }
    }
    
    @IBAction func clickToPayMakeFeatured(_ sender: Any) {
        featureContainerView.removeFromSuperview()
        let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
        vc.paymentType = PAYMENT.FEATURED
        vc.paymentParam = ["auctionid":selectedAuction.auctionid!]
        vc.amount = Int(packagePrice) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Bookmark
    @IBAction func clickToBookmark(_ sender: UIButton) {
        self.view.endEditing(true)
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bookmark_login_msg")
            return
        }
        sender.isSelected = !sender.isSelected
        
        var dict = AuctionModel.init()
        if activeBtn.isSelected {
            dict = arrActiveAuction[sender.tag]
        }else{
            dict = arrCloseAuction[sender.tag]
        }
        
        if sender.isSelected {
            var param = [String : Any]()
            param["auctionid"] = dict.auctionid
            param["userid"] = AppModel.shared.currentUser.userid
            APIManager.shared.serviceCallToAddBookmark(param) { (bookmarkId) in
                if self.activeBtn.isSelected {
                    self.arrActiveAuction[sender.tag].bookmark = "yes"
                    self.arrActiveAuction[sender.tag].bookmarkid = String(bookmarkId)
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.arrActiveAuction[sender.tag])
                }else{
                    self.arrCloseAuction[sender.tag].bookmark = "yes"
                    self.arrCloseAuction[sender.tag].bookmarkid = String(bookmarkId)
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.arrCloseAuction[sender.tag])
                }
            }
        }
        else{
            var param = [String : Any]()
            param["bookmarkid"] = dict.bookmarkid
            APIManager.shared.serviceCallToRemoveBookmark(param) { (data) in
                if self.activeBtn.isSelected {
                    self.arrActiveAuction[sender.tag].bookmark = "no"
                    self.arrActiveAuction[sender.tag].bookmarkid = ""
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.arrActiveAuction[sender.tag])
                }
                else{
                    self.arrCloseAuction[sender.tag].bookmark = "no"
                    self.arrCloseAuction[sender.tag].bookmarkid = ""
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.arrCloseAuction[sender.tag])
                }
            }
        }
    }
    
    //MARK:- Button click event
    func serviceCallToGetAuction(_ type : Int)
    {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("my_auction_list_login_msg")
            return
        }
        var param : [String : Any] = [String : Any]()
        switch type {
            case 1:
                param["auctionstatus"] = "active"
                break
            case 2:
                param["auctionstatus"] = "close"
                break
            case 3:
                param["auctionstatus"] = "draft"
                break
            default:
                break
        }
        param["userid"] = AppModel.shared.currentUser.userid
        param["pagename"] = "profile"
        param["usertype"] = getUserType()
        printData(param)
        APIManager.shared.serviceCallToGetMyAuction(param) { (data, package) in
            var arrAuction = [AuctionModel]()
            for temp in data {
                arrAuction.append(AuctionModel.init(dict: temp))
            }
            switch type {
                case 1:
                    self.arrActiveAuction = arrAuction
                    break
                case 2:
                    self.arrCloseAuction = arrAuction
                    break
                case 3:
                    self.arrDraftAuction = arrAuction
                    break
                default:
                    break
            }
            self.noDataFoundLbl.isHidden = (arrAuction.count > 0)
            self.tblView.reloadData()
            self.packagePrice = package.featured_price
            self.setupPrice()
        }
    }
    
    func setupPrice() {
        featuredTitleLbl.attributedText = attributedStringWithColor(featuredTitleLbl.text!, ["Do you wish to continue?"], color: YellowColor, font: UIFont.init(name: APP_REGULAR, size: 16))
        featuredPriceLbl.text = "Payment AED " + packagePrice
        featuredPriceLbl.attributedText = attributedStringWithColor(featuredPriceLbl.text!, [("AED " + packagePrice)], color: YellowColor, font: UIFont.init(name: APP_BOLD, size: 30))
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
