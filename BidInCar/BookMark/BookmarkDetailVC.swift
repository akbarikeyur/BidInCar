//
//  BookmarkDetailVC.swift
//  BidInCar
//
//  Created by Keyur on 17/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown
import EventKit

class CustomPriceCVC: UICollectionViewCell {
    @IBOutlet weak var numberlbl: Label!
    @IBOutlet weak var priceLbl: Label!
}

class BookmarkDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var profileImgBtn: Button!
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var startPriceLbl: Label!
    @IBOutlet weak var lotLbl: Label!
    @IBOutlet weak var bookmarkBtn: UIButton!
    @IBOutlet weak var currentPriceLbl: Label!
    @IBOutlet weak var bidLbl: Label!
    @IBOutlet weak var minIncrementLbl: Label!
    @IBOutlet weak var odometerLbl: Label!
    @IBOutlet weak var remainingTimeLbl: Label!
    @IBOutlet weak var endTimeLbl: Label!
    @IBOutlet weak var descLbl: Label!
    
    @IBOutlet weak var sortLbl: Label!
    @IBOutlet weak var bidView: UIView!
    @IBOutlet weak var bidCV: UICollectionView!
    @IBOutlet weak var constraintHeightBidCV : NSLayoutConstraint!
    @IBOutlet var reminderContainerView: UIView!
    @IBOutlet weak var hour24Btn: UIButton!
    @IBOutlet weak var hour48Btn: UIButton!
    @IBOutlet weak var hour72Btn: UIButton!
    @IBOutlet weak var auctionEndReminderBtn: UIButton!
    
    var auction = AuctionModel.init()
    var arrSortPriceData = ["Highest Price", "Lowest Price"]
    var arrBidData = [BidModel]()
    var isForReminder = false
    var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bidCV.register(UINib.init(nibName: "CustomBidPriceCVC", bundle: nil), forCellWithReuseIdentifier: "CustomBidPriceCVC")
        
        setUIDesigning()
    }
    
    func setUIDesigning()
    {
        self.sortLbl.text = arrSortPriceData[0]
        
        let index = auction.pictures.firstIndex { (temp) -> Bool in
            temp.type == "auto_check"
        }
        if index != nil {
            auction.pictures.remove(at: index!)
        }
        if auction.pictures.count > 0 {
            setImageViewImage(coverImgView, auction.pictures[0].path, IMAGE.AUCTION_PLACEHOLDER)
        }
        if auction.pictures.count > 1 {
            setButtonBackgroundImage(profileImgBtn, auction.pictures[1].path, IMAGE.AUCTION_PLACEHOLDER)
        }else if auction.pictures.count > 0 {
            setButtonBackgroundImage(profileImgBtn, auction.pictures[0].path, IMAGE.AUCTION_PLACEHOLDER)
        }
        
        titleLbl.text = auction.auction_title
        startPriceLbl.text = "Starting Price : $ " + auction.auction_price
        currentPriceLbl.text = displayPriceWithCurrency(auction.active_auction_price)
        bidLbl.text = String(auction.auction_bidscount)
        minIncrementLbl.text = displayPriceWithCurrency(auction.auction_bidprice)
        lotLbl.text = "Lot# " + auction.auctionid
        odometerLbl.text = auction.auction_millage + " K.M."
        if auction.auction_end != "" {
            remainingTimeLbl.text = "Time remaining " + getRemainingTime(auction.auction_end)
            endTimeLbl.text = "End Time " + getDateStringFromDate(date: getDateFromDateString(strDate: auction.auction_end, format: "YYYY-MM-dd")!, format: "dd MMM, YYYY")
        }
        else{
            remainingTimeLbl.text = ""
            endTimeLbl.text = ""
        }
        
        descLbl.text = auction.auction_desc.html2String
        bidView.isHidden = true
        constraintHeightBidCV.constant = 0
        serviceCallToGetAuctionBid()
        
        if isForReminder {
            isForReminder = false
            clickToReminder(self)
        }
    }
    
    // MARK: - Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToReminder(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: reminderContainerView)
    }
    
    @IBAction func clickToReminderTime(_ sender: UIButton) {
        hour24Btn.isSelected = false
        hour48Btn.isSelected = false
        hour72Btn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func clickToCloseReminderView(_ sender: Any) {
        reminderContainerView.removeFromSuperview()
    }
    
    @IBAction func clickToAuctionEndReminder(_ sender: UIButton) {
        auctionEndReminderBtn.isSelected = !auctionEndReminderBtn.isSelected
    }
    
    @IBAction func clickToSetReminder(_ sender: Any) {
        if !hour24Btn.isSelected && !hour48Btn.isSelected && !hour72Btn.isSelected {
            displayToast("Please select reminder time")
        }
        else{
            reminderContainerView.removeFromSuperview()
            setReminder()
        }
    }
    
    @IBAction func clickToSortPrice(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrSortPriceData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.sortLbl.text = item
            self.arrBidData = self.arrBidData.sorted(by: { (temp1 : BidModel, temp2 : BidModel) -> Bool in
                if index == 0 {
                    return temp1.bidprice > temp2.bidprice
                }else{
                    return temp1.bidprice < temp2.bidprice
                }
            })
            self.bidCV.reloadData()
        }
        dropDown.show()
    }
    
    // MARK: - Collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBidData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bidCV.frame.size.width/3, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomBidPriceCVC = bidCV.dequeueReusableCell(withReuseIdentifier: "CustomBidPriceCVC", for: indexPath) as! CustomBidPriceCVC
        cell.numberLbl.text = "#" + String(indexPath.row)
        cell.priceLbl.text = "AED " + arrBidData[indexPath.row].bidprice
        return cell
    }
    
    //MARK:- Service Call
    func serviceCallToGetAuctionDetail()
    {
        APIManager.shared.serviceCallToGetAuctionDetail(auction.auctionid, false) { (data) in
            if let tempData : [String : Any] = data["auction"] as? [String : Any] {
                if let your_bid : Int = tempData["your_bid"] as? Int {
                    self.auction.your_bid = your_bid
                }
            }
            
            if let tempData : [[String : Any]] = data["bidlist"] as? [[String : Any]] {
                for temp in tempData {
                    self.auction.bidlist.append(BidModel.init(dict: temp))
                }
            }
            self.sortLbl.text = self.arrSortPriceData[0]
            self.auction.bidlist = self.auction.bidlist.sorted(by: { (temp1 : BidModel, temp2 : BidModel) -> Bool in
                return temp1.bidprice < temp2.bidprice
            })
            self.setUIDesigning()
        }
    }
    
    func serviceCallToGetAuctionBid()
    {
        APIManager.shared.serviceCallToGetAuctionBid(auction.auctionid) { (data) in
            self.arrBidData = [BidModel]()
            for temp in data {
                let newBid = BidModel.init(dict: temp)
                self.arrBidData.append(newBid)
            }
            self.auction.bidlist = self.arrBidData
            if self.arrBidData.count > 0 {
                self.arrBidData = self.arrBidData.sorted { (temp1, temp2) -> Bool in
                    return temp1.bidprice > temp2.bidprice
                }
            }
            if self.auction.bidlist.count == 0 {
                self.bidView.isHidden = true
                self.constraintHeightBidCV.constant = 0
            }else{
                self.bidView.isHidden = false
                self.constraintHeightBidCV.constant = CGFloat((Int(self.arrBidData.count/3) + 1) * 50) + 45
            }
            self.bidCV.reloadData()
        }
    }
    
    
    //MARK:- Reminder
    func setReminder() {
        self.SOGetPermissionCalendarAccess()
    }
    
    
    func SOGetPermissionCalendarAccess() {
        switch EKEventStore.authorizationStatus(for: .event) {
            case .authorized:
                print("Authorised")
                addReminder()
                break
            case .denied:
                print("Access denied")
                break
            case .notDetermined:
                eventStore.requestAccess(to: .event, completion:
                    {(granted, error) in
                        if !granted {
                            print("Access to store not granted")
                            self.addReminder()
                        }
                })
                break
            default:
                print("Case Default")
        }
    }
    
    func addReminder()
    {
        if let tempDate = getDateFromDateString(strDate: auction.auction_end, format: "YYYY-MM-dd") {
            var reminderDate = tempDate
            if hour24Btn.isSelected {
                reminderDate = Calendar.current.date(byAdding: .hour, value: -24, to: tempDate)!
            }
            else if hour48Btn.isSelected {
                reminderDate = Calendar.current.date(byAdding: .hour, value: -48, to: tempDate)!
            }
            else if hour72Btn.isSelected {
                reminderDate = Calendar.current.date(byAdding: .hour, value: -72, to: tempDate)!
            }
            let event:EKEvent = EKEvent(eventStore: eventStore)
            event.title = auction.auction_title
            event.startDate = reminderDate
            event.endDate = reminderDate
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                setNewReminder(auction.auctionid, event.eventIdentifier)
                self.hour24Btn.isSelected = false
                self.hour48Btn.isSelected = false
                self.hour72Btn.isSelected = false
            } catch let e as NSError {
                print(e.description)
                return
            }
        }
    }
    
    func deleteReminder()
    {
        let tempData = getReminderData()
        if tempData[auction.auctionid] == nil {
            return
        }
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                self.deleteEvent(eventStore: self.eventStore, eventIdentifier: tempData[self.auction.auctionid] as! String)
            })
        } else {
            self.deleteEvent(eventStore: eventStore, eventIdentifier: tempData[auction.auctionid] as! String)
        }
    }
    
    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent, commit: true)
                try eventStore.remove(eventToRemove!, span: .futureEvents, commit: true)
                print("Remove")
            } catch {
                print(error.localizedDescription)
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
