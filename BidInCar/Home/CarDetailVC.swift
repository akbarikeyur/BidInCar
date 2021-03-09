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
    @IBOutlet weak var auctionDescLbl: Label!
    @IBOutlet weak var seeMoreBtn: UIButton!
    @IBOutlet weak var auctionTermsLbl: Label!
    @IBOutlet weak var lotLbl: Label!
    @IBOutlet weak var depositLbl: Label!
    @IBOutlet weak var yourBidView: UIView!
    @IBOutlet weak var yourBidLbl: Label!
    
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var constraintHeightPictureView: NSLayoutConstraint!//250
    
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageNumberLbl: Label!
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
    @IBOutlet weak var termsConditionLbl: Label!
    
    var auctionData : AuctionModel = AuctionModel.init()
    var auctionDetailData : [[String : Any]] = [[String : Any]]()
    var arrFeatureData : [AuctionModel] = [AuctionModel]()
    var autoCheckData = PictureModel.init()
    var isFirstTimeIncrese = true
    var isFromPayment = false
    var isFromNotification = false
    var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageCV.register(UINib.init(nibName: "CustomImageCVC", bundle: nil), forCellWithReuseIdentifier: "CustomImageCVC")
        carCV.register(UINib.init(nibName: "CustomCarCVC", bundle: nil), forCellWithReuseIdentifier: "CustomCarCVC")
        tblView.register(UINib.init(nibName: "CustomCarDetailTVC", bundle: nil), forCellReuseIdentifier: "CustomCarDetailTVC")
        
        termsConditionLbl.attributedText = getAttributeStringWithColor(termsConditionLbl.text!, [termsConditionLbl.text!], color: UIColor.blue, font: termsConditionLbl.font, isUnderLine: true)
        depositLbl.attributedText = getAttributeStringWithColor(depositLbl.text!, [getTranslate("deposit_title")], color: BlueColor, font: depositLbl.font, isUnderLine: true)
        
        setTextFieldPlaceholderColor(myBidTxt, LightGrayColor)
        depositeTxt.myTxt.keyboardType = .numberPad
        myMapView.showsUserLocation = true
        seeMoreBtn.isHidden = true
        if !isFromPayment && !isFromNotification {
            setAuctionData()
        }
        updateBidView()
        serviceCallToGetAuctionDetail()
    }
    
    func setAuctionData()
    {
        if auctionData.auction_status != "active" {
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
            auctionData.active_auction_price = auctionData.auction_price
            auctionPriceLbl.text = displayPriceWithCurrency(auctionData.auction_price)
        }else{
            auctionPriceLbl.text = displayPriceWithCurrency(auctionData.active_auction_price)
        }
        minAuctionPriceLbl.text = "(" + getTranslate("min_bid_increment") + displayPriceWithCurrency(auctionData.auction_bidprice) + ")"
        bookmarkBtn.isSelected = (auctionData.bookmark == "yes")
        updateRemainingTime()
        endTimeLbl.text = getDateStringFromDateWithLocalTimezone(date: getDateFromDateString(strDate: auctionData.auction_end, format: "yyyy-MM-dd")!, format: "dd MMM, yyyy")
        auctionStatusBtn.setTitle(auctionData.auction_status.capitalized, for: .normal)
        reportView.isHidden = false
        if auctionData.autocheckupload.path != "" {
            autoCheckData = auctionData.autocheckupload
        }
        if auctionData.pictures.count == 0 {
            pictureView.isHidden = true
            constraintHeightPictureView.constant = 0
        }else{
            pictureView.isHidden = false
            constraintHeightPictureView.constant = 250
        }
        imageNumberLbl.text = String(currentImageIndex+1) + "/" + String(auctionData.pictures.count)
        imageCV.reloadData()
        auctionDescLbl.text = auctionData.auction_desc.html2String
        if auctionDescLbl.getHeight() > 65 {
            seeMoreBtn.isHidden = false
            auctionDescLbl.numberOfLines = 3
        }else{
            seeMoreBtn.isHidden = true
            auctionDescLbl.numberOfLines = 0
        }
        lotLbl.text = getTranslate("lot_title") + String(auctionData.auctionid)
        auctionDetailData = [[String : Any]]()
        
        if auctionData.country_name != "" {
            auctionDetailData.append(["title" : getTranslate("auction_country_of_made"), "value" : auctionData.country_name!])
        }
        if auctionData.category_name != "" {
            auctionDetailData.append(["title" : getTranslate("auction_brand"), "value" : auctionData.category_name!])
        }
        if auctionData.catchild_name != "" {
            auctionDetailData.append(["title" : getTranslate("auction_model"), "value" : auctionData.catchild_name!])
        }
        if auctionData.year != "" {
            auctionDetailData.append(["title" : getTranslate("auction_age"), "value" : auctionData.year!])
        }
        if auctionData.auction_body_condition != "" {
            auctionDetailData.append(["title" : getTranslate("auction_condition"), "value" : auctionData.auction_body_condition!])
        }
        if auctionData.body_condition != "" {
            auctionDetailData.append(["title" : getTranslate("auction_body_condition"), "value" : auctionData.body_condition!])
        }
        if auctionData.mechanical != "" {
            auctionDetailData.append(["title" : getTranslate("auction_mechanical_condition"), "value" : auctionData.mechanical!])
        }
        if auctionData.auction_millage != "" {
            auctionDetailData.append(["title" : getTranslate("auction_mileage"), "value" : (auctionData.auction_millage! + " K.M.")])
        }
        if auctionData.auction_bodytype != "" {
            auctionDetailData.append(["title" : getTranslate("auction_body_type"), "value" : auctionData.auction_bodytype!])
        }
        if auctionData.auction_vin != "" {
            auctionDetailData.append(["title" : getTranslate("auction_vin"), "value" : auctionData.auction_vin!])
        }
        if auctionData.auction_motorno != "" {
            auctionDetailData.append(["title" : getTranslate("auction_motor_no"), "value" : auctionData.auction_motorno!])
        }
        if auctionData.auction_extcolour != "" {
            auctionDetailData.append(["title" : getTranslate("auction_exterior_colour"), "value" : auctionData.auction_extcolour!])
        }
        if auctionData.auction_transmission != "" {
            auctionDetailData.append(["title" : getTranslate("auction_transmission"), "value" : auctionData.auction_transmission!])
        }
        if auctionData.auction_fueltype != "" {
            auctionDetailData.append(["title" : getTranslate("auction_fuel"), "value" : auctionData.auction_fueltype!])
        }
        if auctionData.interior_color != "" {
            auctionDetailData.append(["title" : getTranslate("auction_interior_colour"), "value" : auctionData.interior_color!])
        }
        if auctionData.no_of_cylinder != "" {
            auctionDetailData.append(["title" : getTranslate("auction_no_of_cylinder"), "value" : auctionData.no_of_cylinder!])
        }
        if auctionData.doors != "" {
            auctionDetailData.append(["title" : getTranslate("auction_doors"), "value" : auctionData.doors!])
        }
        if auctionData.auction_horse_power != "" {
            auctionDetailData.append(["title" : getTranslate("auction_horsepower"), "value" : auctionData.auction_horse_power!])
        }
        if auctionData.categorytype == "2" {
            if auctionData.wheels != "" {
                auctionDetailData.append(["title" : getTranslate("auction_wheels"), "value" : auctionData.wheels!])
            }
            if auctionData.drive_system != "" {
                auctionDetailData.append(["title" : getTranslate("auction_drive_system"), "value" : auctionData.drive_system!])
            }
        }
        
        if auctionData.engine_size != "" {
            auctionDetailData.append(["title" : getTranslate("auction_engine_size"), "value" : auctionData.engine_size!])
        }
        
        if auctionData.boat_length != "" {
            auctionDetailData.append(["title" : getTranslate("auction_boat_length"), "value" : auctionData.boat_length!])
        }
        if auctionData.auction_age != "" {
            auctionDetailData.append(["title" : getTranslate("auction_boat_age"), "value" : auctionData.auction_age!])
        }
        
        if auctionData.warranty != "" {
            if auctionData.categorytype == "1" || auctionData.categorytype == "4" {
                auctionDetailData.append(["title" : getTranslate("auction_car_warranty"), "value" : auctionData.warranty!])
            }
            else if auctionData.categorytype == "3" {
                auctionDetailData.append(["title" : getTranslate("auction_boat_warranty"), "value" : auctionData.warranty!])
            }
        }
        
        tblView.reloadData()
        
        auctionTermsLbl.text = ""// auctionData.auction_terms.html2String
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(self.auctionData.auction_lat)!, longitude: Double(self.auctionData.auction_long)!)
        self.myMapView.addAnnotation(annotation)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.myMapView.setRegion(region, animated: true)
        
        carCV.reloadData()
        if arrFeatureData.count == 0 {
            constraintHeightCarCV.constant = 0
        }else{
            constraintHeightCarCV.constant = 150
        }
    }
    
    func updateBidView() {
        if isUserBuyer() && isUserLogin() {
            yourBidView.isHidden = false
            var arrData = [BidModel]()
            for temp in auctionData.bidlist {
                if temp.userid == AppModel.shared.currentUser.userid {
                    arrData.append(temp)
                }
            }
            if arrData.count > 1
            {
                arrData.sort {
                    let elapsed0 = Int($0.bidprice)
                    let elapsed1 = Int($1.bidprice)
                    return elapsed0! > elapsed1!
                }
            }
            if arrData.count > 0 {
                yourBidLbl.text = getTranslate("your_bid") + String(arrData[0].bidprice)
            }
            else{
                yourBidLbl.text = getTranslate("your_bid") + String("0")
            }
        }else{
            yourBidView.isHidden = true
        }
    }
    
    func updateRemainingTime()
    {
        let strEndDate = auctionData.auction_end + " " + auctionData.auction_end_time
        if let newDate = getDateFromDateStringWithLocalTimezone(strDate: strEndDate, format: "yyyy-MM-dd HH:mm:ss") {
            let time : String = getRemaingTimeInDayHourMinuteSecond(newDate)
            if time != ""{
                remainingTimeLbl.text = time
                delay(1.0) {
                    self.updateRemainingTime()
                }
            }
            else{
                remainingTimeLbl.text = getTranslate("expired_time")
            }
        }
        else{
            remainingTimeLbl.text = getRemainingTime(strEndDate)
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSeeMoreLess(_ sender: UIButton) {
        seeMoreBtn.isSelected = !seeMoreBtn.isSelected
        if seeMoreBtn.isSelected {
            auctionDescLbl.numberOfLines = 0
        }else{
            auctionDescLbl.numberOfLines = 3
        }
    }
    
    @IBAction func clickToTermsConditions(_ sender: Any) {
        self.view.endEditing(true)
        screenType = 1
        let vc : PrivacyPolicyVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.isBackDisplay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToBookmark(_ sender: UIButton) {
        self.view.endEditing(true)
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bookmark_login_msg")
            return
        }
        bookmarkBtn.isSelected = !bookmarkBtn.isSelected
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
        if !isUserBuyer() {
            showAlert("error_title", message: "not_buyer_account") {
                
            }
            return
        }
        if myBidTxt.text?.trimmed == "" {
            displayToast("enter_bid_price")
        }
        else{
            let price : Int = Int(myBidTxt!.text!) ?? 0
            
            if Int(auctionData.active_auction_price)! > price {
                displayToast("lower_bid_current_bid")
//                showAlert("", message: "Your bid is lower than current bid") {
//
//                }
            }
            else if (Int(auctionData.active_auction_price)! + Int(auctionData.auction_bidprice)!) > price {
                displayToast("lower_bid")
            }
            else if Int(AppModel.shared.currentUser.biding_limit) == 0 {
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
            vc.amount = Double(depositeTxt.myTxt.text!)!
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
        }else{
            showAlert("", message: "no_inspection_report") {
                
            }
        }
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
            price += 100
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
                price -= 100
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
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCV {
            let cell : CustomImageCVC = imageCV.dequeueReusableCell(withReuseIdentifier: "CustomImageCVC", for: indexPath) as! CustomImageCVC
            cell.transperentImgView.isHidden = true
            setImageViewImage(cell.imgView, auctionData.pictures[indexPath.row].path, "")
            return cell
        }else{
            let cell : CustomCarCVC = carCV.dequeueReusableCell(withReuseIdentifier: "CustomCarCVC", for: indexPath) as! CustomCarCVC
            let dict = arrFeatureData[indexPath.row]
            if dict.pictures.count > 0 {
                setImageViewImage(cell.imgView, dict.pictures[0].path, IMAGE.AUCTION_PLACEHOLDER)
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
            var arrImg = [String]()
            for temp in auctionData.pictures {
                arrImg.append(temp.path)
            }
            displayFullScreenImage(arrImg, indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageCV {
            let visibleRect = CGRect(origin: self.imageCV.contentOffset, size: self.imageCV.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.imageCV.indexPathForItem(at: visiblePoint) {
                self.currentImageIndex = visibleIndexPath.row
                self.imageNumberLbl.text = String(self.currentImageIndex+1) + "/" + String(auctionData.pictures.count)
            }
        }
    }
    
    @IBAction func clickToChangeImage(_ sender: UIButton) {
        if sender.tag == 1 {
            //next
            if (auctionData.pictures.count-1) > currentImageIndex {
                imageCV.scrollToItem(at: IndexPath(row: currentImageIndex+1, section: 0), at: .right, animated: true)
            }
        }
        else{
            //previous
            if currentImageIndex != 0 {
                imageCV.scrollToItem(at: IndexPath(row: currentImageIndex-1, section: 0), at: .right, animated: true)
            }
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
        APIManager.shared.serviceCallToGetAuctionDetail(auctionData.auctionid, (isFromPayment || isFromNotification)) { (data) in
            
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
            
            if let temp = data["autocheckupload"] as? [String : Any] {
                self.auctionData.autocheckupload = PictureModel.init(dict: temp)
                self.reportView.isHidden = false
                if self.auctionData.autocheckupload.path != "" {
                    self.autoCheckData = self.auctionData.autocheckupload
                }
            }
            self.updateBidView()
            var arrBid = [Int]()
            for temp in self.auctionData.bidlist {
                arrBid.append(Int(temp.bidprice)!)
            }
            if arrBid.count > 0 {
                self.auctionData.active_auction_price = String(arrBid.max()!)
            }
            if self.auctionData.active_auction_price == "" {
                self.auctionData.active_auction_price = self.auctionData.auction_price
                self.auctionPriceLbl.text = displayPriceWithCurrency(self.auctionData.auction_price)
            }else{
                self.auctionPriceLbl.text = displayPriceWithCurrency(self.auctionData.active_auction_price)
            }
            
            if self.auctionData.bidlist.count > 0 {
                self.auctionData.auction_bidscount = String(self.auctionData.bidlist.count)
            }
            
            if self.isFromPayment || self.isFromNotification {
                self.setAuctionData()
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: self.auctionData)
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
        printData(param)
        APIManager.shared.serviceCallToAddAuctionBid(param) { (dict) in
            if let status = dict["status"] as? String, status == "success" {
                self.auctionData.your_bid = Int(self.myBidTxt.text!) ?? 0
                self.auctionData.is_bid = 1
                self.myBidTxt.text = ""
                self.serviceCallToGetAuctionDetail()
                delay(5.0) {
                    AppDelegate().sharedDelegate().serviceCallToGetUserProfile()
                }
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
