//
//  SelectPaymentMethodVC.swift
//  BidInCar
//
//  Created by Keyur on 23/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import DropDown

class SelectPaymentMethodVC: UIViewController, UITextFieldDelegate, PayPalPaymentDelegate {
    
    @IBOutlet weak var paymentTabView: UIView!
    @IBOutlet weak var visaView: View!
    @IBOutlet weak var visaBtn: UIButton!
    @IBOutlet weak var paypalView: View!
    @IBOutlet weak var paypalBtn: UIButton!
    @IBOutlet weak var bankView: View!
    @IBOutlet weak var bankBtn: Button!
    @IBOutlet weak var payTitleLbl: Label!
    
    @IBOutlet var bankContainerView: UIView!
    @IBOutlet weak var bankFullNameTxt: FloatingTextfiledView!
    @IBOutlet weak var bankAccountTitleTxt: FloatingTextfiledView!
    @IBOutlet weak var bankAccountNumberTxt: FloatingTextfiledView!
    @IBOutlet weak var bankIbanTxt: FloatingTextfiledView!
    @IBOutlet weak var bankSwiftCodeTxt: FloatingTextfiledView!
    @IBOutlet weak var bankBranchCodeTxt: FloatingTextfiledView!
    
    @IBOutlet var cardContainerView: UIView!
    @IBOutlet weak var cardNameTxt: FloatingTextfiledView!
    @IBOutlet weak var cardNumberTxt: FloatingTextfiledView!
    @IBOutlet weak var cardDateTxt: FloatingTextfiledView!
    @IBOutlet weak var cardCVVTxt: FloatingTextfiledView!
    @IBOutlet weak var cardYearTxt: FloatingTextfiledView!
    @IBOutlet weak var cardAgreementBtn: UIButton!
    @IBOutlet weak var primaryCardBtn: UIButton!
    
    @IBOutlet var paypalContainerView: UIView!
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var constraintHeightMainContainerView: NSLayoutConstraint!
    
    var selectedTab = 0
    var arrYearData = [String]()
    var selectedMonth = 0
    var payPalConfig = PayPalConfiguration()
    var isAddCardBank = false
    var paymentType = ""
    var paymentParam = [String : Any]()
    var amount = 0
    var isFromAuction : Bool = false
    var isFromProfile : Bool = false
    
    //Set environment connection.

    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var acceptCreditCards : Bool = true {
        didSet{
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardNumberTxt.myTxt.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        
        setUIDesigning()
    }
    
    func setUIDesigning()
    {
        cardYearTxt.trailingSpace.constant = 10
        cardCVVTxt.leftSpace.constant = 10
        bankSwiftCodeTxt.trailingSpace.constant = 10
        bankBranchCodeTxt.leftSpace.constant = 10
        
        cardNumberTxt.myTxt.keyboardType = .numberPad
        cardCVVTxt.myTxt.isSecureTextEntry = true
        cardCVVTxt.myTxt.keyboardType = .numberPad
        
        cardNameTxt.myTxt.autocapitalizationType = .allCharacters
        
        cardNumberTxt.myTxt.delegate = self
        cardCVVTxt.myTxt.delegate = self
        
        bankAccountNumberTxt.myTxt.keyboardType = .numberPad
        bankBranchCodeTxt.myTxt.keyboardType = .numberPad
        
        if isFromProfile {
            paymentTabView.isHidden = false
            switch selectedTab {
                case 0:
                    clickToSelectPaymentMethod(visaBtn)
                    break
                case 1:
                    clickToSelectPaymentMethod(paypalBtn)
                    break
                case 2:
                    clickToSelectPaymentMethod(bankBtn)
                    break
                default:
                    break
            }
        }else{
            paymentTabView.isHidden = true
            clickToSelectPaymentMethod(paypalBtn)
        }
        
        let year = Calendar.current.component(.year, from: Date())
        for i in 0...30{
            arrYearData.append(String(year + i))
        }
        
        setupPaypalConfiguration()
    }
    
    func setupPaypalConfiguration()
    {
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "Asif Issoufaly"
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    //MARK;- Button click event
    @IBAction func clickToSelectPaymentMethod(_ sender: UIButton) {
        self.view.endEditing(true)
        resetAllOption()
        sender.isSelected = !sender.isSelected
        if sender == visaBtn {
            selectedTab = 0
            visaView.backgroundColor = colorFromHex(hex: "EAEEF1")
            displaySubViewtoParentView(mainContainerView, subview: cardContainerView)
            constraintHeightMainContainerView.constant = 525
        }
        else if sender == paypalBtn {
            selectedTab = 1
            paypalView.backgroundColor = colorFromHex(hex: "EAEEF1")
            displaySubViewtoParentView(mainContainerView, subview: paypalContainerView)
            constraintHeightMainContainerView.constant = 260
        }
        else if sender == bankBtn {
            selectedTab = 2
            bankView.backgroundColor = YellowColor
            displaySubViewtoParentView(mainContainerView, subview: bankContainerView)
            constraintHeightMainContainerView.constant = 600
        }
        setPayButtonTitle()
    }
    
    @IBAction func clickToBankAgreement(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToPayNow(_ sender: Any) {
        self.view.endEditing(true)
        if selectedTab == 0 {
            if isAddCardBank {
                addCreditDebitCard()
            }else{
                //pay
            }
            
        }
        else if selectedTab == 1 {
            //paypal
//            paypalPaymentCompleted()
            
            if amount == 0 {
                return
            }
            let item1 = PayPalItem(name: "Bid In Cars", withQuantity: 1, withPrice: NSDecimalNumber(value: amount), withCurrency: "USD", withSku: "SKU2019")
            let items = [item1]
            let subTotal = PayPalItem.totalPrice(forItems: items)
            
            let payment = PayPalPayment(amount: subTotal, currencyCode: "USD", shortDescription: "Bid In Cars", intent: .sale)
            payment.items = items
            
            if payment.processable {
                let paymentVC = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)!
                self.present(paymentVC, animated: true, completion: nil)
            }
            else{
                displayToast("Payment not possible")
            }
            
        }
        else if selectedTab == 2 {
            //bank
            if isAddCardBank {
                addBankAccount()
            }else{
                //pay
            }
        }
    }
    
    func resetAllOption()
    {
        visaBtn.isSelected = false
        paypalBtn.isSelected = false
        bankBtn.isSelected = false
        visaView.backgroundColor = WhiteColor
        paypalView.backgroundColor = WhiteColor
        bankView.backgroundColor = WhiteColor
        cardContainerView.removeFromSuperview()
        paypalContainerView.removeFromSuperview()
        bankContainerView.removeFromSuperview()
    }
    
    @IBAction func clickToSelectCardEndDate(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = MONTH_ARRAY
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cardDateTxt.myTxt.text = item
            self.selectedMonth = index
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectCardEndYear(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = arrYearData
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cardYearTxt.myTxt.text = item
        }
        dropDown.show()
    }
    
    //MARK:- Textfield Delegate Method
    @objc func didChangeText(textField:UITextField) {
        textField.text = modifyCreditCardString(creditCardString: textField.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNumberTxt.myTxt {
            let newLength = (textField.text ?? "").count + string.count - range.length
            return newLength <= 19
        }
        else if textField == cardCVVTxt.myTxt {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 3
        }
        return true
    }
    
    func addCreditDebitCard()
    {
        if cardNameTxt.myTxt.text!.trimmed == "" {
            displayToast("enter_card_name")
        }
        else if cardNumberTxt.myTxt.text!.trimmed == "" {
            displayToast("enter_card_number")
        }
        else if cardCVVTxt.myTxt.text!.trimmed == "" {
            displayToast("enter_csv_number")
        }
        else if cardDateTxt.myTxt.text!.trimmed == "" {
            displayToast("enter_expire_date")
        }
        else if cardYearTxt.myTxt.text!.trimmed == "" {
            displayToast("enter_expire_year")
        }
        else if !cardAgreementBtn.isSelected {
            displayToast("card_agreement")
        }
        else {
            serviceCallToSavePaymentCard()
        }
    }
    
    func serviceCallToSavePaymentCard()
    {
        if !isUserLogin() {
            return
        }
        var param = [String : Any]()
        param["card_name"] = cardNameTxt.myTxt.text
        param["card_number"] = cardNumberTxt.myTxt.text?.replacingOccurrences(of: " ", with: "")
        param["csv"] = cardCVVTxt.myTxt.text
        param["card_month"] = selectedMonth //cardDateTxt.myTxt.text
        param["exp_year"] = cardYearTxt.myTxt.text
        param["type"] = "card"
        param["userid"] = AppModel.shared.currentUser.userid!
        
        APIManager.shared.serviceCallToSavePaymentCard(param) {
            displayToast("card_add_success")
            if self.primaryCardBtn.isSelected {
                setPrimaryCard((self.cardNumberTxt.myTxt.text?.replacingOccurrences(of: " ", with: ""))!)
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DETAIL), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addBankAccount()
    {
        if !isUserLogin() {
            return
        }
        var param = [String : Any]()
        param["userid"] = AppModel.shared.currentUser.userid
        param["bank_name"] = bankFullNameTxt.myTxt.text
        param["account_number"] = bankAccountNumberTxt.myTxt.text
        param["account_title"] = bankAccountTitleTxt.myTxt.text
        param["iban"] = bankIbanTxt.myTxt.text
        param["swift_code"] = bankSwiftCodeTxt.myTxt.text
        param["branch_code"] = bankBranchCodeTxt.myTxt.text
        param["type"] = "bank"
        
        APIManager.shared.serviceCallToSaveBankAccount(param) {
            displayToast("Bank account added successfully")
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DETAIL), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("Paypal payment cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("Paypal Payment Success..!")
        paymentViewController.dismiss(animated: true) {
            print(completedPayment.confirmation)
            self.paypalPaymentCompleted()
        }
    }
    
    func paypalPaymentCompleted()
    {
        if paymentType == PAYMENT.PACKAGE {
            serviceCallToPurchasePackage()
        }
        else if paymentType == PAYMENT.DEPOSITE {
            serviceCallToDepositeAmount()
        }
        else if paymentType == PAYMENT.FEATURED {
            serviceCallToMakeFeaturedAuction()
        }
    }
    
    func serviceCallToPurchasePackage()
    {
        APIManager.shared.serviceCallToPurchasePackage(paymentParam) {
            displayToast("Package bought successfully")
            if self.isFromAuction {
                AppDelegate().sharedDelegate().getPackageHistory()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PostAuctionDetailVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func serviceCallToDepositeAmount()
    {
        var amount = 0
        if let deposite_amount : String = paymentParam["deposite_amount"] as? String {
            if AppModel.shared.currentUser.user_deposit != "" {
                amount = Int(AppModel.shared.currentUser.user_deposit!)! + Int(deposite_amount)!
            }else{
                amount = Int(deposite_amount)!
            }
            paymentParam["deposite_amount"] = amount
        }
        print(paymentParam)
        APIManager.shared.serviceCallToDepositeAmount(paymentParam) {
            displayToast("Deposit added successfully")
            AppModel.shared.currentUser.user_deposit = String(amount)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func serviceCallToMakeFeaturedAuction() {
        APIManager.shared.serviceCallToMakeFeaturedAuction(paymentParam) {
            self.paymentParam["auction_featured"] = "yes"
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.AUCTION_FEATURED_DATA), object: self.paymentParam)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Other Method
    func setPayButtonTitle()
    {
        if selectedTab == 0 {
            payTitleLbl.text = isAddCardBank ? "ADD CARD" : "PAY NOW"
        }
        else if selectedTab == 1 {
            payTitleLbl.text = "PAY NOW"
        }
        else if selectedTab == 2 {
            payTitleLbl.text = isAddCardBank ? "ADD BANK" : "PAY NOW"
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
