//
//  SignupVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

class SignupVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fnameTxt: FloatingTextfiledView!
    @IBOutlet weak var lnameTxt: FloatingTextfiledView!
    @IBOutlet weak var emailTxt: FloatingTextfiledView!
    @IBOutlet weak var addressTxt: FloatingTextfiledView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var buildingNameTxt: FloatingTextfiledView!
    @IBOutlet weak var flatNoTxt: FloatingTextfiledView!
    @IBOutlet weak var poBoxTxt: FloatingTextfiledView!
    @IBOutlet weak var cityTxt: FloatingTextfiledView!
    
    @IBOutlet weak var countryTxt: FloatingTextfiledView!
    @IBOutlet weak var countryCodeTxt: FloatingTextfiledView!
    @IBOutlet weak var phoneTxt: FloatingTextfiledView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTxt: FloatingTextfiledView!
    @IBOutlet weak var confirmPasswordTxt: FloatingTextfiledView!
    @IBOutlet weak var pwdImg1: UIImageView!
    @IBOutlet weak var pwdImg2: UIImageView!
    @IBOutlet weak var pwdImg3: UIImageView!
    @IBOutlet weak var pwdImg4: UIImageView!
    
    @IBOutlet weak var buyerBtn: Button!
    @IBOutlet weak var sellerBtn: Button!
    @IBOutlet weak var individualView: UIView!
    @IBOutlet weak var individualBtn: Button!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyBtn: Button!
    @IBOutlet weak var companyDetailView: UIView!
    
    @IBOutlet weak var companyNameTxt: FloatingTextfiledView!
    @IBOutlet weak var companyCountryCodeTxt: FloatingTextfiledView!
    @IBOutlet weak var countryFlagBtn: UIButton!
    @IBOutlet weak var companyPhoneTxt: FloatingTextfiledView!
    @IBOutlet weak var companyAddressTxt: FloatingTextfiledView!
    @IBOutlet weak var companyEmailTxt: FloatingTextfiledView!
    
    @IBOutlet weak var termsBtn: Button!
    @IBOutlet weak var signupBtn: Button!
    
    @IBOutlet weak var signinLbl: Label!
    
    var isFromLogin : Bool = false
    var arrCountryData : [CountryModel] = getCountryData()
    var arrCityData : [CityModel] = [CityModel]()
    var selectedCountry = CountryModel.init()
    var selectedCountryCode = CountryModel.init()
    var selectedCity = CityModel.init()
    var isSocial = false
    var socialDict = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if getCountryData().count == 0 {
            APIManager.shared.serviceCallToGetCountryList { (data) in
                setCountryData(data)
                self.arrCountryData = getCountryData()
            }
        }
        if isSocial {
            passwordView.isHidden = true
            signupBtn.setTitle("SAVE", for: .normal)
        }else{
            passwordView.isHidden = false
            signupBtn.setTitle("SIGN UP", for: .normal)
        }
        setUIDesigning()
        /*
        if PLATFORM.isSimulator {
            fnameTxt.myTxt.text = "Test"
            lnameTxt.myTxt.text = "Buyer"
            emailTxt.myTxt.text = "Testbuyer@abc.com"
            addressTxt.myTxt.text = "Test add"
            buildingNameTxt.myTxt.text = "build"
            flatNoTxt.myTxt.text = "34"
            poBoxTxt.myTxt.text = "3434"
            cityTxt.myTxt.text = "Surat"
            phoneTxt.myTxt.text = "9876543214"
            passwordTxt.myTxt.text = "qqqqqq"
            confirmPasswordTxt.myTxt.text = "qqqqqq"
        }
        */
    }
    
    func setUIDesigning()
    {
        addressView.isHidden = true
        emailTxt.myTxt.keyboardType = .emailAddress
        flatNoTxt.myTxt.keyboardType = .numbersAndPunctuation
        phoneTxt.myTxt.keyboardType = .phonePad
        companyCountryCodeTxt.myTxt.keyboardType = .numbersAndPunctuation
        companyPhoneTxt.myTxt.keyboardType = .phonePad
        companyEmailTxt.myTxt.keyboardType = .emailAddress
        
        passwordTxt.myTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTxt.myTxt.isSecureTextEntry = true
        confirmPasswordTxt.myTxt.isSecureTextEntry = true
        updateStrongPasswordValue()
        
        signinLbl.text = getTranslate("already_member_signin")
        signinLbl.attributedText = attributedStringWithColor(signinLbl.text!, [getTranslate("signin_title")], color: PurpleColor, font: nil)
        companyDetailView.isHidden = true
        individualView.isHidden = true
        companyView.isHidden = true
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let index = arrCountryData.firstIndex { (temp) -> Bool in
                temp.sortname == countryCode
            }
            if index != nil {
                selectedCountry = arrCountryData[index!]
                selectedCountryCode = selectedCountry
                self.countryTxt.myTxt.text = self.selectedCountry.country_name
                self.countryTxt.setTextFieldValue()
                setButtonImage(countryFlagBtn, selectedCountryCode.flag)
                countryCodeTxt.myTxt.text = self.selectedCountryCode.country_name + " - " + self.selectedCountryCode.phonecode
                self.countryCodeTxt.setTextFieldValue()
                self.getCityData()
            }
        }
        clickToSelectAccountType(buyerBtn)
        
        if isSocial {
            emailTxt.myTxt.text = AppModel.shared.getStringValue(socialDict, "email")
            if emailTxt.myTxt.text != "" {
                emailTxt.isUserInteractionEnabled = false
            }else{
                emailTxt.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK:- Button click event
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
//            if self.selectedCountryCode.countryid == "" {
                self.selectedCountryCode = self.selectedCountry
                setButtonImage(self.countryFlagBtn, self.selectedCountryCode.flag)
                self.countryCodeTxt.myTxt.text = self.selectedCountryCode.country_name + " - " + self.selectedCountryCode.phonecode
                self.countryCodeTxt.setTextFieldValue()
//            }
//            self.getCityData()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCountryCode(_ sender: UIButton) {
        self.view.endEditing(true)
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCountryData {
            arrData.append(temp.country_name + " - " + temp.phonecode)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCountryCode = self.arrCountryData[index]
            setButtonImage(self.countryFlagBtn, self.selectedCountryCode.flag)
            self.countryCodeTxt.myTxt.text = self.selectedCountryCode.country_name + " - " + self.selectedCountryCode.phonecode
            self.countryCodeTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCompanyCountryCode(_ sender: UIButton) {
        self.view.endEditing(true)
        var arrData = [String]()
        for temp in arrCountryData {
            arrData.append(temp.phonecode)
        }
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.companyCountryCodeTxt.myTxt.text = "+" + item
            self.companyCountryCodeTxt.setTextFieldValue()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCity(_ sender: UIButton) {
        self.view.endEditing(true)
        if selectedCountry.countryid == "" {
            displayToast("select_country")
            return
        }
        let dropDown = DropDown()
        dropDown.anchorView = sender
        var arrData = [String]()
        for temp in arrCityData {
            arrData.append(temp.city_name)
        }
        dropDown.dataSource = arrData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cityTxt.myTxt.text = item
            self.cityTxt.setTextFieldValue()
            self.selectedCity = self.arrCityData[index]
        }
        dropDown.show()
    }
    
    @IBAction func clickToBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectAccountType(_ sender: UIButton) {
        individualBtn.isSelected = false
        companyBtn.isSelected = false
        if sender.tag == 1 {
            buyerBtn.isSelected = true
            sellerBtn.isSelected = false
            companyDetailView.isHidden = true
            individualView.isHidden = false
            companyView.isHidden = false
        }else if sender.tag == 2 {
            sellerBtn.isSelected = true
            buyerBtn.isSelected = false
            companyDetailView.isHidden = true
            individualView.isHidden = false
            companyView.isHidden = false
        }
        else if sender.tag == 3 {
            individualBtn.isSelected = true
            companyDetailView.isHidden = true
        }else if sender.tag == 4 {
            companyBtn.isSelected = true
            companyDetailView.isHidden = false
        }
    }
    
    @IBAction func clickToLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        addButtonEvent(EVENT.TITLE.LOGIN, EVENT.ACTION.LOGIN, String(describing: self))
        if isFromLogin {
            self.navigationController?.popViewController(animated: true)
        }else{
            let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func clickToAgree(_ sender: Any) {
        termsBtn.isSelected = !termsBtn.isSelected
    }
    
    @IBAction func clickToTermsCondition(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.TERMS, EVENT.ACTION.TERMS, String(describing: self))
        let vc : PrivacyPolicyVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        vc.isBackDisplay = true
        screenType = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        self.view.endEditing(true)
        if fnameTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_fname")
        }
        else if lnameTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_lname")
        }
        else if emailTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if !emailTxt.myTxt.text!.isValidEmail {
            displayToast("invalid_email")
        }
//        else if addressTxt.myTxt.text?.trimmed == "" {
//            displayToast("enter_address")
//        }
//        else if buildingNameTxt.myTxt.text?.trimmed == "" {
//            displayToast("enter_building")
//        }
//        else if flatNoTxt.myTxt.text?.trimmed == "" {
//            displayToast("enter_flat_number")
//        }
        else if poBoxTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_po_box")
        }
//        else if cityTxt.myTxt.text?.trimmed == "" {
//            displayToast("select_city")
//        }
        else if countryTxt.myTxt.text?.trimmed == "" {
            displayToast("select_country")
        }
        else if  selectedCountryCode.phonecode == "" {
            displayToast("enter_phone_code")
        }
        else if phoneTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_phone")
        }
        else if !isSocial && passwordTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_password")
        }
        else if !isSocial && confirmPasswordTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_confirm_password")
        }
        else if !isSocial && passwordTxt.myTxt.text != confirmPasswordTxt.myTxt.text {
            displayToast("invalid_match_password")
        }
        else if !buyerBtn.isSelected && !sellerBtn.isSelected {
            displayToast("select_account_type")
        }
        else if !individualBtn.isSelected && !companyBtn.isSelected {
            displayToast("select_account_type")
        }
        else if companyBtn.isSelected && !checkCompanyValidation() {
            //check validation
        }
        else if !termsBtn.isSelected {
            displayToast("agree_terms")
        }
        else{
            var param : [String : Any] = [String : Any]()
            param["firstname"] = fnameTxt.myTxt.text
            param["lastname"] = lnameTxt.myTxt.text
            param["email"] = emailTxt.myTxt.text
            param["address"] = addressTxt.myTxt.text
            param["buildingname"] = buildingNameTxt.myTxt.text
            param["flat_number"] = flatNoTxt.myTxt.text
            param["pobox"] = poBoxTxt.myTxt.text
            param["country"] = selectedCountry.countryid
            param["city"] = cityTxt.myTxt.text
            param["phone_countrycode"] = selectedCountryCode.phonecode
            param["phone_countrycodeid"] = selectedCountryCode.countryid
            if (phoneTxt.myTxt.text!.contains("+" + selectedCountryCode.phonecode)) {
                phoneTxt.myTxt.text = phoneTxt.myTxt.text?.replacingOccurrences(of: ("+" + selectedCountryCode.phonecode), with: "")
            }
            param["phone_number"] = phoneTxt.myTxt.text
            if isSocial {
                param["login_type"] = AppModel.shared.getStringValue(socialDict, "login_type")
                param["social_login_id"] = AppModel.shared.getStringValue(socialDict, "social_login_id")
            }else{
                param["password"] = passwordTxt.myTxt.text
                param["confirm_password"] = confirmPasswordTxt.myTxt.text
            }
            param["lang"] = "eng"
            
            if buyerBtn.isSelected {
                param["user_accountype"] = "buyer"
            }
            else if sellerBtn.isSelected {
                param["user_accountype"] = "seller"
            }
            
            if individualBtn.isSelected {
                param["user_postingtype"] = "individual"
            }
            else if companyBtn.isSelected {
                param["user_postingtype"] = "company"
                param["company_name"] = companyNameTxt.myTxt.text
                param["company_email"] = companyEmailTxt.myTxt.text
                param["company_address"] = companyAddressTxt.myTxt.text
                param["company_phone"] = companyPhoneTxt.myTxt.text
            }
            printData(param)
            LoginAPIManager.shared.serviceCallToUserSignup(param) {
                if AppModel.shared.currentUser.userid != "" {
                    let vc : VerificationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    vc.isFromSignup = true
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func checkCompanyValidation() -> Bool
    {
        if companyNameTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_name")
            return false
        }
//        else if companyCountryCodeTxt.myTxt.text?.trimmed == "" {
//            displayToast("enter_company_code")
//            return false
//        }
        else if companyPhoneTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_phone")
            return false
        }
        else if companyAddressTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_address")
            return false
        }
        else if companyEmailTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_email")
            return false
        }
        else if !companyEmailTxt.myTxt.text!.isValidEmail {
            displayToast("invalid_email")
            return false
        }
        return true
    }
    
    
    func updateStrongPasswordValue()
    {
        pwdImg1.backgroundColor = LightGrayColor
        pwdImg2.backgroundColor = LightGrayColor
        pwdImg3.backgroundColor = LightGrayColor
        pwdImg4.backgroundColor = LightGrayColor
        
        let value = (passwordTxt.myTxt.text?.checkPasswordStrength)!
        if value > 0 {
            pwdImg1.backgroundColor = GreenColor
        }
        if value > 1 {
            pwdImg2.backgroundColor = GreenColor
        }
        if value > 2 {
            pwdImg3.backgroundColor = GreenColor
        }
        if value > 3 {
            pwdImg4.backgroundColor = GreenColor
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == passwordTxt.myTxt {
            updateStrongPasswordValue()
        }
    }
    
    func getCityData()
    {
        APIManager.shared.serviceCallToGetCityList(selectedCountry.countryid) { (data) in
            self.arrCityData = [CityModel]()
            self.selectedCity = CityModel.init()
            for temp in data {
                let tempCity = CityModel.init(dict: temp)
                if tempCity.country_id == self.selectedCountry.countryid {
                    self.arrCityData.append(tempCity)
                }
            }
            if self.arrCityData.count > 0 {
                self.arrCityData = self.arrCityData.sorted { (temp1 : CityModel, temp2 : CityModel) -> Bool in
                    return temp1.city_name < temp2.city_name
                }
            }
            self.cityTxt.myTxt.text = ""
            self.selectedCity = CityModel.init()
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
