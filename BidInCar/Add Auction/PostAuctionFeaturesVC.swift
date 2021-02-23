//
//  PostAuctionFeaturesVC.swift
//  BidInCar
//
//  Created by Keyur on 22/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown
import GooglePlaces

class PostAuctionFeaturesVC: UIViewController, UITextViewDelegate, SelectAddressDelegate {

    @IBOutlet weak var bodyTypeView: UIView!
    @IBOutlet weak var bodyTypeTxt: FloatingTextfiledView!
    @IBOutlet weak var countryTxt: FloatingTextfiledView!
    @IBOutlet weak var motorTxt: FloatingTextfiledView!
    @IBOutlet weak var colorTxt: FloatingTextfiledView!
    @IBOutlet weak var addressTxt: FloatingTextfiledView!
    @IBOutlet weak var latitudeTxt: FloatingTextfiledView!
    @IBOutlet weak var longitudeTxt: FloatingTextfiledView!
    @IBOutlet weak var descTxtView: TextView!
    @IBOutlet weak var descCountLbl: Label!
    @IBOutlet weak var termsTxtView: TextView!
    @IBOutlet weak var termsCheckBoxBtn: UIButton!
    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var motorColorView: UIView!
    @IBOutlet weak var mechanicalView: UIView!
    @IBOutlet weak var mechanicalTxt: FloatingTextfiledView!
    @IBOutlet weak var wheelView: UIView!
    @IBOutlet weak var wheelTxt: FloatingTextfiledView!
    @IBOutlet weak var driveTxt: FloatingTextfiledView!
    @IBOutlet weak var engineTxt: FloatingTextfiledView!
    @IBOutlet weak var bodyConditionView: UIView!
    @IBOutlet weak var bodyConditionTxt: FloatingTextfiledView!
    @IBOutlet weak var boatLengthView: UIView!
    @IBOutlet weak var boatLengthTxt: FloatingTextfiledView!
    @IBOutlet weak var boatAgeTxt: FloatingTextfiledView!
    @IBOutlet weak var boatWarrantyTxt: FloatingTextfiledView!
    @IBOutlet weak var milageTxt: FloatingTextfiledView!
    
    @IBOutlet weak var scrapView: UIView!
    @IBOutlet weak var interiorColorTxt: FloatingTextfiledView!
    @IBOutlet weak var cylinderTxt: FloatingTextfiledView!
    @IBOutlet weak var doorTxt: FloatingTextfiledView!
    @IBOutlet weak var horsePowerTxt: FloatingTextfiledView!
    @IBOutlet weak var warrantyTxt: FloatingTextfiledView!
    @IBOutlet weak var createAuctionLbl: Label!
    @IBOutlet weak var termsConditionLbl: Label!
    
    
    var arrBodyData = [getTranslate("body_sedan"), getTranslate("body_coupe"), getTranslate("body_crossover"), getTranslate("body_hard_top_convertible"), getTranslate("body_hatchback"), getTranslate("body_pick_up_truck"), getTranslate("body_soft_top_convertible"), getTranslate("body_sports_car"), getTranslate("body_SUV"), getTranslate("body_utility_truck"), getTranslate("body_van"), getTranslate("body_wagon"), getTranslate("body_other")]
    var arrMechanicalData = [getTranslate("mechanic_excellent"), getTranslate("mechanic_very_good"), getTranslate("mechanic_moderate"), getTranslate("mechanic_poor")]
    var arrWheelData = ["2", "3", "4"]
    var arrDriveData = [getTranslate("drive_belt"), getTranslate("drive_chain"), getTranslate("drive_shaft")]
    var arrEngineSize = [String]()
    var arrBodyCondition = [getTranslate("body_excellent"), getTranslate("body_very_good"), getTranslate("body_moderate"), getTranslate("body_poor")]
    
    var arrCountryData = getCountryData()
    var selectedCountry = CountryModel.init()
    
    var param = [String : Any]()
    var arrImgData = [UIImage]()
    var myAuction = AuctionModel.init()
    var arrMediaData = [Int]()
    var selectedAuctionType = AuctionTypeModel.init(dict: [String : Any]())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUIDesigning()
        AppDelegate().sharedDelegate().getPackageHistory()
    }
    
    func setUIDesigning()
    {
        motorTxt.myTxt.keyboardType = .numberPad
        milageTxt.myTxt.keyboardType = .numberPad
        latitudeTxt.myTxt.keyboardType = .decimalPad
        longitudeTxt.myTxt.keyboardType = .decimalPad
        latitudeTxt.trailingSpace.constant = 10
        longitudeTxt.leftSpace.constant = 10
        descCountLbl.text = "0/500"
        hideViewBasedOnAuctionType()
        if myAuction.auctionid != "" && myAuction.auctionid != "0" {
            setupData()
        }
        else{
            createAuctionLbl.text = getTranslate("create_auction")
        }
        
        termsConditionLbl.attributedText = getAttributeStringWithColor(termsConditionLbl.text!, [termsConditionLbl.text!], color: UIColor.blue, font: termsConditionLbl.font, isUnderLine: true)
    }
    
    func hideViewBasedOnAuctionType()
    {
        bodyTypeView.isHidden = true
        motorColorView.isHidden = true
        mechanicalView.isHidden = true
        wheelView.isHidden = true
        boatLengthView.isHidden = true
        scrapView.isHidden = true
        if selectedAuctionType.id == 1 {
            bodyTypeView.isHidden = false
            motorColorView.isHidden = false
            scrapView.isHidden = false
            mechanicalView.isHidden = false
            interiorColorTxt.trailingSpace.constant = 10
            interiorColorTxt.myTxt.textAlignment = .left
            cylinderTxt.leftSpace.constant = 10
            cylinderTxt.myTxt.textAlignment = .left
            doorTxt.trailingSpace.constant = 10
            doorTxt.myTxt.textAlignment = .left
            horsePowerTxt.leftSpace.constant = 10
            horsePowerTxt.myTxt.textAlignment = .left
        }
        else {
            mechanicalView.isHidden = false
            if selectedAuctionType.id == 2 {
                wheelView.isHidden = false
                arrEngineSize = [String]()
                for i in 0...76 {
                    if i == 0 {
                        arrEngineSize.append("100")
                    }else{
                        let value = Int(arrEngineSize[i-1])! + 25
                        arrEngineSize.append(String(value))
                    }
                }
            }
            else if selectedAuctionType.id == 3 {
                boatLengthView.isHidden = false
            }
            else if selectedAuctionType.id == 4 {
                bodyTypeView.isHidden = false
                motorColorView.isHidden = false
                motorTxt.myTxt.placeholder = getTranslate("engine_number")
                colorTxt.myTxt.placeholder = getTranslate("exterior_colour")
                scrapView.isHidden = false
                
                interiorColorTxt.trailingSpace.constant = 10
                interiorColorTxt.myTxt.textAlignment = .left
                cylinderTxt.leftSpace.constant = 10
                cylinderTxt.myTxt.textAlignment = .left
                doorTxt.trailingSpace.constant = 10
                doorTxt.myTxt.textAlignment = .left
                horsePowerTxt.leftSpace.constant = 10
                horsePowerTxt.myTxt.textAlignment = .left
            }
        }
    }
    
    func setupData()
    {
        createAuctionLbl.text = getTranslate("update_auction")
        bodyTypeTxt.myTxt.text = myAuction.auction_bodytype
        for temp in arrCountryData {
            if temp.countryid == myAuction.countryid {
                selectedCountry = temp
                break
            }
        }
        countryTxt.myTxt.text = selectedCountry.country_name
        motorTxt.myTxt.text = myAuction.auction_motorno
        colorTxt.myTxt.text = myAuction.auction_extcolour
        bodyConditionTxt.myTxt.text = myAuction.body_condition
        
        milageTxt.myTxt.text = myAuction.auction_millage
        mechanicalTxt.myTxt.text = myAuction.mechanical
        wheelTxt.myTxt.text = myAuction.wheels
        driveTxt.myTxt.text = myAuction.drive_system
        engineTxt.myTxt.text = myAuction.engine_size
        boatLengthTxt.myTxt.text = myAuction.boat_length
        boatAgeTxt.myTxt.text = myAuction.auction_age
        
        
        interiorColorTxt.myTxt.text = myAuction.interior_color
        cylinderTxt.myTxt.text = myAuction.no_of_cylinder
        doorTxt.myTxt.text = myAuction.doors
        horsePowerTxt.myTxt.text = myAuction.auction_horse_power
        warrantyTxt.myTxt.text = myAuction.warranty
        boatWarrantyTxt.myTxt.text = myAuction.warranty
        
        latitudeTxt.myTxt.text = myAuction.auction_lat
        longitudeTxt.myTxt.text = myAuction.auction_long
        addressTxt.myTxt.text = myAuction.auction_address
        termsTxtView.text = myAuction.auction_terms
        descTxtView.text = myAuction.auction_desc
        descCountLbl.text = String(descTxtView.text.count) + "/500"
        
        
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToTermsConditionCheckBox(_ sender: Any) {
        termsCheckBoxBtn.isSelected = !termsCheckBoxBtn.isSelected
    }
    
    
    @IBAction func clickToTermsConditions(_ sender: Any) {
        self.view.endEditing(true)
        screenType = 1
        let vc : PrivacyPolicyVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.isBackDisplay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSelectAddress(_ sender: UIButton) {
        self.view.endEditing(true)
        autocompleteClicked()
//        let vc : SelectAddressVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
//        vc.delegate = self
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSelectMechanical(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrMechanicalData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.mechanicalTxt.myTxt.text = item
            self.mechanicalTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectWheel(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrWheelData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.wheelTxt.myTxt.text = item
            self.wheelTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectDriveSystem(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrDriveData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.driveTxt.myTxt.text = item
            self.driveTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectEngineSize(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrEngineSize
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.engineTxt.myTxt.text = item
            self.engineTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectBodyCondition(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrBodyCondition
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.bodyConditionTxt.myTxt.text = item
            self.bodyConditionTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectInteriorColor(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = CAR_COLOR
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.interiorColorTxt.myTxt.text = item
            self.interiorColorTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCylinder(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["3", "4", "5", "6", "8", "10", "12"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cylinderTxt.myTxt.text = item
            self.cylinderTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectDoors(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = [getTranslate("2_doors"), getTranslate("3_doors"), getTranslate("4_doors"), getTranslate("4_plus_doors")]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.doorTxt.myTxt.text = item
            self.doorTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectHorsepower(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = [getTranslate("less_than_100"), getTranslate("100_200"), getTranslate("200_300"), getTranslate("300_400"), getTranslate("400_500"), getTranslate("500_600"), getTranslate("600_plus")]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.horsePowerTxt.myTxt.text = item
            self.horsePowerTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectWarranty(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = [getTranslate("yes"), getTranslate("no")]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.warrantyTxt.myTxt.text = item
            self.warrantyTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToCreateAuction(_ sender: Any) {
        self.view.endEditing(true)
        if selectedAuctionType.id == 1 && bodyTypeTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_body")
        }
        else if selectedAuctionType.id == 1 && countryTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_country")
        }
        else if selectedAuctionType.id == 1 && motorTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_motor")
        }
        else if selectedAuctionType.id == 1 && colorTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_color")
        }
        else if milageTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_milage")
        }
        else if mechanicalTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_mechanical")
        }
        else if selectedAuctionType.id == 2 && wheelTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_wheel")
        }
        else if selectedAuctionType.id == 2 && driveTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_drive")
        }
        else if selectedAuctionType.id == 2 && engineTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_engine")
        }
        else if bodyConditionTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_body_condition")
        }
        else if selectedAuctionType.id == 3 && boatLengthTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_boat_length")
        }
        else if selectedAuctionType.id == 3 && boatAgeTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_boart_age")
        }
        else if selectedAuctionType.id == 3 && boatWarrantyTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_boat_warranty")
        }
        else if selectedAuctionType.id == 4 && interiorColorTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_interiour_color")
        }
        else if selectedAuctionType.id == 4 && cylinderTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_cylinder")
        }
        else if (selectedAuctionType.id == 1 || selectedAuctionType.id == 4) && doorTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_door")
        }
        else if (selectedAuctionType.id == 1 || selectedAuctionType.id == 4) && horsePowerTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_horsepower")
        }
        else if (selectedAuctionType.id == 1 || selectedAuctionType.id == 4) && warrantyTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_auction_warranty")
        }
        else if descTxtView.text?.trimmed == "" {
            displayToast("enter_auction_desc")
        }
        else if !termsCheckBoxBtn.isSelected {
            displayToast("agree_auction_terms")
        }
        else{
            if selectedAuctionType.id == 1 {
                param["bodytype"] = bodyTypeTxt.myTxt.text
                param["motorno"] = motorTxt.myTxt.text
                param["extcolor"] = colorTxt.myTxt.text
                param["interior_color"] = interiorColorTxt.myTxt.text
                param["no_of_cylinder"] = cylinderTxt.myTxt.text
                param["doors"] = doorTxt.myTxt.text
                param["horsepower"] = horsePowerTxt.myTxt.text
                param["warranty"] = warrantyTxt.myTxt.text
            }
            else {
                
                if selectedAuctionType.id == 2 {
                    param["wheels"] = wheelTxt.myTxt.text
                    param["drive_system"] = driveTxt.myTxt.text
                    param["engine_size"] = engineTxt.myTxt.text
                }
                else if selectedAuctionType.id == 3 {
                    param["auction_boat_length"] = boatLengthTxt.myTxt.text
                    param["auction_age"] = boatAgeTxt.myTxt.text
                    param["warranty"] = boatWarrantyTxt.myTxt.text
                }
                else if selectedAuctionType.id == 4 {
                    param["engineno"] = motorTxt.myTxt.text
                    param["extcolor"] = colorTxt.myTxt.text
                    param["interior_color"] = interiorColorTxt.myTxt.text
                    param["no_of_cylinder"] = cylinderTxt.myTxt.text
                    param["doors"] = doorTxt.myTxt.text
                    param["horsepower"] = horsePowerTxt.myTxt.text
                    param["warranty"] = warrantyTxt.myTxt.text
                }
            }
            param["mechanical"] = mechanicalTxt.myTxt.text
            param["body_condition"] = bodyConditionTxt.myTxt.text
            param["millage"] = milageTxt.myTxt.text
            param["country"] = selectedCountry.countryid
            param["country_name"] = countryTxt.myTxt.text
            
            param["desc"] = descTxtView.text
            param["auction_lat"] = latitudeTxt.myTxt.text
            param["auction_long"] = longitudeTxt.myTxt.text
            param["auction_address"] = addressTxt.myTxt.text
            param["auction_terms"] = ""//termsTxtView.text
            self.saveToDraft()
        }
    }
    
    func saveToDraft() {
        param["categories_name"] = nil
        param["childcat_name"] = nil
        param["country_name"] = nil
        param["auto_check_upload_path"] = nil
        if myAuction.auctionid == "" {
            param["auctionid"] = 0
        }else{
            param["auctionid"] = myAuction.auctionid
        }
        printData(param)
        
        if arrImgData.count > 0 {
            uploadAllImages(0)
        }else{
            serviceCallToPostAuction()
        }
    }
    
    func uploadAllImages(_ index : Int)
    {
        APIManager.shared.serviceCallToUploadAuctionPicture(arrImgData[index]) { (mediaid) in
            self.arrMediaData.append(mediaid)
            if self.arrImgData.count > (index + 1) {
                self.uploadAllImages(index+1)
            }
            else{
                self.param["mediaid"] = self.arrMediaData
                self.serviceCallToPostAuction()
            }
        }
    }
    
    func serviceCallToPostAuction()
    {
        APIManager.shared.serviceCallToPostAuction(param) { (code, auctionid, data) in
            if code == 100 {
                if AppModel.shared.AUCTION_DATA[String(self.selectedAuctionType.id)] != nil {
                    AppModel.shared.AUCTION_DATA[String(self.selectedAuctionType.id)] = [AuctionModel]()
                }
                
                AppDelegate().sharedDelegate().serviceCallToDecreseLeftAuction()
                showAlert("success_title", message: getTranslate("success_auction_message")) {
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_HOME), object: nil)
                }
            }
            else{
//                self.myAuction = AuctionModel.init(dict: self.param)
//                self.myAuction.auctionid = String(auctionid)
                showAlert("success_title", message: getTranslate("save_auction_draft_message")) {
                    let vc : PostAuctionDetailVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostAuctionDetailVC") as! PostAuctionDetailVC
                    vc.myAuction = AuctionModel.init(dict: data)
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func serviceCallToRemoveImage()
    {
        for temp in self.myAuction.removePicture {
            APIManager.shared.serviceCallToRemoveImage(["mediaid":temp]) {
                
            }
        }
    }
    
    @IBAction func clickToSelectBodyType(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrBodyData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.bodyTypeTxt.myTxt.text = item
            self.bodyTypeTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCountry(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCountryData {
            arrData.append(temp.country_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.countryTxt.myTxt.text = item
            self.countryTxt.setTextFieldValue()
            self.selectedCountry = self.arrCountryData[index]
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectColor(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = CAR_COLOR
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.colorTxt.myTxt.text = item
            self.colorTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectBoatLength(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = BOAT_LENGTH
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.boatLengthTxt.myTxt.text = ""
            }else{
                self.boatLengthTxt.myTxt.text = item
                self.boatLengthTxt.setTextFieldValue()
            }
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectBoatAge(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = BOAT_AGE
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.boatAgeTxt.myTxt.text = ""
            }else{
                self.boatAgeTxt.myTxt.text = item
                self.boatAgeTxt.setTextFieldValue()
            }
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectBoatWarranty(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = BOAT_WARRANTY
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.boatWarrantyTxt.myTxt.text = ""
            }else{
                self.boatWarrantyTxt.myTxt.text = item
                self.boatWarrantyTxt.setTextFieldValue()
            }
        }
        dropDown.show()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let count = textView.text.length() + (text.length() - range.length)
        if count <= 500 {
            descCountLbl.text = String(count) + "/500"
        }
        else{
            return false
        }
        return true
    }
    
    func updateLocationAddress(_ lat: Double, _ lng: Double, _ address: String) {
        latitudeTxt.myTxt.text = String(lat)
        longitudeTxt.myTxt.text = String(lng)
        addressTxt.myTxt.text = address
    }
    
    func setupAuctionData(_ auctionid : String)
    {
        
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

extension PostAuctionFeaturesVC: GMSAutocompleteViewControllerDelegate {

    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.primaryTextColor = BlackColor
        autocompleteController.secondaryTextColor = DarkGrayColor
        autocompleteController.tableCellSeparatorColor = DarkGrayColor
        autocompleteController.tableCellBackgroundColor = WhiteColor
      
        // Specify the place data types to return.
        autocompleteController.placeFields = GMSPlaceField(rawValue: GMSPlaceField.all.rawValue)!

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        latitudeTxt.myTxt.text = String(place.coordinate.latitude)
        longitudeTxt.myTxt.text = String(place.coordinate.longitude)
        addressTxt.myTxt.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        printData("Error: ", error.localizedDescription)
    }
 
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
