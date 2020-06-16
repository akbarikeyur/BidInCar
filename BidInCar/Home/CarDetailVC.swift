//
//  CarDetailVC.swift
//  BidInCar
//
//  Created by Keyur on 16/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import MapKit

class CarDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var editBtn: Button!
    @IBOutlet weak var auctionPriceLbl: Label!
    @IBOutlet weak var minAuctionPriceLbl: Label!
    @IBOutlet weak var bookmarkBtn: Button!
    @IBOutlet weak var remainingTimeLbl: Label!
    @IBOutlet weak var endTimeLbl: Label!
    @IBOutlet weak var auctionStatusBtn: Button!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var auctionDescLbl: Label!
    @IBOutlet weak var auctionTermsLbl: Label!
    @IBOutlet weak var lotLbl: Label!
    
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var constraintHeightPictureView: NSLayoutConstraint!//250
    
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var constraintHeightTblView : NSLayoutConstraint!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var carCV: UICollectionView!
    @IBOutlet weak var constraintHeightCarCV: NSLayoutConstraint!//150
    
    @IBOutlet weak var bidView: View!
    @IBOutlet weak var myBidTxt: TextField!
    
    @IBOutlet var bidNowView: UIView!
    @IBOutlet weak var bidNowDescLbl: Label!
    @IBOutlet var depositeView: UIView!
    @IBOutlet weak var depositeTxt: FloatingTextfiledView!
    
    var auctionData : AuctionModel = AuctionModel.init()
    var auctionDetailData : [[String : Any]] = [[String : Any]]()
    var arrFeatureData : [AuctionModel] = [AuctionModel]()
    var selectedImgIndex = 0
    var autoCheckData = PictureModel.init()
    var isFirstTimeIncrese = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageCV.register(UINib.init(nibName: "CustomImageCVC", bundle: nil), forCellWithReuseIdentifier: "CustomImageCVC")
        carCV.register(UINib.init(nibName: "CustomCarCVC", bundle: nil), forCellWithReuseIdentifier: "CustomCarCVC")
        tblView.register(UINib.init(nibName: "CustomCarDetailTVC", bundle: nil), forCellReuseIdentifier: "CustomCarDetailTVC")
        
        setTextFieldPlaceholderColor(myBidTxt, LightGrayColor)
        depositeTxt.myTxt.keyboardType = .numberPad
        myMapView.showsUserLocation = true
        setAuctionData()
        serviceCallToGetAuctionDetail()
    }
    
    func setAuctionData()
    {
        if !isUserLogin() {
            bidView.isHidden = false
        }
        else if (!isUserLogin() || !isUserBuyer() || (auctionData.userid == AppModel.shared.currentUser.userid) || auctionData.auction_status != "active") {
            bidView.isHidden = true
        }else{
            bidView.isHidden = false
        }
        if auctionData.userid == AppModel.shared.currentUser.userid && auctionData.auction_status == "active" {
            editBtn.isHidden = false
        }else{
            editBtn.isHidden = true
        }
        titleLbl.text = auctionData.auction_title
        if auctionData.active_auction_price == "" {
            auctionPriceLbl.text = displayPriceWithCurrency(auctionData.auction_price)
        }else{
            auctionPriceLbl.text = displayPriceWithCurrency(auctionData.active_auction_price)
        }
        
        minAuctionPriceLbl.text = "(MIN INCREASE " + displayPriceWithCurrency(auctionData.auction_bidprice) + ")"
        bookmarkBtn.isSelected = (auctionData.bookmark == "yes")
        updateRemainingTime()
        endTimeLbl.text = getDateStringFromDate(date: getDateFromDateString(strDate: auctionData.auction_end, format: "YYYY-MM-dd")!, format: "dd MMM, YYYY")
        auctionStatusBtn.setTitle(auctionData.auction_status.capitalized, for: .normal)
        let index = auctionData.pictures.firstIndex { (temp) -> Bool in
            temp.type == "auto_check"
        }
        if index != nil {
            autoCheckData = auctionData.pictures[index!]
            auctionData.pictures.remove(at: index!)
            reportView.isHidden = false
        }else{
            reportView.isHidden = true
        }
        if auctionData.pictures.count > 0 {
            setImageViewImage(mainImgView, auctionData.pictures[0].path, "")
        }else{
            mainImgView.image = nil
        }
        if auctionData.pictures.count == 0 {
            pictureView.isHidden = true
            constraintHeightPictureView.constant = 0
        }else{
            pictureView.isHidden = false
            constraintHeightPictureView.constant = 250
        }
        
        imageCV.reloadData()
        auctionDescLbl.text = auctionData.auction_desc
        lotLbl.text = "Lot # " + String(auctionData.auctionid)
        auctionDetailData = [[String : Any]]()
        if auctionData.categorytype == "1" {
            auctionDetailData.append(["title" : "Body type", "value" : auctionData.auction_bodytype!])
            auctionDetailData.append(["title" : "Country of made", "value" : auctionData.country_name!])
            auctionDetailData.append(["title" : "VIN", "value" : auctionData.auction_vin!])
            auctionDetailData.append(["title" : "Motor No.", "value" : auctionData.auction_motorno!])
            auctionDetailData.append(["title" : "Exterior colour", "value" : auctionData.auction_extcolour!])
            auctionDetailData.append(["title" : "Mileage", "value" : (auctionData.auction_millage! + " K.M.")])
            auctionDetailData.append(["title" : "Transmission", "value" : auctionData.auction_transmission!])
            auctionDetailData.append(["title" : "Fuel", "value" : auctionData.auction_fueltype!])
        }
        else if auctionData.categorytype == "2" {
            auctionDetailData.append(["title" : "Country of made", "value" : auctionData.country_name!])
            auctionDetailData.append(["title" : "Mileage", "value" : (auctionData.auction_millage! + " K.M.")])
            auctionDetailData.append(["title" : "Mechanical", "value" : auctionData.mechanical!])
            auctionDetailData.append(["title" : "Wheels", "value" : auctionData.wheels!])
            auctionDetailData.append(["title" : "Drive System", "value" : auctionData.drive_system!])
            auctionDetailData.append(["title" : "Engine Size", "value" : auctionData.engine_size!])
            auctionDetailData.append(["title" : "Body Condition", "value" : auctionData.body_condition!])
        }
        else if auctionData.categorytype == "3" {
            auctionDetailData.append(["title" : "Country of made", "value" : auctionData.country_name!])
            auctionDetailData.append(["title" : "Mileage", "value" : (auctionData.auction_millage! + " K.M.")])
            auctionDetailData.append(["title" : "Mechanical", "value" : auctionData.mechanical!])
            auctionDetailData.append(["title" : "Boat length", "value" : auctionData.boat_length!])
            auctionDetailData.append(["title" : "Body Condition", "value" : auctionData.body_condition!])
        }
        else {
            auctionDetailData.append(["title" : "Country of made", "value" : auctionData.country_name!])
            auctionDetailData.append(["title" : "Mechanical", "value" : auctionData.mechanical!])
            auctionDetailData.append(["title" : "Body Condition", "value" : auctionData.body_condition!])
        }
        tblView.reloadData()
        
        auctionTermsLbl.text = ""// auctionData.auction_terms.html2String
        delay(1.0) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(self.auctionData.auction_lat)!, longitude: Double(self.auctionData.auction_long)!)
            self.myMapView.addAnnotation(annotation)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
            self.myMapView.setRegion(region, animated: true)
        }
        carCV.reloadData()
        if arrFeatureData.count == 0 {
            constraintHeightCarCV.constant = 0
        }else{
            constraintHeightCarCV.constant = 150
        }
    }
    
    func updateRemainingTime()
    {
        if let endDate : Date = getDateFromDateString(strDate: auctionData.auction_end, format: "yyyy-MM-dd") {
            if let time : String = getRemaingTimeInDayHourMinuteSecond(endDate), time != ""{
                remainingTimeLbl.text = time
                delay(1.0) {
                    self.updateRemainingTime()
                }
            }
            else{
                remainingTimeLbl.text = "Expired"
            }
        }
        else{
            remainingTimeLbl.text = getRemainingTime(auctionData.auction_end)
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToTermsConditions(_ sender: Any) {
        self.view.endEditing(true)
        openUrlInSafari(strUrl: TERMS_URL)
    }
    
    @IBAction func clickToBookmark(_ sender: UIButton) {
        self.view.endEditing(true)
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bookmark_login_msg")
            return
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            var param = [String : Any]()
            param["auctionid"] = auctionData.auctionid
            param["userid"] = AppModel.shared.currentUser.userid
            APIManager.shared.serviceCallToAddBookmark(param) { (bookmarkId) in
                self.auctionData.bookmark = "yes"
                self.auctionData.bookmarkid = String(bookmarkId)
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.auctionData)
            }
        }
        else{
            var param = [String : Any]()
            param["bookmarkid"] = auctionData.bookmarkid
            APIManager.shared.serviceCallToRemoveBookmark(param) { (data) in
                self.auctionData.bookmark = "no"
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.auctionData)
            }
        }
    }
    
    @IBAction func clickToBidNow(_ sender: Any) {
        self.view.endEditing(true)
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bid_login_msg")
            return
        }
        if myBidTxt.text?.trimmed == "" {
            displayToast("enter_bid_price")
        }
        else{
            let price : Int = Int(myBidTxt!.text!) ?? 0
            
            if Int(auctionData.auction_bidprice)! > price {
                showAlert("", message: "Your bid should be more than current price") {
                    
                }
            }
            else if Int(AppModel.shared.currentUser.user_deposit) == 0 {
                displaySubViewtoParentView(self.view, subview: bidNowView)
            }
            else{
                serviceCallToAddAuctionBid()
            }
        }
    }
    
    @IBAction func clickToCloseBidNowView(_ sender: Any) {
        bidNowView.removeFromSuperview()
    }
    
    @IBAction func clickToOpenDepositeView(_ sender: Any) {
        bidNowView.removeFromSuperview()
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
        else{
            depositeView.removeFromSuperview()
            
            var param = [String : Any]()
            param["userid"] = AppModel.shared.currentUser.userid
            param["deposite_amount"] = depositeTxt.myTxt.text
            let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
            vc.paymentType = PAYMENT.DEPOSITE
            vc.paymentParam = param
            vc.amount = Int(depositeTxt.myTxt.text!)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func clickToEditAuction(_ sender: Any) {
        let vc : PostCarAuctionVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostCarAuctionVC") as! PostCarAuctionVC
        vc.myAuction = auctionData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToExpandMap(_ sender: Any) {
        let vc : MapVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        vc.latitude = Double(self.auctionData.auction_lat)!
        vc.longitude = Double(self.auctionData.auction_long)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToDownloadReport(_ sender: Any) {
        if autoCheckData.apid != "" {
            openUrlInSafari(strUrl: autoCheckData.path)
        }
    }
    
    @IBAction func clickToMainImageView(_ sender: Any) {
        var arrImage = [String]()
        for temp in auctionData.pictures {
            arrImage.append(temp.path)
        }
        displayFullScreenImage(arrImage, selectedImgIndex)
    }
    
    @IBAction func clickToIncreseBid(_ sender: Any) {
        
        var price = 0
        if myBidTxt.text?.trimmed != "" {
            price = Int(myBidTxt.text!.trimmed)!
        }else{
            price = Int(auctionData.active_auction_price)!
        }
        if isFirstTimeIncrese {
            isFirstTimeIncrese = false
            price += Int(auctionData.auction_bidprice)!
        }
        else{
            price += 1
        }
        myBidTxt.text = String(price)
    }
    
    @IBAction func clickToDecreseBid(_ sender: Any) {
        if myBidTxt.text?.trimmed != "" {
            var price = 0
            if myBidTxt.text?.trimmed != "" {
                price = Int(myBidTxt.text!.trimmed)!
            }else{
                price = Int(auctionData.active_auction_price)!
            }
            if price > 0 {
                price -= 1
            }
            myBidTxt.text = String(price)
        }
    }
    
    //MARK:- Collectionview Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCV {
            return auctionData.pictures.count
        }
        return arrFeatureData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCV {
            return CGSize(width: 90, height: 70)
        }
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCV {
            let cell : CustomImageCVC = imageCV.dequeueReusableCell(withReuseIdentifier: "CustomImageCVC", for: indexPath) as! CustomImageCVC
            cell.transperentImgView.isHidden = (selectedImgIndex == indexPath.row)
            setImageViewImage(cell.imgView, auctionData.pictures[indexPath.row].path, "")
            return cell
        }else{
            let cell : CustomCarCVC = carCV.dequeueReusableCell(withReuseIdentifier: "CustomCarCVC", for: indexPath) as! CustomCarCVC
            let dict = arrFeatureData[indexPath.row]
            if dict.pictures.count > 0 {
                setImageViewImage(cell.imgView, dict.pictures[0].path, "temp1")
            }
            cell.titleLbl.text = dict.auction_title
            
            if (dict.bookmark == "yes") {
                cell.starBtn.isSelected = true
                cell.outerView.layer.borderColor = OrangeColor.cgColor
            }
            else{
                cell.starBtn.isSelected = false
                cell.outerView.layer.borderColor = LightGrayColor.cgColor
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCV {
            selectedImgIndex = indexPath.row
            setImageViewImage(mainImgView, auctionData.pictures[selectedImgIndex].path, "")
            imageCV.reloadData()
        }
    }
    
    //MARK:- Tablewview method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auctionDetailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCarDetailTVC = tblView.dequeueReusableCell(withIdentifier: "CustomCarDetailTVC") as! CustomCarDetailTVC
        cell.titleLbl.text = auctionDetailData[indexPath.row]["title"] as? String
        cell.valueLbl.text = auctionDetailData[indexPath.row]["value"] as? String
        constraintHeightTblView.constant = tblView.contentSize.height + 5
        cell.contentView.backgroundColor = WhiteColor
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:- Service called
    func serviceCallToGetAuctionDetail()
    {
        APIManager.shared.serviceCallToGetAuctionDetail(auctionData.auctionid) { (data) in
            if let tempData : [String : Any] = data["auction"] as? [String : Any] {
                self.auctionData = AuctionModel.init(dict: tempData)
            }
            
            if let tempData : [[String : Any]] = data["bidlist"] as? [[String : Any]] {
                for temp in tempData {
                    self.auctionData.bidlist.append(BidModel.init(dict: temp))
                }
            }
            
            if let tempData : [[String : Any]] = data["pictures"] as? [[String : Any]] {
                var arrPicture = [PictureModel]()
                for temp in tempData {
                    arrPicture.append(PictureModel.init(dict: temp))
                }
                self.auctionData.pictures = arrPicture
                self.imageCV.reloadData()
            }
            
            var arrBid = [Int]()
            for temp in self.auctionData.bidlist {
                arrBid.append(Int(temp.bidprice)!)
            }
            if arrBid.count > 0 {
                self.auctionData.active_auction_price = String(arrBid.max()!)
            }
            self.auctionPriceLbl.text = displayPriceWithCurrency(self.auctionData.active_auction_price)
        }
    }
    
    func serviceCallToAddAuctionBid()
    {
        var param : [String : Any] = [String : Any]()
        param["auctionid"] = auctionData.auctionid
        if isUserLogin() {
            param["userid"] = AppModel.shared.currentUser.userid
        }
        param["bidamount"] = myBidTxt.text
        print(param)
        APIManager.shared.serviceCallToAddAuctionBid(param) { (dict) in
            if let status = dict["status"] as? String, status == "success" {
                self.auctionData.your_bid = Int(self.myBidTxt.text!) ?? 0
                self.auctionData.is_bid = 1
                self.myBidTxt.text = ""
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.auctionData)
                self.serviceCallToGetAuctionDetail()
            }
            else if let message = dict["message"] as? String {
                self.bidNowDescLbl.text = message
                displaySubViewtoParentView(self.view, subview: self.bidNowView)
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
