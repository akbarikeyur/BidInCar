//
//  MyAuctionVC.swift
//  BidInCar
//
//  Created by Keyur on 18/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class MyAuctionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activeBtn: Button!
    @IBOutlet weak var activeImg: ImageView!
    @IBOutlet weak var closedBtn: Button!
    @IBOutlet weak var closeImg: ImageView!
    @IBOutlet weak var wonBtn: Button!
    @IBOutlet weak var wonImg: ImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: Label!
    
    var arrActiveAuction : [AuctionModel] = [AuctionModel]()
    var arrCloseAuction : [AuctionModel] = [AuctionModel]()
    var arrWonAuction : [AuctionModel] = [AuctionModel]()
    var refreshControl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: nil)
        tblView.register(UINib.init(nibName: "CustomAuctionTVC", bundle: nil), forCellReuseIdentifier: "CustomAuctionTVC")
        refreshControl.tintColor = BlueColor
        refreshControl.addTarget(self, action: #selector(refreshAuctionList), for: .valueChanged)
        tblView.addSubview(refreshControl)
        
        clickToSelectTab(activeBtn)
        
    }
    
    @objc func updateAuctionData(_ noti : Notification)
    {
        if let auction : AuctionModel = noti.object as? AuctionModel {
            if activeBtn.isSelected {
                let index = arrActiveAuction.firstIndex { (temp) -> Bool in
                    temp.auctionid == auction.auctionid
                }
                if index != nil {
                    arrActiveAuction[index!] = auction
                }
            }
            else if closedBtn.isSelected {
                let index = arrCloseAuction.firstIndex { (temp) -> Bool in
                    temp.auctionid == auction.auctionid
                }
                if index != nil {
                    arrCloseAuction[index!] = auction
                }
            }
            else if wonBtn.isSelected {
                let index = arrWonAuction.firstIndex { (temp) -> Bool in
                    temp.auctionid == auction.auctionid
                }
                if index != nil {
                    arrWonAuction[index!] = auction
                }
            }
            tblView.reloadData()
        }
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
        else{
            serviceCallToGetAuction(3)
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
        wonBtn.isSelected = false
        activeImg.isHidden = true
        closeImg.isHidden = true
        wonImg.isHidden = true
        sender.isSelected = true
        noDataFoundLbl.isHidden = true
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
        else if sender == wonBtn {
            wonImg.isHidden = false
            if arrWonAuction.count == 0 {
                serviceCallToGetAuction(3)
            }else{
                tblView.reloadData()
            }
        }
        tblView.reloadData()
    }
    
    
    //MARK:- Tablewview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activeBtn.isSelected {
            return arrActiveAuction.count
        }
        else if closedBtn.isSelected {
            return arrCloseAuction.count
        }
        else if wonBtn.isSelected {
            return arrWonAuction.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomAuctionTVC = tblView.dequeueReusableCell(withIdentifier: "CustomAuctionTVC") as! CustomAuctionTVC
        cell.withdrawView.isHidden = true
        cell.winningPriceView.isHidden = true
        cell.payNowVew.isHidden = true
        cell.winnerView.isHidden = true
        cell.bidNowBtn.isHidden = true
        
        var dict = AuctionModel.init()
        if activeBtn.isSelected {
            dict = arrActiveAuction[indexPath.row]
            cell.bidLbl.textColor = BlueColor
//            cell.withdrawView.isHidden = false
//            cell.withdrawBtn.tag = indexPath.row
//            cell.withdrawBtn.addTarget(self, action: #selector(clickToWithdrawAuction(_:)), for: .touchUpInside)
        }
        else if closedBtn.isSelected {
            cell.bidLbl.textColor = BlueColor
            cell.winningPriceView.isHidden = false
            dict = arrCloseAuction[indexPath.row]
        }
        else if wonBtn.isSelected {
            cell.bidLbl.textColor = GreenColor
            cell.payNowVew.isHidden = false
            dict = arrWonAuction[indexPath.row]
            cell.payNowBtn.tag = indexPath.row
            cell.payNowBtn.addTarget(self, action: #selector(clickToPayNow(_:)), for: .touchUpInside)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        if activeBtn.isSelected {
            vc.auctionData = arrActiveAuction[indexPath.row]
        }else if closedBtn.isSelected {
            vc.auctionData = arrCloseAuction[indexPath.row]
        }else if wonBtn.isSelected {
            vc.auctionData = arrWonAuction[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc @IBAction func clickToSeeBid(_ sender: UIButton) {
        let vc : BookmarkDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookmarkDetailVC") as! BookmarkDetailVC
        if activeBtn.isSelected {
            vc.auction = arrActiveAuction[sender.tag]
        }else if closedBtn.isSelected {
            vc.auction = arrCloseAuction[sender.tag]
        }else if wonBtn.isSelected {
            vc.auction = arrWonAuction[sender.tag]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func clickToWithdrawAuction(_ sender: UIButton) {
        self.view.endEditing(true)
        showAlertWithOption("auction_withdraw_title", message: "auction_withdraw_message", btns: ["no_button", "yes_button"], completionConfirm: {
            if self.activeBtn.isSelected {
                let dict = self.arrActiveAuction[sender.tag]
                var param = [String : Any]()
                param["auctionid"] = dict.auctionid
                param["userid"] = AppModel.shared.currentUser.userid
                param["usertype"] = getUserType()
                APIManager.shared.serviceCallToWithdrawAuctionBid(param) {
                    displayToast("withdraw_successfull")
                    let index = self.arrActiveAuction.firstIndex { (temp) -> Bool in
                        temp.auctionid == dict.auctionid
                    }
                    if index != nil {
                        self.arrActiveAuction.remove(at: index!)
                        self.noDataFoundLbl.isHidden = (self.arrActiveAuction.count > 0)
                    }
                    self.tblView.reloadData()
                    dict.is_bid = 0
                    dict.your_bid = 0
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: dict)
                    AppDelegate().sharedDelegate().serviceCallToGetUserProfile()
                }
            }
        }) {
            
        }
    }
    
    @IBAction func clickToPayNow(_ sender: UIButton) {
        let vc : PaymentSummaryVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
        vc.auctionData = arrWonAuction[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
                param["auctionstatus"] = "win"
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
                    self.arrWonAuction = arrAuction
                    break
                default:
                    break
            }
            self.noDataFoundLbl.isHidden = (arrAuction.count > 0)
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
