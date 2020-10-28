//
//  HomeVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class HomeVC: UploadImageVC {

    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet var noDataLbl: UILabel!
    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var featureCV: UICollectionView!
    
    var arrFeatureAuctionData : [AuctionModel] = [AuctionModel]()
    var arrAuctionData : [AuctionModel] = [AuctionModel]()
    var arrSearchAuctionData : [AuctionModel] = [AuctionModel]()
    var selectedCategory = AuctionTypeModel.init(dict: [String : Any]())
    var refreshControl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFeatureAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.AUCTION_FEATURED_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.REMOVE_AUCTION_DATA), object: nil)
        
        featureCV.register(UINib.init(nibName: "CustomCarCVC", bundle: nil), forCellWithReuseIdentifier: "CustomCarCVC")
        categoryCV.register(UINib.init(nibName: "CustomAuctionCategoryCVC", bundle: nil), forCellWithReuseIdentifier: "CustomAuctionCategoryCVC")
        tblView.register(UINib.init(nibName: "CustomCarTVC", bundle: nil), forCellReuseIdentifier: "CustomCarTVC")
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        tblView.tableHeaderView = headerView
        tblView.reloadData()
        setTextFieldPlaceholderColor(searchTxt, LightGrayColor)
        
        refreshControl.tintColor = BlueColor
        refreshControl.addTarget(self, action: #selector(refreshAuctionList), for: .valueChanged)
        tblView.addSubview(refreshControl)
        
        if arrAuctionData.count == 0 {
            if AppModel.shared.AUCTION_DATA.count == 0 {
                if isUserLogin() {
                    APIManager.shared.serviceCallToGetUserProfile(AppModel.shared.currentUser.userid) { (dict) in
                        AppModel.shared.currentUser = UserModel.init(dict: dict)
                        setLoginUserData()
                        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
                    }
                }
                serviceCallToGetAuctionCategoryList()                
            }else{
                setupAuctionData()
            }
        }
    }
    
    @objc func updateAuctionData(_ noti : Notification)
    {
        if let auction : AuctionModel = noti.object as? AuctionModel {
            let index = self.arrAuctionData.firstIndex { (temp) -> Bool in
                temp.auctionid == auction.auctionid
            }
            if index != nil {
                self.arrAuctionData[index!] = auction
                let index2 = self.arrSearchAuctionData.firstIndex { (temp) -> Bool in
                    temp.auctionid == auction.auctionid
                }
                if index2 != nil {
                    self.arrSearchAuctionData[index2!] = auction
                }
            }
            tblView.reloadData()
            categoryCV.reloadData()
        }
    }
    
    @objc func updateFeatureAuctionData(_ noti : Notification)
    {
        if let dict : [String : Any] = noti.object as? [String : Any] {
            if let auctionid = dict["auctionid"] as? String {
                let index = arrAuctionData.firstIndex { (temp) -> Bool in
                    temp.auctionid == auctionid
                }
                if index != nil {
                    if let auction_featured = dict["auction_featured"] as? String {
                        arrAuctionData[index!].auction_featured = auction_featured
                        tblView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func removeAuctionData(_ noti : Notification)
    {
        if let auction : AuctionModel = noti.object as? AuctionModel {
            let index = self.arrAuctionData.firstIndex { (temp) -> Bool in
                temp.auctionid == auction.auctionid
            }
            if index != nil {
                self.arrAuctionData.remove(at: index!)
                let index2 = self.arrSearchAuctionData.firstIndex { (temp) -> Bool in
                    temp.auctionid == auction.auctionid
                }
                if index2 != nil {
                    self.arrSearchAuctionData.remove(at: index2!)
                }
            }
            tblView.reloadData()
            categoryCV.reloadData()
        }
    }
    
    @objc func refreshAuctionList()
    {
        refreshControl.endRefreshing()
        serviceCallToGetAuction()
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    @IBAction func clickToNotification(_ sender: Any) {
        let vc : NotificationVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToReload(_ sender: Any) {
        //serviceCallToGetAuction()
        AppDelegate().sharedDelegate().getPackageHistory()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField == searchTxt {
            arrSearchAuctionData = [AuctionModel]()
            arrSearchAuctionData = arrAuctionData.filter({ (result) -> Bool in
                let nameTxt: NSString = result.auction_title! as NSString
                return (nameTxt.range(of: textField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            tblView.reloadData()
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

//MARK:- Collectionview method
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == featureCV {
            return arrFeatureAuctionData.count
        }
        return AppModel.shared.AUCTION_TYPE.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == featureCV {
            return CGSize(width: 100, height: collectionView.frame.size.height)
        }
        else {
            let newLable : UILabel = UILabel.init()
            newLable.font = UIFont.init(name: APP_REGULAR, size: 14.0)
            newLable.text = AppModel.shared.AUCTION_TYPE[indexPath.row].name
            let width = newLable.intrinsicContentSize.width + 45
            return CGSize(width: width, height: collectionView.frame.size.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == featureCV {
            let cell : CustomCarCVC = featureCV.dequeueReusableCell(withReuseIdentifier: "CustomCarCVC", for: indexPath) as! CustomCarCVC
            cell.setupDetails(arrFeatureAuctionData[indexPath.row])
            return cell
        }
        else{
            let cell : CustomAuctionCategoryCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "CustomAuctionCategoryCVC", for: indexPath) as! CustomAuctionCategoryCVC
            let dict = AppModel.shared.AUCTION_TYPE[indexPath.row]
            setButtonImage(cell.catImgBtn, dict.img)
            cell.catLbl.text = dict.name
            if selectedCategory.id == dict.id {
                cell.catImgBtn.tintColor = DarkGrayColor
                cell.catLbl.textColor = DarkGrayColor
                cell.seperatorImg.isHidden = false
            }else{
                cell.catImgBtn.tintColor = LightGrayColor
                cell.catLbl.textColor = LightGrayColor
                cell.seperatorImg.isHidden = true
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == featureCV {
            let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
            vc.auctionData = arrFeatureAuctionData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            selectedCategory = AppModel.shared.AUCTION_TYPE[indexPath.row]
            categoryCV.reloadData()
            if let data = AppModel.shared.AUCTION_DATA[String(self.selectedCategory.id)], data.count > 0 {
                arrAuctionData = data
                tblView.reloadData()
                noDataLbl.isHidden = (arrAuctionData.count > 0)
                setupFeatureAuction()
            }
            else{
                serviceCallToGetAuction()
            }
        }
    }
}

//MARK:- Tablewview method
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTxt.text?.trimmed != "" {
            return arrSearchAuctionData.count
        }
        return arrAuctionData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCarTVC = tblView.dequeueReusableCell(withIdentifier: "CustomCarTVC") as! CustomCarTVC
        let dict = (searchTxt.text?.trimmed != "") ? arrSearchAuctionData[indexPath.row] : arrAuctionData[indexPath.row]
        for temp in dict.pictures {
            if temp.type == "auction" {
                setImageViewImage(cell.imgView, temp.path, IMAGE.AUCTION_PLACEHOLDER)
                break
            }
        }
        cell.featureView.isHidden = (dict.auction_featured != "yes")
        cell.titleLbl.text = dict.auction_title
        cell.timeLbl.text = getRemainingTime(dict.auction_end) + " left  " + getDateStringFromDate(date: getDateFromDateString(strDate: dict.auction_end, format: "YYYY-MM-dd")!, format: "dd MMM, YYYY")
        cell.minPriceLbl.text = "New minimum price: " + displayPriceWithCurrency(dict.auction_bidprice)
        cell.currentBidLbl.text = "Current Price " + displayPriceWithCurrency(dict.active_auction_price)
        cell.starBtn.isSelected = (dict.bookmark == "yes")
        if isUserLogin() && (dict.userid == AppModel.shared.currentUser.userid || dict.is_bid == 1 ) {
            cell.bidNowBtn.isHidden = true
        }
        else{
            cell.bidNowBtn.isHidden = false
        }
        cell.bidNowBtn.tag = indexPath.row
        cell.bidNowBtn.addTarget(self, action: #selector(clickToBidNow(_:)), for: .touchUpInside)
        cell.starBtn.tag = indexPath.row
        cell.starBtn.addTarget(self, action: #selector(clickToStarTVC(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        vc.auctionData = (searchTxt.text?.trimmed != "") ? arrSearchAuctionData[indexPath.row] : arrAuctionData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickToBidNow(_ sender: UIButton) {
        let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        vc.auctionData = (searchTxt.text?.trimmed != "") ? arrSearchAuctionData[sender.tag] : arrAuctionData[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickToStarTVC(_ sender: UIButton) {
        self.view.endEditing(true)
        let dict = (searchTxt.text?.trimmed != "") ? arrSearchAuctionData[sender.tag] : arrAuctionData[sender.tag]
        if sender.isSelected {
            serviceCallToRemoveBookmark(dict.auctionid, dict.bookmarkid, 2)
        }else{
            serviceCallToAddBookmark(dict.auctionid, 2)
        }
    }
}

//MARK:- Service called
extension HomeVC {
    func serviceCallToGetAuctionCategoryList()
    {
        if AppModel.shared.AUCTION_TYPE.count == 0 {
            APIManager.shared.serviceCallToGetAuctionCategoryList { (data) in
                setCategoryData(data)
                AppModel.shared.AUCTION_TYPE = [AuctionTypeModel]()
                for temp in data {
                    AppModel.shared.AUCTION_TYPE.append(AuctionTypeModel.init(dict: temp))
                }
                if AppModel.shared.AUCTION_TYPE.count > 0 {
                    self.selectedCategory = AppModel.shared.AUCTION_TYPE.first!
                }
                self.categoryCV.reloadData()
                self.serviceCallToGetAuction()
            }
        }else{
            selectedCategory = AppModel.shared.AUCTION_TYPE.first!
            categoryCV.reloadData()
            serviceCallToGetAuction()
        }
    }
    
    func serviceCallToGetAuction()
    {
        var param = [String : Any]()
        param["auctionstatus"] = "active"
        if isUserLogin() {
            param["userid"] = AppModel.shared.currentUser.userid
        }
        if selectedCategory.id != -1 {
            param["cattype"] = selectedCategory.id
        }
        APIManager.shared.serviceCallToGetAuction(param) { (data) in
            self.arrAuctionData = [AuctionModel]()
            self.arrFeatureAuctionData = [AuctionModel]()
            for temp in data {
                let auction = AuctionModel.init(dict: temp)
                if self.selectedCategory.id == -1 {
                    self.arrAuctionData.append(auction)
                }
                else if auction.cattype == self.selectedCategory.id {
                    self.arrAuctionData.append(auction)
                }
                if auction.auction_featured == "yes" {
                    self.arrFeatureAuctionData.append(auction)
                }
            }
            AppModel.shared.AUCTION_DATA[String(self.selectedCategory.id)] = self.arrAuctionData
            self.tblView.reloadData()
            self.noDataLbl.isHidden = (self.arrAuctionData.count > 0)
            self.setupFeatureAuction()
        }
    }
    
    func setupAuctionData()
    {
        if (selectedCategory.id == -1) && AppModel.shared.AUCTION_TYPE.count > 0 {
            selectedCategory = AppModel.shared.AUCTION_TYPE.first!
        }
        if (selectedCategory.id != -1) && (AppModel.shared.AUCTION_DATA[String(self.selectedCategory.id)] != nil) {
            arrAuctionData = AppModel.shared.AUCTION_DATA[String(self.selectedCategory.id)]!
            self.tblView.reloadData()
            setupFeatureAuction()
        }
        else{
            if AppModel.shared.AUCTION_TYPE.count == 0 {
                serviceCallToGetAuctionCategoryList()
            }else{
                serviceCallToGetAuctionCategoryList()
            }
        }
    }
    
    func setupFeatureAuction() {
        arrFeatureAuctionData = [AuctionModel]()
        for temp in arrAuctionData {
            if temp.auction_featured == "yes" {
                arrFeatureAuctionData.append(temp)
            }
        }
        self.featureCV.reloadData()
        featureView.isHidden = (self.arrFeatureAuctionData.count == 0)
    }
    
    func serviceCallToAddBookmark(_ auctionid : String, _ type : Int)
    {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bookmark_login_msg")
            return
        }
        var param = [String : Any]()
        param["auctionid"] = auctionid
        param["userid"] = AppModel.shared.currentUser.userid
        APIManager.shared.serviceCallToAddBookmark(param) { (bookmarkId) in
            displayToast("add_bookmark")
            if type == 2 {
                let index = self.arrAuctionData.firstIndex { (temp) -> Bool in
                    temp.auctionid == auctionid
                }
                if index != nil {
                    self.arrAuctionData[index!].bookmark = "yes"
                    self.arrAuctionData[index!].bookmarkid = String(bookmarkId)
                    let index1 = self.arrSearchAuctionData.firstIndex { (temp) -> Bool in
                        temp.auctionid == auctionid
                    }
                    if index1 != nil {
                        self.arrSearchAuctionData[index1!].bookmark = "yes"
                        self.arrSearchAuctionData[index1!].bookmarkid = String(bookmarkId)
                    }
                }
                self.tblView.reloadData()
            }
        }
    }
    
    func serviceCallToRemoveBookmark(_ auctionid : String, _ bookmarkid : String, _ type : Int)
    {
        var param = [String : Any]()
        param["bookmarkid"] = bookmarkid
        APIManager.shared.serviceCallToRemoveBookmark(param) { (data) in
            displayToast("remove_bookmark")
            if type == 2 {
                let index = self.arrAuctionData.firstIndex { (temp) -> Bool in
                    temp.auctionid == auctionid
                }
                if index != nil {
                    self.arrAuctionData[index!].bookmark = "no"
                    self.arrAuctionData[index!].bookmarkid = ""
                    let index1 = self.arrSearchAuctionData.firstIndex { (temp) -> Bool in
                        temp.auctionid == auctionid
                    }
                    if index1 != nil {
                        self.arrSearchAuctionData[index1!].bookmark = "no"
                        self.arrSearchAuctionData[index1!].bookmarkid = ""
                    }
                }
                self.tblView.reloadData()
            }
        }
    }
}
