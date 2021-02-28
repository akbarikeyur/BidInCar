//
//  ProfileVC.swift
//  BidInCar
//
//  Created by Keyur on 19/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

struct PROFILE {
    static let FNAME = getTranslate("profile_first_name")
    static let LNAME = getTranslate("profile_last_name")
    static let EMAIL = getTranslate("profile_email_id")
    static let ADDRESS = getTranslate("profile_street_address")
    static let BUILDING = getTranslate("profile_building_name")
    
    static let FLAT = getTranslate("profile_flat_number")
    static let PO = getTranslate("profile_po_box")
    static let CITY = getTranslate("profile_city")
    static let COUNTRY = getTranslate("profile_country")
    static let COUNTRY_CODE = getTranslate("profile_country_code")
    static let PHONE = getTranslate("profile_phone_number")
    static let SAVE = getTranslate("profile_auto_save")
    
    static let COMPANY_NAME = getTranslate("profile_company_name")
    static let COMPANY_EMAIL = getTranslate("profile_company_email")
    static let COMPANY_PHONE = getTranslate("profile_company_phone")
    static let COMPANY_ADDRESS = getTranslate("profile_company_address")
}

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomProfileDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var usernameLbl: Label!
    @IBOutlet weak var addressLbl: Label!
    @IBOutlet weak var constraintHeightAddress: NSLayoutConstraint!
    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var editBtn: UIButton!
    
    var arrUserDetail : [[String : Any]] = [[String : Any]]()
    var selectedImage : UIImage? = nil
    var isEditProfile = false
    var arrCountryData : [CountryModel] = getCountryData()
    var arrCityData : [CityModel] = [CityModel]()
    var selectedCountryId = ""
    var selectedCountryCode = ""
    var selectedCountryCodeId = ""
    var selectedCityId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(setUserDetail), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        
        tblView.register(UINib.init(nibName: "CustomProfileTVC", bundle: nil), forCellReuseIdentifier: "CustomProfileTVC")
        
        setUserDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        serviceCallToUpdateProfile()
    }
    
    @objc func setUserDetail()
    {
        setButtonBackgroundImage(profilePicBtn, AppModel.shared.currentUser.profile_pic, IMAGE.USER_PLACEHOLDER)
        
        usernameLbl.text = AppModel.shared.currentUser.user_name + " " + AppModel.shared.currentUser.user_lastname
        var headerFrame = headerView.frame
        addressLbl.text = ""
        addressLbl.numberOfLines = 0
        if AppModel.shared.currentUser.user_flatnumber != "" {
            addressLbl.text = AppModel.shared.currentUser.user_flatnumber
        }
        if AppModel.shared.currentUser.user_buildingname != "" {
            if addressLbl.text != "" {
                addressLbl.text = addressLbl.text! + " "
            }
            addressLbl.text = addressLbl.text! + AppModel.shared.currentUser.user_buildingname
        }
        if AppModel.shared.currentUser.user_streetaddress != "" {
            if addressLbl.text != "" {
                addressLbl.text = addressLbl.text! + " "
            }
            addressLbl.text = addressLbl.text! + AppModel.shared.currentUser.user_streetaddress
        }
        if AppModel.shared.currentUser.user_pobox != "" {
            if addressLbl.text != "" {
                addressLbl.text = addressLbl.text! + " "
            }
            addressLbl.text = addressLbl.text! + AppModel.shared.currentUser.user_pobox
        }
        if addressLbl.text != "" {
            addressLbl.text = getTranslate("address_colon") + addressLbl.text!
        }
        addressLbl.text = addressLbl.text! + "\n" + getTranslate("type_colon") + (isUserBuyer() ? getTranslate("type_buyer") : getTranslate("type_seller"))
        constraintHeightAddress.constant = addressLbl.getHeight()
        headerFrame.size.width = SCREEN.WIDTH
        headerFrame.size.height = headerFrame.size.height - 34 + constraintHeightAddress.constant
        headerView.frame = headerFrame
        
        arrUserDetail = [[String : Any]]()
        var dict : [String : Any] = [String : Any]()
        dict["title"] = PROFILE.FNAME
        dict["value"] = AppModel.shared.currentUser.user_name
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.LNAME
        dict["value"] = AppModel.shared.currentUser.user_lastname
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.EMAIL
        dict["value"] = AppModel.shared.currentUser.user_email
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.ADDRESS
        dict["value"] = AppModel.shared.currentUser.user_streetaddress
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.BUILDING
        dict["value"] = AppModel.shared.currentUser.user_buildingname
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.FLAT
        dict["value"] = AppModel.shared.currentUser.user_flatnumber
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.PO
        dict["value"] = AppModel.shared.currentUser.user_pobox
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.COUNTRY
        dict["value"] = AppModel.shared.currentUser.country_name
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.CITY
        dict["value"] = AppModel.shared.currentUser.city_name
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.COUNTRY_CODE
        dict["value"] = "+" + AppModel.shared.currentUser.phone_countrycode
        arrUserDetail.append(dict)
        dict = [String : Any]()
        dict["title"] = PROFILE.PHONE
        dict["value"] = AppModel.shared.currentUser.user_phonenumber
        arrUserDetail.append(dict)
        
        if AppModel.shared.currentUser.user_postingtype == "company" {
            dict = [String : Any]()
            dict["title"] = PROFILE.COMPANY_NAME
            dict["value"] = AppModel.shared.currentUser.user_company.company_name
            arrUserDetail.append(dict)
            dict = [String : Any]()
            dict["title"] = PROFILE.COMPANY_EMAIL
            dict["value"] = AppModel.shared.currentUser.user_company.company_email
            arrUserDetail.append(dict)
            dict = [String : Any]()
            dict["title"] = PROFILE.COMPANY_PHONE
            dict["value"] = AppModel.shared.currentUser.user_company.company_phone
            arrUserDetail.append(dict)
            dict = [String : Any]()
            dict["title"] = PROFILE.COMPANY_ADDRESS
            dict["value"] = AppModel.shared.currentUser.user_company.company_address
            arrUserDetail.append(dict)
        }
        
        dict = [String : Any]()
        dict["title"] = PROFILE.SAVE
        dict["value"] = ""
        arrUserDetail.append(dict)
        tblView.tableHeaderView = headerView
        tblView.reloadData()
        
        selectedCountryId = AppModel.shared.currentUser.user_countryid
        selectedCityId = AppModel.shared.currentUser.user_cityid
        selectedCountryCode = AppModel.shared.currentUser.phone_countrycode
        selectedCountryCodeId = AppModel.shared.currentUser.phone_countrycodeid
        getCityData(AppModel.shared.currentUser.user_countryid)
    }
    
    //MARK:- Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomProfileTVC = tblView.dequeueReusableCell(withIdentifier: "CustomProfileTVC") as! CustomProfileTVC
        cell.delegate = self
        cell.valueTxt.text = ""
        cell.valueTxt.isHidden = true
        cell.valueLbl.text = ""
        cell.valueLbl.isHidden = true
        cell.valueBtn.isHidden = true
        cell.titleLbl.textColor = LightGrayColor
        cell.titleLbl.text = arrUserDetail[indexPath.row]["title"] as? String ?? ""
        if cell.titleLbl.text == PROFILE.EMAIL || cell.titleLbl.text == PROFILE.COUNTRY_CODE || cell.titleLbl.text == PROFILE.PHONE || cell.titleLbl.text == PROFILE.COMPANY_PHONE   {
            cell.valueTxt.isUserInteractionEnabled = false
        }else{
            cell.valueTxt.isUserInteractionEnabled = true
        }
        if cell.titleLbl.text != PROFILE.SAVE {
            if !isEditProfile {
                cell.valueLbl.text = arrUserDetail[indexPath.row]["value"] as? String ?? ""
                cell.valueLbl.textColor = LightGrayColor
                cell.valueLbl.isHidden = false
            }else{
                cell.valueTxt.isHidden = false
                cell.valueTxt.text = arrUserDetail[indexPath.row]["value"] as? String ?? ""
                
                if cell.titleLbl.text == PROFILE.CITY {
//                    cell.valueBtn.isHidden = false
//                    cell.valueBtn.addTarget(self, action: #selector(clickToCityDropdown(_:)), for: .touchUpInside)
                }
                else if cell.titleLbl.text == PROFILE.COUNTRY {
                    cell.valueBtn.isHidden = false
                    cell.valueBtn.addTarget(self, action: #selector(clickToCountryDropdown(_:)), for: .touchUpInside)
                }
                else if cell.titleLbl.text == PROFILE.COUNTRY_CODE {
                    cell.valueBtn.isHidden = false
                    cell.valueBtn.addTarget(self, action: #selector(clickToCountryCodeDropdown(_:)), for: .touchUpInside)
                }
            }
            cell.seperatorImg.isHidden = false
        }else{
            cell.valueLbl.text = ""
            cell.titleLbl.textColor = GreenColor
            cell.seperatorImg.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:- Button clickc event
    @IBAction func clickToEditProfile(_ sender: Any) {
        editBtn.isHidden = true
        isEditProfile = !isEditProfile
        tblView.reloadData()
    }
    
    @IBAction func clickToUploadImage(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name.init("NOTIFICATION_UPLOAD_IMAGE"), object: nil)
    }
    
    func selectedImage(_ choosenImage: UIImage) {
        selectedImage = choosenImage
        profilePicBtn.setBackgroundImage(selectedImage, for: .normal)
        if !isUserLogin() {
            return
        }
        APIManager.shared.serviceCallToUploadProfilePicture(selectedImage!, AppModel.shared.currentUser.userid) {
            
        }
    }
    
    func updateProfileData(_ title: String, _ value: String) {
        let index = arrUserDetail.firstIndex { (temp) -> Bool in
            (temp["title"] as! String) == title
        }
        if index != nil {
            arrUserDetail[index!]["value"] = value
        }
    }
    
    @IBAction func clickToCountryDropdown(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCountryData {
            arrData.append(temp.country_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (dropIndex: Int, item: String) in
            let index1 = self.arrUserDetail.firstIndex { (temp) -> Bool in
                (temp["title"] as! String) == PROFILE.COUNTRY
            }
            if index1 != nil {
                self.arrUserDetail[index1!]["value"] = item
            }
            let index3 = self.arrUserDetail.firstIndex { (temp) -> Bool in
                (temp["title"] as! String) == PROFILE.CITY
            }
            if index3 != nil {
                self.arrUserDetail[index3!]["value"] = ""
            }
            self.tblView.reloadData()
            self.selectedCountryId = self.arrCountryData[dropIndex].countryid
            self.getCityData(self.arrCountryData[dropIndex].countryid)
        }
        dropDown.show()
    }
    
    @IBAction func clickToCountryCodeDropdown(_ sender: UIButton) {
        self.view.endEditing(true)
        /*
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCountryData {
            arrData.append(temp.country_name + " (+" + temp.phonecode + ")")
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (dropIndex: Int, item: String) in
            let index2 = self.arrUserDetail.firstIndex { (temp) -> Bool in
                (temp["title"] as! String) == PROFILE.COUNTRY_CODE
            }
            if index2 != nil {
                self.arrUserDetail[index2!]["value"] = "+" + self.arrCountryData[dropIndex].phonecode
            }
            self.tblView.reloadData()
            self.selectedCountryCode = self.arrCountryData[dropIndex].phonecode
            self.selectedCountryCodeId = self.arrCountryData[dropIndex].countryid
        }
        dropDown.show()
         */
    }
    
    @IBAction func clickToCityDropdown(_ sender: UIButton) {
        self.view.endEditing(true)
        showLoader()
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCityData {
            arrData.append(temp.city_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (dropIndex: Int, item: String) in
            let index = self.arrUserDetail.firstIndex { (temp) -> Bool in
                (temp["title"] as! String) == PROFILE.CITY
            }
            if index != nil {
                self.arrUserDetail[index!]["value"] = item
                self.selectedCityId = self.arrCityData[dropIndex].cityid
            }
            self.tblView.reloadData()
        }
        dropDown.show()
        removeLoader()
    }
    
    func getCityData(_ countryid : String)
    {
        APIManager.shared.serviceCallToGetCityList(countryid) { (data) in
            self.arrCityData = [CityModel]()
            for temp in data {
                let tempCity = CityModel.init(dict: temp)
                if tempCity.country_id == countryid {
                    self.arrCityData.append(tempCity)
                }
            }
            if self.arrCityData.count > 0 {
                self.arrCityData = self.arrCityData.sorted { (temp1 : CityModel, temp2 : CityModel) -> Bool in
                    return temp1.city_name < temp2.city_name
                }
            }
        }
    }
    
    func serviceCallToUpdateProfile()
    {
        if !isUserLogin() {
            return
        }
        if !isEditProfile {
            return
        }
        editBtn.isHidden = false
        isEditProfile = false
        tblView.reloadData()
        
        var param : [String : Any] = [String : Any]()
        for temp in arrUserDetail {
            switch (temp["title"] as! String) {
            case PROFILE.FNAME:
                param["user_name"] = temp["value"]
                break
            case PROFILE.LNAME:
                param["user_lastname"] = temp["value"]
                break
            case PROFILE.EMAIL:
                param["user_email"] = temp["value"]
                break
            case PROFILE.ADDRESS:
                param["user_streetaddress"] = temp["value"]
                break
            case PROFILE.BUILDING:
                param["user_buildingname"] = temp["value"]
                break
            case PROFILE.FLAT:
                param["user_flatnumber"] = temp["value"]
                break
            case PROFILE.PO:
                param["user_pobox"] = temp["value"]
                break
            case PROFILE.COUNTRY:
                param["user_countryid"] = selectedCountryId
                break
            case PROFILE.COUNTRY_CODE:
                param["phone_countrycode"] = selectedCountryCode
                param["phone_countrycodeid"] = selectedCountryCodeId
                break
            case PROFILE.CITY:
                param["city"] = temp["value"]
                break
            case PROFILE.PHONE:
                param["user_phonenumber"] = temp["value"]
                break
            default:
                break
            }
        }
        
        if AppModel.shared.currentUser.user_postingtype == "company" {
            for temp in arrUserDetail {
                switch (temp["title"] as! String)
                {
                    case PROFILE.COMPANY_NAME:
                        param["company_name"] = temp["value"]
                        break
                    case PROFILE.COMPANY_EMAIL:
                        param["company_email"] = temp["value"]
                        break
                    case PROFILE.COMPANY_ADDRESS:
                        param["company_address"] = temp["value"]
                        break
                    case PROFILE.COMPANY_PHONE:
                        param["company_phone"] = temp["value"]
                        break
                    default:
                        break
                }
            }
        }
        param["user_postingtype"] = AppModel.shared.currentUser.user_postingtype
        param["usernotification"] = AppModel.shared.currentUser.notification
        param["userid"] = AppModel.shared.currentUser.userid
        param["lang"] = "eng"
        printData(param)
        APIManager.shared.serviceCallToUpdateUserProfile(param)
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
