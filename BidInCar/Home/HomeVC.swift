//
//  HomeVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

class HomeVC: UploadImageVC {

    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet var noDataLbl: UILabel!
    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var featureCV: UICollectionView!
    @IBOutlet var filterView: UIView!
    @IBOutlet weak var categoryLbl: Label!
    @IBOutlet weak var makeLbl: Label!
    @IBOutlet weak var modelLbl: Label!
    @IBOutlet weak var minPriceTxt: TextField!
    @IBOutlet weak var maxPriceTxt: TextField!
    @IBOutlet weak var infoCV: UICollectionView!
    @IBOutlet weak var infoNextBtn: Button!
    @IBOutlet weak var constraintHeightInfoCV: NSLayoutConstraint!
    @IBOutlet weak var constraintCenterNoDataLbl: NSLayoutConstraint!
    
    var arrFeatureAuctionData : [AuctionModel] = [AuctionModel]()
    var arrAuctionData : [AuctionModel] = [AuctionModel]()
    var selectedCategory = AuctionTypeModel.init(dict: [String : Any]())
    var refreshControl = UIRefreshControl.init()
    var arrInfo = [InfoModel]()
    
    var dictFilter = [String : String]()
    var arrMake = [CategoryModel]()
    var selectedMake = CategoryModel.init()
    var arrModel = [ChildCategoryModel]()
    var selectedModel = ChildCategoryModel.init()
    var selectedFilterCategory = AuctionTypeModel.init(dict: [String : Any]())
    var page = 1
    var filterParam : [String : Any]?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        featureView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.UPDATE_AUCTION_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFeatureAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.AUCTION_FEATURED_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeAuctionData(_:)), name: NSNotification.Name.init(NOTIFICATION.REMOVE_AUCTION_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTopData), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_DASHBOARD_TOP_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clickToNotification(_:)), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_NOTIFICATION_SCREEN), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserDetails), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        
        
        featureCV.register(UINib.init(nibName: "CustomCarCVC", bundle: nil), forCellWithReuseIdentifier: "CustomCarCVC")
        categoryCV.register(UINib.init(nibName: "CustomAuctionCategoryCVC", bundle: nil), forCellWithReuseIdentifier: "CustomAuctionCategoryCVC")
        infoCV.register(UINib.init(nibName: "CustomInfoCVC", bundle: nil), forCellWithReuseIdentifier: "CustomInfoCVC")
        
        tblView.register(UINib.init(nibName: "CustomCarTVC", bundle: nil), forCellReuseIdentifier: "CustomCarTVC")
        
        
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        tblView.tableHeaderView = headerView
        updateTableviewHeight()
        setTextFieldPlaceholderColor(searchTxt, LightGrayColor)
        
        refreshControl.tintColor = BlueColor
        refreshControl.addTarget(self, action: #selector(refreshAuctionList), for: .valueChanged)
        tblView.refreshControl = refreshControl
        
        if arrAuctionData.count == 0 {
            if AppModel.shared.AUCTION_DATA.count == 0 {
                if isUserLogin() {
                    AppDelegate().sharedDelegate().serviceCallToGetUserProfile()
                }
                serviceCallToGetAuctionCategoryList()
            }else{
                setupAuctionData()
            }
            if isUserLogin() {
                if isUserBuyer() {
                    setBuyerData()
                }else{
                    setSellerData()
                }
            }
            refreshTopData()
        }
        
        if AppModel.shared.isTokenUpdate == nil || !AppModel.shared.isTokenUpdate {
            AppModel.shared.isTokenUpdate = true
            LoginAPIManager.shared.serviceCallToRegisterDevice()
        }
        if !Platform.isSimulator {
            checkForUpdate()
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
            }
            updateTableviewHeight()
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
                    arrAuctionData[index!].auction_featured = "yes"
                    updateTableviewHeight()
                    
                    let index1 = arrFeatureAuctionData.firstIndex { (temp) -> Bool in
                        temp.auctionid == auctionid
                    }
                    if index1 == nil {
                        let arrTempData = arrFeatureAuctionData
                        arrFeatureAuctionData = [AuctionModel]()
                        arrFeatureAuctionData.append(arrAuctionData[index!])
                        arrFeatureAuctionData.append(contentsOf: arrTempData)
                        featureCV.reloadData()
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
            }
            updateTableviewHeight()
            categoryCV.reloadData()
        }
    }
    
    @objc func refreshAuctionList()
    {
        refreshControl.endRefreshing()
        page = 1
        searchTxt.text = ""
        self.view.endEditing(true)
        serviceCallToGetAuction(nil)
        refreshTopData()
    }
    
    @objc func refreshTopData() {
        if !isUserLogin() {
            self.constraintHeightInfoCV.constant = 0
            infoNextBtn.isHidden = true
            return
        }
        if isUserBuyer() {
            serviceCallToGetBuyerData()
        }else{
            serviceCallToGetSellerData()
        }
    }
    
    @objc func updateUserDetails() {
        if isUserLogin() {
            if isUserBuyer() {
                setBuyerData()
            }else{
                setSellerData()
            }
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    @IBAction func clickToNotification(_ sender: Any) {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().navigateToLogin()
            return
        }
        addButtonEvent(EVENT.TITLE.NOTIFICATION, EVENT.ACTION.NOTIFICATION, String(describing: self))
        let vc : NotificationVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToReload(_ sender: Any) {
        serviceCallToGetAuction(nil)
        refreshTopData()
    }
    
    @IBAction func clickToFilter(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.FILTER, EVENT.ACTION.FILTER, String(describing: self))
        if arrMake.count == 0 {
            if selectedFilterCategory.id == -1 {
                selectedFilterCategory = AppModel.shared.AUCTION_TYPE.first!
            }
            serviceCallToSelectMake()
        }
        categoryLbl.text = selectedFilterCategory.name
        displaySubViewtoParentView(self.view, subview: filterView)
    }
    
    @IBAction func clickToSelectCategory(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in AppModel.shared.AUCTION_TYPE {
            arrData.append(temp.name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.categoryLbl.text = item
            if self.selectedFilterCategory != AppModel.shared.AUCTION_TYPE[index] {
                self.selectedFilterCategory = AppModel.shared.AUCTION_TYPE[index]
                self.arrMake = [CategoryModel]()
                self.selectedMake = CategoryModel.init()
                self.makeLbl.text = ""
                self.arrModel = [ChildCategoryModel]()
                self.selectedModel = ChildCategoryModel.init()
                self.modelLbl.text = ""
                self.serviceCallToSelectMake()
            }
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectMake(_ sender: UIButton) {
        if selectedFilterCategory.id == -1 {
            displayToast("enter_auction_category")
            return
        }
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrMake {
            arrData.append(temp.category_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.makeLbl.text = item
            if self.selectedMake != self.arrMake[index] {
                self.selectedMake = self.arrMake[index]
                self.modelLbl.text = ""
                self.arrModel = [ChildCategoryModel]()
                self.selectedModel = ChildCategoryModel.init()
                self.serviceCallToSelectModel()
            }
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectModel(_ sender: UIButton) {
        if selectedMake.categoryid == "" {
            displayToast("enter_auction_make")
            return
        }
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrModel {
            arrData.append(temp.catchild_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.modelLbl.text = item
            self.selectedModel = self.arrModel[index]
        }
        dropDown.show()
    }
    
    @IBAction func clickToCloseFilterView(_ sender: Any) {
        self.view.endEditing(true)
        filterView.removeFromSuperview()
    }
    
    @IBAction func clickToApplyFilter(_ sender: Any) {
        self.view.endEditing(true)
        
        if minPriceTxt.text?.trimmed != "" && maxPriceTxt.text?.trimmed != "" && (Int(minPriceTxt.text!)! > Int(maxPriceTxt.text!)!) {
            displayToast("invalid_price")
        }
        else{
            //{"auction_title":"","carmake":"0","carmodel":null,"min_price":"","max_price":"","cattype":"1"}
            var param = [String : Any]()
            param["cattype"] = selectedFilterCategory.id
            if selectedMake.categoryid != "" {
                param["carmake"] = selectedMake.categoryid
            }else{
                param["carmake"] = 0
            }
            if selectedModel.catchild_id != "" {
                param["carmodel"] = selectedModel.catchild_id
            }else{
                param["carmodel"] = ""
            }
            if minPriceTxt.text?.trimmed != "" && maxPriceTxt.text?.trimmed != "" {
                param["min_price"] = minPriceTxt.text
                param["max_price"] = maxPriceTxt.text
            }else{
                param["min_price"] = ""
                param["max_price"] = ""
            }
            searchTxt.text = ""
            page = 1
            selectedCategory = selectedFilterCategory
            categoryCV.reloadData()
            serviceCallToGetAuction(param)
            filterView.removeFromSuperview()
        }
    }
    
    @IBAction func clickToNextCategory(_ sender: UIButton) {
        if sender.tag == 1 {
            categoryCV.scrollToItem(at: IndexPath(row: AppModel.shared.AUCTION_TYPE.count-1, section: 0), at: .left, animated: true)
        }
        else if sender.tag == 2 {
            featureCV.scrollToItem(at: IndexPath(row: arrFeatureAuctionData.count-1, section: 0), at: .left, animated: true)
        }
        else if sender.tag == 3 {
            infoCV.scrollToItem(at: IndexPath(row: arrInfo.count-1, section: 0), at: .left, animated: true)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField == searchTxt {
            if textField.text!.trimmed.count > 2 {
                if timer != nil {
                    timer?.invalidate()
                }
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (time) in
                    if self.searchTxt.text?.trimmed != "" {
                        self.page = 1
                        self.serviceCallToGetAuction([String : Any]())
                    }
                })
            }
        }
    }
    
    func checkForUpdate() {
        DispatchQueue.global().async {
            do {
                let update = try isUpdateAvailable()
                print("update",update)
                DispatchQueue.main.async {
                    if update{
                        LoginAPIManager.shared.serviceCallToCheckAppUpdateStatus { (isForcefully) in
                            let vc : AppUpdateVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AppUpdateVC") as! AppUpdateVC
                            vc.isForcefully = isForcefully
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            } catch {
                print(error)
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

//MARK:- Collectionview method
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == featureCV {
            return arrFeatureAuctionData.count
        }
        else if collectionView == infoCV {
            return arrInfo.count
        }
        return AppModel.shared.AUCTION_TYPE.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == featureCV {
            return CGSize(width: 100, height: collectionView.frame.size.height)
        }
        else if collectionView == infoCV {
            let newLable : UILabel = UILabel.init()
            newLable.font = UIFont.init(name: APP_REGULAR, size: 12.0)
            let dict = arrInfo[indexPath.row]
            newLable.text = dict.name + " " + dict.value
            if dict.link != "" {
                newLable.text = newLable.text! + " " + getTranslate(dict.link)
            }
            let width = newLable.intrinsicContentSize.width + 60
            return CGSize(width: width, height: collectionView.frame.size.height)
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
            cell.starBtn.tag = indexPath.row
            cell.starBtn.addTarget(self, action: #selector(clickToStarFeatureAuction(_:)), for: .touchUpInside)
            return cell
        }
        else if collectionView == infoCV {
            let cell : CustomInfoCVC = infoCV.dequeueReusableCell(withReuseIdentifier: "CustomInfoCVC", for: indexPath) as! CustomInfoCVC
            cell.setupDetails(arrInfo[indexPath.row])
            return cell
        }
        else{
            let cell : CustomAuctionCategoryCVC = categoryCV.dequeueReusableCell(withReuseIdentifier: "CustomAuctionCategoryCVC", for: indexPath) as! CustomAuctionCategoryCVC
            let dict = AppModel.shared.AUCTION_TYPE[indexPath.row]
            cell.setupDetail(dict)
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
        self.view.endEditing(true)
        if collectionView == featureCV {
            addButtonEvent(EVENT.TITLE.AUCTION_DETAIL, EVENT.ACTION.AUCTION_DETAIL, String(describing: self))
            let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
            vc.auctionData = arrFeatureAuctionData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == categoryCV {
            selectedCategory = AppModel.shared.AUCTION_TYPE[indexPath.row]
            selectedFilterCategory = selectedCategory
            categoryCV.reloadData()
            if let data = AppModel.shared.AUCTION_DATA[String(self.selectedCategory.id)], data.count > 0 {
                arrAuctionData = data
                updateTableviewHeight()
                noDataLbl.isHidden = (arrAuctionData.count > 0)
                gtPageValue()
                setupFeatureAuction()
            }
            else{
//                searchTxt.text = ""
                page = 1
                serviceCallToGetAuction(nil)
            }
        }
        else if collectionView == infoCV {
            if isUserBuyer() {
                let tempInfo = arrInfo[indexPath.row]
                if tempInfo.name == getTranslate("info_deposit_amount") || tempInfo.name == getTranslate("info_total_bidding_limit") {
                    addButtonEvent(EVENT.TITLE.ADD_DEPOSIT, EVENT.ACTION.ADD_DEPOSIT, String(describing: self))
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_MY_PROFILE), object: nil)
                    delay(0.1) {
                        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_BUYER_PAYMENT), object: nil)
                        delay(0.1) {
                            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.OPEN_ADD_DEPOSIT), object: nil)
                        }
                    }
                }
            }
            else {
                let tempInfo = arrInfo[indexPath.row]
                if tempInfo.name == getTranslate("info_package") {
                    addButtonEvent(EVENT.TITLE.PACKAGE, EVENT.ACTION.PACKAGE, String(describing: self))
                    let vc : PackageVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PackageVC") as! PackageVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func clickToStarFeatureAuction(_ sender: UIButton) {
        self.view.endEditing(true)
        let dict = arrFeatureAuctionData[sender.tag]
        if sender.isSelected {
            serviceCallToRemoveBookmark(dict.auctionid, dict.bookmarkid, 2)
        }else{
            serviceCallToAddBookmark(dict.auctionid, 2)
        }
    }
    
}

//MARK:- Tablewview method
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAuctionData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCarTVC = tblView.dequeueReusableCell(withIdentifier: "CustomCarTVC") as! CustomCarTVC
        let dict = arrAuctionData[indexPath.row]
        cell.setupDetails(dict)
        cell.bidNowBtn.isHidden = false
        cell.bidNowBtn.tag = indexPath.row
        cell.bidNowBtn.addTarget(self, action: #selector(clickToBidNow(_:)), for: .touchUpInside)
        cell.starBtn.tag = indexPath.row
        cell.starBtn.addTarget(self, action: #selector(clickToStarTVC(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if page != 0 && arrAuctionData.count-1 == indexPath.row {
            serviceCallToGetAuction(filterParam)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addButtonEvent(EVENT.TITLE.AUCTION_DETAIL, EVENT.ACTION.AUCTION_DETAIL, String(describing: self))
        let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        vc.auctionData = arrAuctionData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickToBidNow(_ sender: UIButton) {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bid_login_msg")
            return
        }
        if !isUserBuyer() {
            showAlert("error_title", message: "not_buyer_account") {
                
            }
            return
        }
        addButtonEvent(EVENT.TITLE.AUCTION_DETAIL, EVENT.ACTION.AUCTION_DETAIL, String(describing: self))
        let vc : CarDetailVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        vc.auctionData = arrAuctionData[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickToStarTVC(_ sender: UIButton) {
        self.view.endEditing(true)
        let dict = arrAuctionData[sender.tag]
        if sender.isSelected {
            serviceCallToRemoveBookmark(dict.auctionid, dict.bookmarkid, 2)
        }else{
            serviceCallToAddBookmark(dict.auctionid, 2)
        }
    }
    
    
    func updateTableviewHeight() {
        tblView.reloadData()
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
                printData(data)
                if isArabic() {
                    let tempdata = data.reversed()
                    printData(tempdata)
                }
                for temp in data {
                    AppModel.shared.AUCTION_TYPE.append(AuctionTypeModel.init(dict: temp))
                }
                if AppModel.shared.AUCTION_TYPE.count > 0 {
                    self.selectedCategory = AppModel.shared.AUCTION_TYPE.first!
                    self.selectedFilterCategory = self.selectedCategory
                    self.categoryLbl.text = self.selectedFilterCategory.name
                    self.serviceCallToSelectMake()
                }
                self.categoryCV.reloadData()
                self.serviceCallToGetAuction(nil)
            }
        }else{
            selectedCategory = AppModel.shared.AUCTION_TYPE.first!
            categoryCV.reloadData()
            serviceCallToGetAuction(nil)
        }
    }
    
    func serviceCallToGetAuction(_ filter : [String : Any]?)
    {
        self.view.endEditing(true)
        var param = [String : Any]()
        if filter != nil {
            filterParam = filter
            param = filter!
        }else{
            filterParam = nil
        }
        if searchTxt.text != "" {
            param["auction_title"] = searchTxt.text
        }
        param["auctionstatus"] = "active"
        if isUserLogin() {
            param["userid"] = AppModel.shared.currentUser.userid
        }
        if selectedCategory.id != -1 {
            param["categoryid"] = selectedCategory.id
        }
        param["page"] = page
        printData(param)
        APIManager.shared.serviceCallToGetAuction(param) { (data) in
            if self.page == 1 {
                self.arrAuctionData = [AuctionModel]()
                self.arrFeatureAuctionData = [AuctionModel]()
            }
            if self.page != 0 {
                for temp in data {
                    let auction = AuctionModel.init(dict: temp)
                    if self.selectedCategory.id == -1 {
                        self.arrAuctionData.append(auction)
                    }
                    else if auction.categorytype == String(self.selectedCategory.id) {
                        self.arrAuctionData.append(auction)
                    }
                }
            }
            
            if data.count < 10 {
                self.page = 0
            }else{
                self.page += 1
            }
            let arrTemp = self.arrAuctionData
            self.arrAuctionData = [AuctionModel]()
            var arrNormal = [AuctionModel]()
            for temp in arrTemp {
               if temp.auction_featured == "yes" {
                    self.arrAuctionData.append(temp)
               }else{
                    arrNormal.append(temp)
                }
            }
            self.arrAuctionData.append(contentsOf: arrNormal)
            AppModel.shared.AUCTION_DATA[String(self.selectedCategory.id)] = self.arrAuctionData
            self.updateTableviewHeight()
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
            gtPageValue()
            self.updateTableviewHeight()
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
    
    func gtPageValue() {
        if arrAuctionData.count == 0 {
            page = 1
        }
        else if arrAuctionData.count % 10 == 0 {
            page = Int(arrAuctionData.count/10) + 1
        }else{
            page = 0
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
        featureView.isHidden = (arrFeatureAuctionData.count == 0)
        tblView.tableHeaderView = nil
        var newFrame = headerView.frame
        if featureView.isHidden {
            newFrame.size.height = 180
        }else{
            newFrame.size.height = 330
        }
        headerView.frame = newFrame
        tblView.tableHeaderView = headerView
        tblView.reloadData()
        updateNoDataCenter()
    }
    
    func serviceCallToAddBookmark(_ auctionid : String, _ type : Int)
    {
        if !isUserLogin() {
            AppDelegate().sharedDelegate().showLoginPopup("bookmark_login_msg")
            return
        }
        addButtonEvent(EVENT.TITLE.ADD_WISHLIST, EVENT.ACTION.ADD_WISHLIST, String(describing: self))
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
                }
                self.updateTableviewHeight()
                
                let index1 = self.arrFeatureAuctionData.firstIndex { (temp) -> Bool in
                    temp.auctionid == auctionid
                }
                if index1 != nil {
                    self.arrFeatureAuctionData[index1!].bookmark = "yes"
                    self.arrFeatureAuctionData[index1!].bookmarkid = String(bookmarkId)
                    self.featureCV.reloadData()
                }
            }
        }
    }
    
    func serviceCallToRemoveBookmark(_ auctionid : String, _ bookmarkid : String, _ type : Int)
    {
        addButtonEvent(EVENT.TITLE.REMOVE_WISHLIST, EVENT.ACTION.REMOVE_WISHLIST, String(describing: self))
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
                }
                self.updateTableviewHeight()
                
                let index1 = self.arrFeatureAuctionData.firstIndex { (temp) -> Bool in
                    temp.auctionid == auctionid
                }
                if index1 != nil {
                    self.arrFeatureAuctionData[index1!].bookmark = "no"
                    self.arrFeatureAuctionData[index1!].bookmarkid = ""
                    self.featureCV.reloadData()
                }
            }
        }
    }
    
    func serviceCallToSelectMake() {
        
        APIManager.shared.serviceCallToGetCategoryList(["cattype" : selectedFilterCategory.id!], true) { (data) in
            self.arrMake = [CategoryModel]()
            for temp in data {
                self.arrMake.append(CategoryModel.init(dict: temp))
            }
        }
    }
    
    func serviceCallToSelectModel()
    {
        APIManager.shared.serviceCallToGetChildCategory(selectedMake.categoryid) { (data) in
            self.arrModel = [ChildCategoryModel]()
            if data.count > 0 {
                for temp in data {
                    self.arrModel.append(ChildCategoryModel.init(dict: temp))
                }
            }
        }
    }
    
    func serviceCallToGetBuyerData() {
        if isUserLogin() && isUserBuyer() && AppModel.shared.currentUser.userid != "" {
            APIManager.shared.serviceCallToGetBuyerData(AppModel.shared.currentUser.userid) { (data) in
                saveBuyerTopData(data)
                self.setBuyerData()
            }
        }
        else{
            self.constraintHeightInfoCV.constant = 0
            infoNextBtn.isHidden = true
        }
    }
    
    func setBuyerData() {
        let data = getBuyerTopData()
        self.arrInfo = [InfoModel]()
        for temp in getJsonFromFile("buyer_info") {
            let tempInfo = InfoModel.init(dict: temp)
            if tempInfo.name == getTranslate("info_active_auctions") {
                tempInfo.value = AppModel.shared.getStringValue(data, "active_auction_bids")
            }
            else if tempInfo.name == getTranslate("info_total_auctions") {
                tempInfo.value = AppModel.shared.getStringValue(data, "total_auctions")
            }
            else if tempInfo.name == getTranslate("info_deposit_amount") {
                tempInfo.value = AppModel.shared.getStringValue(data, "deposite")
            }
            else if tempInfo.name == getTranslate("info_total_bidding_limit") {
                tempInfo.value = AppModel.shared.getStringValue(data, "total_biding_limit")
            }
            else if tempInfo.name == getTranslate("info_remaining_bidding_limit") {
                tempInfo.value = AppModel.shared.getStringValue(data, "remain_biding_limit")
            }
            self.arrInfo.append(tempInfo)
        }
        self.infoCV.reloadData()
        if self.arrInfo.count == 0 {
            self.constraintHeightInfoCV.constant = 0
            self.infoNextBtn.isHidden = true
        }else{
            self.constraintHeightInfoCV.constant = 40
            self.infoNextBtn.isHidden = false
        }
    }
    
    func serviceCallToGetSellerData() {
        if isUserLogin() && !isUserBuyer() && AppModel.shared.currentUser.userid != "" {
            APIManager.shared.serviceCallToGetSellerData(AppModel.shared.currentUser.userid) { (data) in
                saveSellerTopData(data)
                self.setSellerData()
            }
        }else{
            self.constraintHeightInfoCV.constant = 0
            self.infoNextBtn.isHidden = true
        }
    }
    
    func setSellerData() {
        let data = getSellreTopData()
        self.arrInfo = [InfoModel]()
        for temp in getJsonFromFile("seller_info") {
            let tempInfo = InfoModel.init(dict: temp)
            if tempInfo.name == getTranslate("info_active_auctions") {
                tempInfo.value = AppModel.shared.getStringValue(data, "active_auction")
            }
            else if tempInfo.name == getTranslate("info_total_auctions") {
                tempInfo.value = AppModel.shared.getStringValue(data, "total_auction")
            }
            else if tempInfo.name == getTranslate("info_package") {
                tempInfo.value = AppModel.shared.getStringValue(data, "package_name")
            }
            else if tempInfo.name == getTranslate("info_remaining_auctions") {
                let auctionsleft = AppModel.shared.getStringValue(data, "auctionsleft")
                if auctionsleft != "", let value : Int = Int(auctionsleft), value <= 35 {
                    tempInfo.value = String(value)
                }else{
                    tempInfo.value = getTranslate("unlimited_value")
                }
            }
            self.arrInfo.append(tempInfo)
        }
        self.infoCV.reloadData()
        if self.arrInfo.count == 0 {
            self.constraintHeightInfoCV.constant = 0
            self.infoNextBtn.isHidden = true
        }else{
            self.constraintHeightInfoCV.constant = 40
            self.infoNextBtn.isHidden = false
        }
    }
    
    func updateNoDataCenter() {
        if featureView.isHidden {
            constraintCenterNoDataLbl.constant = 60
        }else{
            constraintCenterNoDataLbl.constant = 210
        }
    }
}
