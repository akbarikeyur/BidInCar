//
//  PostCarAuctionVC.swift
//  BidInCar
//
//  Created by Keyur on 21/10/19.
//  Copyright © 2019 Keyur. Al≥l rights reserved.
//

import UIKit
import MobileCoreServices
import DropDown

var currentAuction = AuctionModel.init()

class PostCarAuctionVC: UploadImageVC {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleTxt: FloatingTextfiledView!
    @IBOutlet weak var priceTxt: FloatingTextfiledView!
    @IBOutlet weak var minBidIncrementTxt: FloatingTextfiledView!
    @IBOutlet weak var yearTxt: FloatingTextfiledView!
    @IBOutlet weak var categoryTxt: FloatingTextfiledView!
    @IBOutlet weak var selectMakeTxt: FloatingTextfiledView!
    @IBOutlet weak var conditionTxt: FloatingTextfiledView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var startDateTxt: FloatingTextfiledView!
    @IBOutlet weak var endDateTxt: FloatingTextfiledView!
    @IBOutlet weak var vinTransamissionView: UIView!
    @IBOutlet weak var vinTxt: FloatingTextfiledView!
    @IBOutlet weak var transmissionTxt: FloatingTextfiledView!
    @IBOutlet weak var fuelView: UIView!
    @IBOutlet weak var fuelTypeTxt: FloatingTextfiledView!
    @IBOutlet weak var autoCheckTxt: FloatingTextfiledView!
    @IBOutlet weak var autoCheckImgView: UIImageView!
    @IBOutlet weak var imgBtn1: Button!
    @IBOutlet weak var imgBtn2: Button!
    @IBOutlet weak var imgBtn3: Button!
    @IBOutlet weak var imgBtn4: Button!
    @IBOutlet weak var imgBtn5: Button!
    @IBOutlet weak var imgBtn6: Button!
    @IBOutlet weak var imgBtn7: Button!
    
    
    var imageDict = [String : UIImage]()
    var selectedImgBtn = 0
    
    var arrYearData = [String]()
    var arrCategoryData = [CategoryModel]()
    var selectedCategory = CategoryModel.init()
    var arrSelectMakeData = [ChildCategoryModel]()
    var selectedMake = ChildCategoryModel.init()
    var selectedStartDate : Date?
    var selectedEndDate : Date?
    var autoCheckDoc : Int = 0
    var autoCheckDocPath : String = ""
    
    var myAuction = AuctionModel.init()
    var oldPicture = [String : PictureModel]()
    var removePicture = [String]()
    var autoCheckUpload = PictureModel.init()
    var selectedAuctionType = AuctionTypeModel.init(dict: [String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hideViewBasedOnAuctionType()
        setUIDesigning()
    }
    
    func setUIDesigning()
    {
        let year = Calendar.current.component(.year, from: Date())
        for i in 0...50{
            arrYearData.append(String(year - i))
        }
        
        selectMakeTxt.trailingSpace.constant = 10
        conditionTxt.leftSpace.constant = 10
        startDateTxt.trailingSpace.constant = 10
        endDateTxt.leftSpace.constant = 10
        vinTxt.trailingSpace.constant = 10
        transmissionTxt.leftSpace.constant = 10
        
        minBidIncrementTxt.myTxt.text = "100"
        minBidIncrementTxt.setTextFieldValue()
        minBidIncrementTxt.myTxt.isUserInteractionEnabled = false
        dateView.isHidden = true
        priceTxt.myTxt.keyboardType = .numberPad
        minBidIncrementTxt.myTxt.keyboardType = .numberPad
        vinTxt.myTxt.keyboardType = .numbersAndPunctuation
        currentAuction = AuctionModel.init()
        if myAuction.auctionid != "" && myAuction.auctionid != "0" {
            setupData()
        }else
        {
            serviceCallToGetCategoryList()
        }
        //fillData()
    }
    
    func fillData()
    {
        if PLATFORM.isSimulator {
            titleTxt.myTxt.text = "Old Boat 1"
            priceTxt.myTxt.text = "600000"
            minBidIncrementTxt.myTxt.text = "100"
            yearTxt.myTxt.text = "2018"
            vinTxt.myTxt.text = "5646"
            transmissionTxt.myTxt.text = NSLocalizedString("transmission_automatic", comment: "")
            fuelTypeTxt.myTxt.text = NSLocalizedString("fuel_diesel", comment: "")
        }
    }
    
    func hideViewBasedOnAuctionType()
    {
        if selectedAuctionType.id != 1 && selectedAuctionType.id != 4 {
            vinTransamissionView.isHidden = true
            fuelView.isHidden = true
        }else{
            vinTransamissionView.isHidden = false
            fuelView.isHidden = false
        }
    }
    
    //MARK:- Setup stadium detail
    func setupData()
    {
        currentAuction = myAuction
        titleTxt.myTxt.text = currentAuction.auction_title
        titleTxt.setTextFieldValue()
        priceTxt.myTxt.text = currentAuction.auction_price
        priceTxt.setTextFieldValue()
        minBidIncrementTxt.myTxt.text = currentAuction.auction_bidprice
        minBidIncrementTxt.setTextFieldValue()
        yearTxt.myTxt.text = currentAuction.year
        yearTxt.setTextFieldValue()
        
        if myAuction.categorytype != "" {
            let index1 = AppModel.shared.AUCTION_TYPE.firstIndex { (temp) -> Bool in
                temp.id == Int(myAuction.categorytype)
            }
            if index1 != nil {
                selectedAuctionType = AppModel.shared.AUCTION_TYPE[index1!]
            }
        }
        
        let index = arrCategoryData.firstIndex { (temp) -> Bool in
            temp.categoryid == currentAuction.auctioncategoryid
        }
        if index != nil {
            self.categoryTxt.myTxt.text = self.arrCategoryData[index!].category_name
            self.categoryTxt.setTextFieldValue()
            self.selectedCategory = arrCategoryData[index!]
            self.serviceCallToGetChildCategory()
        }
        else{
            serviceCallToGetCategoryList()
        }
        conditionTxt.myTxt.text = currentAuction.body_condition
        conditionTxt.setTextFieldValue()
        /*
        if let date : Date = getDateFromDateString(strDate: currentAuction.auction_created_on, format: "YYYY-MM-dd") {
            selectedStartDate = date
            startDateTxt.myTxt.text = getDateStringFromDate(date: selectedStartDate!, format: "dd-MM-yyyy")
            startDateTxt.setTextFieldValue()
        }
        if let date : Date = getDateFromDateString(strDate: currentAuction.auction_end, format: "YYYY-MM-dd") {
            selectedEndDate = date
            endDateTxt.myTxt.text = getDateStringFromDate(date: selectedEndDate!, format: "dd-MM-yyyy")
            endDateTxt.setTextFieldValue()
        }
        */
        vinTxt.myTxt.text = currentAuction.auction_vin
        vinTxt.setTextFieldValue()
        transmissionTxt.myTxt.text = currentAuction.auction_transmission
        transmissionTxt.setTextFieldValue()
        fuelTypeTxt.myTxt.text = currentAuction.auction_fueltype
        fuelTypeTxt.setTextFieldValue()
        
        let index1 = currentAuction.pictures.firstIndex { (temp) -> Bool in
            temp.type == "auto_check"
        }
        if index1 != nil {
            autoCheckUpload = currentAuction.pictures[index1!]
            currentAuction.pictures.remove(at: index1!)
        }
        if currentAuction.pictures.count > 0 {
            downloadImage(imgBtn1, 0)
        }
    }
    
    func downloadImage(_ button : Button, _ index : Int)
    {
        oldPicture[String(101 + index)] = currentAuction.pictures[index]
        button.sd_setBackgroundImage(with: URL(string: currentAuction.pictures[index].path), for: UIControl.State.normal, completed: { (image, error, SDImageCacheType, url) in
            if image != nil{
                button.setBackgroundImage(image, for: .normal)
                //self.imageDict[String(index)] = image
                if currentAuction.pictures.count > (index + 1) {
                    switch (index + 1) {
                        case 1:
                            self.downloadImage(self.imgBtn2, (index+1))
                            break
                        case 2:
                            self.downloadImage(self.imgBtn3, (index+1))
                            break
                        case 3:
                            self.downloadImage(self.imgBtn4, (index+1))
                            break
                        case 4:
                            self.downloadImage(self.imgBtn5, (index+1))
                            break
                        case 5:
                            self.downloadImage(self.imgBtn6, (index+1))
                            break
                        case 6:
                            self.downloadImage(self.imgBtn7, (index+1))
                            break
                        default:
                            break
                    }
                }
            }
            else
            {
                button.setBackgroundImage(nil, for: .normal)
            }
        })
    }
    
    
    
    //MARK: - Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectYear(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrYearData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.yearTxt.myTxt.text = item
            self.yearTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCategory(_ sender: UIButton) {
        self.view.endEditing(true)
        if arrCategoryData.count == 0 {
            serviceCallToGetCategoryList()
            return
        }
        var arrData = [String]()
        for temp in arrCategoryData {
            arrData.append(temp.category_name)
        }
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCategory = self.arrCategoryData[index]
            self.categoryTxt.myTxt.text = self.selectedCategory.category_name
            self.categoryTxt.setTextFieldValue()
            self.selectedMake = ChildCategoryModel.init()
            self.selectMakeTxt.myTxt.text = ""
            self.selectMakeTxt.myLbl.isHidden = true
            self.serviceCallToGetChildCategory()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectmake(_ sender: UIButton) {
        self.view.endEditing(true)
        if categoryTxt.myTxt.text == "" {
            displayToast("enter_auction_category")
            return
        }
        else if arrSelectMakeData.count == 0 {
            displayToast("auction_make_not_found")
            return
        }
        var arrData = [String]()
        for temp in arrSelectMakeData {
            arrData.append(temp.catchild_name)
        }
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedMake = self.arrSelectMakeData[index]
            self.selectMakeTxt.myTxt.text = self.selectedMake.catchild_name
            self.selectMakeTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCondition(_ sender: UIButton) {
        self.view.endEditing(true)
        let arrConditionData = [NSLocalizedString("condition_new", comment: ""), NSLocalizedString("condition_used", comment: "")]
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrConditionData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.conditionTxt.myTxt.text = item
            self.conditionTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectStartDate(_ sender: UIButton) {
        self.view.endEditing(true)
        if myAuction.auctionid != "" && myAuction.auctionid != "0" {
            return
        }
        DatePickerManager.shared.showPicker(title: "select_start_date", selected: selectedStartDate, min: Date(), max: nil) { (date, isCancel) in
            if !isCancel {
                self.startDateTxt.myTxt.text = getDateStringFromDate(date: date!, format: "dd-MM-yyyy")
                self.startDateTxt.setTextFieldValue()
                self.selectedStartDate = date!
                self.selectedEndDate = nil
                self.endDateTxt.myTxt.text = ""
            }
        }
    }
    
    @IBAction func clickToSelectEndDate(_ sender: UIButton) {
        self.view.endEditing(true)
        if myAuction.auctionid != "" && myAuction.auctionid != "0" {
            return
        }
        DatePickerManager.shared.showPicker(title: "select_end_date", selected: selectedEndDate, min: selectedStartDate, max: nil) { (date, isCancel) in
            if !isCancel {
                self.endDateTxt.myTxt.text = getDateStringFromDate(date: date!, format: "dd-MM-yyyy")
                self.endDateTxt.setTextFieldValue()
                self.selectedEndDate = date!
            }
        }
    }
    
    @IBAction func clickToSelectTransmission(_ sender: UIButton) {
        self.view.endEditing(true)
        let arrTransmisionData = [NSLocalizedString("transmission_automatic", comment: ""), NSLocalizedString("transmission_manual", comment: "")]
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrTransmisionData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.transmissionTxt.myTxt.text = item
            self.transmissionTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectFuelType(_ sender: UIButton) {
        self.view.endEditing(true)
        let arrFuelData = [NSLocalizedString("fuel_gas", comment: ""), NSLocalizedString("fuel_diesel", comment: ""), NSLocalizedString("fuel_hybrid", comment: ""), NSLocalizedString("fuel_electric", comment: "")]
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrFuelData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.fuelTypeTxt.myTxt.text = item
            self.fuelTypeTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToAutoCheckUpload(_ sender: UIButton) {
        self.view.endEditing(true)
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)

        if #available(iOS 11.0, *) {
            importMenu.allowsMultipleSelection = true
        }

        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet

        present(importMenu, animated: true)
    }
    
    @IBAction func clickToUploadImage(_ sender: UIButton) {
        selectedImgBtn = sender.tag
        if oldPicture[String(selectedImgBtn)] != nil {
            uploadRemoveImage()
        }
        else{
            uploadImage()
        }
    }
    
    override func removeExistedImage() {
        if let temp = oldPicture[String(selectedImgBtn)] {
            removePicture.append(temp.apid)
            oldPicture[String(selectedImgBtn)] = nil
            imageDict[String(selectedImgBtn)] = nil
            setButtonImage(UIImage.init(named: "add_image"))
        }
    }
    
    override func selectedImage(choosenImage: UIImage) {
        if selectedImgBtn != 0 {
            if selectedImgBtn == 12 {
                autoCheckImgView.image = choosenImage
                autoCheckTxt.myTxt.placeholder = ""
            }
            else{
                imageDict[String(selectedImgBtn)] = choosenImage
                if let temp = oldPicture[String(selectedImgBtn)] {
                    removePicture.append(temp.apid)
                    oldPicture[String(selectedImgBtn)] = nil
                }
                setButtonImage(choosenImage)
            }
        }
    }
    
    func setButtonImage(_ choosenImage : UIImage?)
    {
        switch selectedImgBtn {
            case 101:
                imgBtn1.setBackgroundImage(choosenImage, for: .normal)
                break
            case 102:
                imgBtn2.setBackgroundImage(choosenImage, for: .normal)
                break
            case 103:
                imgBtn3.setBackgroundImage(choosenImage, for: .normal)
                break
            case 104:
                imgBtn4.setBackgroundImage(choosenImage, for: .normal)
                break
            case 105:
                imgBtn5.setBackgroundImage(choosenImage, for: .normal)
                break
            case 106:
                imgBtn6.setBackgroundImage(choosenImage, for: .normal)
                break
            case 107:
                imgBtn7.setBackgroundImage(choosenImage, for: .normal)
                break
            default:
                break
        }
    }
    
    @IBAction func clickToSubmitAuction(_ sender: Any) {
        self.view.endEditing(true)        

        if titleTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_title")
        }
        else if priceTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_price")
        }
        else if minBidIncrementTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_increment")
        }
//        else if Int(minBidIncrementTxt.myTxt.text!)! < 100 {
//            displayToast("enter_auction_increment")
//        }
        else if yearTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_year")
        }
        else if arrCategoryData.count > 0 && categoryTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_category")
        }
        else if arrSelectMakeData.count > 0 && selectMakeTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_make")
        }
        else if conditionTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_condition")
        }
//        else if startDateTxt.myTxt.text?.trimmed == "" {
//            displayToast("enter_auction_start")
//        }
//        else if endDateTxt.myTxt.text?.trimmed == "" {
//            displayToast("enter_auction_end")
//        }
        else if selectedAuctionType.id == 1 && vinTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_vin")
        }
        else if selectedAuctionType.id == 1 && transmissionTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_transmission")
        }
        else if selectedAuctionType.id == 1 && fuelTypeTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_fuel")
        }
//        else if autoCheckDoc == 0 {
//            displayToast("enter_auction_auto_check")
//        }
        else if ((myAuction.auctionid == "" || myAuction.auctionid == "0") && imageDict.count == 0) {
            displayToast("enter_auction_image")
        }
        else if (imageDict.count == 0 && oldPicture.count == 0) {
            displayToast("enter_auction_image")
        }
        else{
            var param = [String : Any]()
            param["userid"] = AppModel.shared.currentUser.userid!
            param["auction_title"] = titleTxt.myTxt.text
            param["auction_price"] = priceTxt.myTxt.text
            param["auction_minbid"] = minBidIncrementTxt.myTxt.text //auction_bidprice
            param["auction_year"] = yearTxt.myTxt.text //year
            param["categories"] = selectedCategory.categoryid //auctioncategoryid
            if selectedMake.catchild_id == "" {
                param["childcat"] = 0
            }else{
                param["childcat"] = selectedMake.catchild_id //auctioncategorychildid
            }
            param["categories_name"] = categoryTxt.myTxt.text //category_name
            param["childcat_name"] = selectMakeTxt.myTxt.text //catchild_name
            //param["auction_start_end"] = getDateStringFromDate(date: selectedStartDate!, format: "YYYY/MM/dd") + " - " + getDateStringFromDate(date: selectedEndDate!, format: "YYYY/MM/dd") //YYYY/MM/DD - YYYY/MM/DD //auction_created_on - auction_end
            param["condition"] = conditionTxt.myTxt.text //bodycondition
            if selectedAuctionType.id == 1 {
                param["vin"] = vinTxt.myTxt.text //auction_vin
                param["tranmission"] = transmissionTxt.myTxt.text //auction_transmission
                param["fueltype"] = fuelTypeTxt.myTxt.text //auction_fueltype
            }
            if autoCheckDoc != 0 {
                param["auto_check_upload"] = autoCheckDoc
                param["auto_check_upload_path"] = autoCheckDocPath
            }
            param["categorytype"] = selectedAuctionType.id
            
            var arrImageData = [UIImage]()
            for temp in imageDict.keys {
                arrImageData.append(imageDict[temp]!)
            }
            myAuction.removePicture = removePicture
            let vc : PostAuctionFeaturesVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostAuctionFeaturesVC") as! PostAuctionFeaturesVC
            vc.arrImgData = arrImageData
            vc.param = param
            vc.myAuction = myAuction
            vc.selectedAuctionType = selectedAuctionType
            self.navigationController?.pushViewController(vc, animated: true)
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

//MARK:- Service called
extension PostCarAuctionVC {
    func serviceCallToGetCategoryList() {
        
        var cattype = selectedAuctionType.id
        if selectedAuctionType.id == 4 {
            cattype = 1
        }
        APIManager.shared.serviceCallToGetCategoryList(["cattype" : cattype!], false) { (data) in
            self.arrCategoryData = [CategoryModel]()
            for temp in data {
                self.arrCategoryData.append(CategoryModel.init(dict: temp))
            }
            if currentAuction.auctionid != "" && currentAuction.auctionid != "0" {
                let index = self.arrCategoryData.firstIndex { (temp) -> Bool in
                    temp.categoryid == currentAuction.auctioncategoryid
                }
                if index != nil {
                    self.categoryTxt.myTxt.text = self.arrCategoryData[index!].category_name
                    self.categoryTxt.setTextFieldValue()
                    self.selectedCategory = self.arrCategoryData[index!]
                    self.serviceCallToGetChildCategory()
                }
            }
        }
    }
    
    func serviceCallToGetChildCategory()
    {
        APIManager.shared.serviceCallToGetChildCategory(selectedCategory.categoryid) { (data) in
            self.arrSelectMakeData = [ChildCategoryModel]()
            if data.count > 0 {
                for temp in data {
                    self.arrSelectMakeData.append(ChildCategoryModel.init(dict: temp))
                }
            }
            else{
                self.selectMakeTxt.myTxt.text = ""
                self.selectedMake = ChildCategoryModel.init()
            }
            
            if currentAuction.auctionid != "0" {
                let index = self.arrSelectMakeData.firstIndex { (temp) -> Bool in
                    temp.catchild_id == currentAuction.auctioncategorychildid
                }
                if index != nil {
                    self.selectedMake = self.arrSelectMakeData[index!]
                    self.selectMakeTxt.myTxt.text = self.selectedMake.catchild_name
                    self.selectMakeTxt.setTextFieldValue()
                }
            }
        }
    }
}

extension PostCarAuctionVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        printData(urls)
        autoCheckTxt.myTxt.text = urls.first!.absoluteString.components(separatedBy: "/").last
        APIManager.shared.serviceCallToUploadAuctionDocument(urls.first!) { (docId,path) in
            printData(docId)
            self.autoCheckDoc = docId
            self.autoCheckDocPath = path
        }
        
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


