//
//  BookmarkVC.swift
//  BidInCar
//
//  Created by Keyur on 17/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class BookmarkVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: Label!
    
    var arrAuctionData : [AuctionModel] = [AuctionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblView.register(UINib.init(nibName: "CustomBookmarkTVC", bundle: nil), forCellReuseIdentifier: "CustomBookmarkTVC")
        noDataFoundLbl.isHidden = true
        serviceCallToGetMyBookmark()
    }
    

    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    //MARK:- Tablewview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAuctionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomBookmarkTVC = tblView.dequeueReusableCell(withIdentifier: "CustomBookmarkTVC") as! CustomBookmarkTVC
        
        let dict = arrAuctionData[indexPath.row]
        for temp in dict.pictures {
            if temp.type == "auction" {
                setButtonBackgroundImage(cell.profilePicBtn, temp.path)
                break
            }
        }
        cell.titleLbl.text = dict.auction_title
        cell.addressLbl.text = dict.auction_address + ", " + dict.country_name
        cell.currentBidLbl.text = "Current Bid " + displayPriceWithCurrency(dict.active_auction_price)
        cell.bidLbl.text = "Bid #\n" + String(dict.auction_bidscount)
        cell.lotLbl.text = "Lot #\n" + dict.auctionid
        cell.bookmarkBtn.tag = indexPath.row
        cell.bookmarkBtn.addTarget(self, action: #selector(clickToBookmark(_:)), for: .touchUpInside)
        cell.reminderBtn.tag = indexPath.row
        cell.reminderBtn.addTarget(self, action: #selector(clickToReminder(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : BookmarkDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookmarkDetailVC") as! BookmarkDetailVC
        vc.auction = arrAuctionData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToReminder(_ sender: UIButton) {
        let vc : BookmarkDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookmarkDetailVC") as! BookmarkDetailVC
        vc.auction = arrAuctionData[sender.tag]
        vc.isForReminder = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToBookmark(_ sender: UIButton) {
        let dict = arrAuctionData[sender.tag]
        serviceCallToRemoveBookmark(dict.auctionid, dict.bookmarkid)
    }
    
    //MARK:- Service called
    func serviceCallToGetMyBookmark()
    {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bookmark_list_login_msg")
            return
        }
        var param = [String : Any]()
        param["userid"] = AppModel.shared.currentUser.userid
        param["usertype"] = getUserType()
        print(param)
        APIManager.shared.serviceCallToGetMyBookmark(param) { (data) in
            self.arrAuctionData = [AuctionModel]()
            for temp in data {
                self.arrAuctionData.append(AuctionModel.init(dict: temp))
            }
            self.tblView.reloadData()
            if self.arrAuctionData.count == 0 {
                self.noDataFoundLbl.isHidden = false
            }else{
                self.noDataFoundLbl.isHidden = true
            }
        }
    }
    
    func serviceCallToRemoveBookmark(_ auctionid : String, _ bookmarkid : String)
    {
        var param = [String : Any]()
        param["bookmarkid"] = bookmarkid
        APIManager.shared.serviceCallToRemoveBookmark(param) { (data) in
            displayToast("remove_bookmark")
            let index = self.arrAuctionData.firstIndex { (temp) -> Bool in
                temp.auctionid == auctionid
            }
            if index != nil {
                self.arrAuctionData.remove(at: index!)
                self.tblView.reloadData()
                if self.arrAuctionData.count == 0 {
                    self.noDataFoundLbl.isHidden = false
                }else{
                    self.noDataFoundLbl.isHidden = true
                }
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
