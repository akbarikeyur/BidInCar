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
    @IBOutlet weak var buildingNameTxt: FloatingTextfiledView!
    @IBOutlet weak var flatNoTxt: FloatingTextfiledView!
    @IBOutlet weak var poBoxTxt: FloatingTextfiledView!
    @IBOutlet weak var cityTxt: FloatingTextfiledView!
    @IBOutlet weak var countryTxt: FloatingTextfiledView!
    @IBOutlet weak var countryCodeTxt: FloatingTextfiledView!
    @IBOutlet weak var phoneTxt: FloatingTextfiledView!
    @IBOutlet weak var passwordTxt: FloatingTextfiledView!
    @IBOutlet weak var confirmPasswordTxt: FloatingTextfiledView!
    @IBOutlet weak var pwdImg1: UIImageView!
    @IBOutlet weak var pwdImg2: UIImageView!
    @IBOutlet weak var pwdImg3: UIImageView!
    @IBOutlet weak var pwdImg4: UIImageView!
    
    @IBOutlet weak var buyerBtn: Button!
    @IBOutlet weak var sellerBtn: Button!
    @IBOutlet weak var individualBtn: Button!
    @IBOutlet weak var companyBtn: Button!
    @IBOutlet weak var companyDetailView: UIView!
    
    @IBOutlet weak var companyNameTxt: FloatingTextfiledView!
    @IBOutlet weak var companyCountryCodeTxt: FloatingTextfiledView!
    @IBOutlet weak var countryFlagBtn: UIButton!
    @IBOutlet weak var companyPhoneTxt: FloatingTextfiledView!
    @IBOutlet weak var companyAddressTxt: FloatingTextfiledView!
    @IBOutlet weak var companyBuildingTxt: FloatingTextfiledView!
    @IBOutlet weak var companySuitNoTxt: FloatingTextfiledView!
    @IBOutlet weak var companyPoBoxTxt: FloatingTextfiledView!
    
    @IBOutlet weak var signinLbl: Label!
    
    var isFromLogin : Bool = false
    var arrCountryData : [CountryModel] = getCountryData()
    var arrCityData : [CityModel] = [CityModel]()
    var selectedCountry = CountryModel.init()
    var selectedCity = CityModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUIDesigning()
    }
    
    func setUIDesigning()
    {
        emailTxt.myTxt.keyboardType = .emailAddress
        flatNoTxt.myTxt.keyboardType = .numbersAndPunctuation
        phoneTxt.myTxt.keyboardType = .phonePad
        companyCountryCodeTxt.myTxt.keyboardType = .numbersAndPunctuation
        companyPhoneTxt.myTxt.keyboardType = .phonePad
        companySuitNoTxt.myTxt.keyboardType = .numbersAndPunctuation
        
        passwordTxt.myTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTxt.myTxt.isSecureTextEntry = true
        confirmPasswordTxt.myTxt.isSecureTextEntry = true
        updateStrongPasswordValue()
        
        signinLbl.attributedText = attributedStringWithColor(signinLbl.text!, ["Sign in"], color: PurpleColor, font: nil)
        companyDetailView.isHidden = true
        resetButton()
        individualBtn.isHidden = true
        companyBtn.isHidden = true
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let index = arrCountryData.firstIndex { (temp) -> Bool in
                temp.sortname == countryCode
            }
            if index != nil {
                selectedCountry = arrCountryData[index!]
                self.countryTxt.myTxt.text = self.selectedCountry.country_name
                setButtonImage(countryFlagBtn, selectedCountry.flag)
                countryCodeTxt.myTxt.text = selectedCountry.sortname
                self.getCityData()
            }
        }
        clickToSelectAccountType(buyerBtn)
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
            self.selectedCountry = self.arrCountryData[index]
            setButtonImage(self.countryFlagBtn, self.selectedCountry.flag)
            self.countryCodeTxt.myTxt.text = self.selectedCountry.sortname
            self.getCityData()
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCountryCode(_ sender: UIButton) {
        self.view.endEditing(true)
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
            self.companyCountryCodeTxt.myTxt.text = item
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCity(_ sender: UIButton) {
        self.view.endEditing(true)
        if selectedCountry.countryid == "" {
            displayToast("Please select country first.")
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
            self.selectedCity = self.arrCityData[index]
        }
        dropDown.show()
    }
    
    @IBAction func clickToBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectAccountType(_ sender: UIButton) {
        resetButton()
        if sender == buyerBtn {
            buyerBtn.isSelected = true
            companyDetailView.isHidden = true
            individualBtn.isHidden = true
            companyBtn.isHidden = true
        }else if sender == sellerBtn {
            sellerBtn.isSelected = true
            companyDetailView.isHidden = true
            individualBtn.isHidden = false
            companyBtn.isHidden = false
        }
        else if sender == individualBtn {
            sellerBtn.isSelected = true
            individualBtn.isSelected = true
            companyDetailView.isHidden = true
        }else if sender == companyBtn {
            sellerBtn.isSelected = true
            companyBtn.isSelected = true
            companyDetailView.isHidden = false
        }
    }
    
    func resetButton()
    {
        buyerBtn.isSelected = false
        sellerBtn.isSelected = false
        individualBtn.isSelected = false
        companyBtn.isSelected = false
    }
    
    @IBAction func clickToLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        if isFromLogin {
            self.navigationController?.popViewController(animated: true)
        }else{
            let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
        else if addressTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_address")
        }
        else if buildingNameTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_building")
        }
        else if flatNoTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_flat_number")
        }
        else if poBoxTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_po_box")
        }
        else if cityTxt.myTxt.text?.trimmed == "" {
            displayToast("select_city")
        }
        else if countryTxt.myTxt.text?.trimmed == "" {
            displayToast("select_country")
        }
        else if phoneTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_phone")
        }
        else if passwordTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_password")
        }
        else if confirmPasswordTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_confirm_password")
        }
        else if passwordTxt.myTxt.text != confirmPasswordTxt.myTxt.text {
            displayToast("invalid_match_password")
        }
        else if !buyerBtn.isSelected && !sellerBtn.isSelected {
            displayToast("select_account_type")
        }
        else if sellerBtn.isSelected && !individualBtn.isSelected && !companyBtn.isSelected {
            displayToast("select_account_type")
        }
        else if companyBtn.isSelected && !checkCompanyValidation() {
            //check validation
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
            param["city"] = selectedCity.cityid
            param["phone_number"] = phoneTxt.myTxt.text
            param["password"] = passwordTxt.myTxt.text
            param["confirm_password"] = confirmPasswordTxt.myTxt.text
            
//            param["user_accountype"] = ""
//            param["user_postingtype"] = ""
//            param["company_name"] = ""
//            param["company_email"] = ""
//            param["company_address"] = ""
//            param["company_phone"] = ""
            
            if buyerBtn.isSelected {
                param["user_accountype"] = "buyer"
                param["user_postingtype"] = "individual"
            }
            else if sellerBtn.isSelected {
                param["user_accountype"] = "seller"
                if individualBtn.isSelected {
                    param["user_postingtype"] = "individual"
                }
                else if companyBtn.isSelected {
                    param["user_postingtype"] = "company"
                    param["company_name"] = companyNameTxt.myTxt.text
                    param["company_email"] = emailTxt.myTxt.text
                    param["company_address"] = companyAddressTxt.myTxt.text
                    param["company_phone"] = companyPhoneTxt.myTxt.text
                }
            }
            
            print(param)
            APIManager.shared.serviceCallToUserSignup(param) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func checkCompanyValidation() -> Bool
    {
        if companyNameTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_name")
            return false
        }
        else if companyCountryCodeTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_code")
            return false
        }
        else if companyPhoneTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_phone")
            return false
        }
        else if companyAddressTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_address")
            return false
        }
        else if companyBuildingTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_building")
            return false
        }
        else if companySuitNoTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_company_suit")
            return false
        }
        else if companyPoBoxTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_po_box")
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
                self.arrCityData.append(CityModel.init(dict: temp))
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
