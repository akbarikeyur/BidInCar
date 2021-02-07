//
//  BillingInfoVC.swift
//  BidInCar
//
//  Created by Keyur on 19/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class BillingInfoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var paymentCV: UICollectionView!
    @IBOutlet weak var constraintHeightpaymentCV: NSLayoutConstraint!//250
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bankView: View!
    @IBOutlet weak var bankAccountLbl: Label!
    @IBOutlet weak var addBankBtn: Button!
    @IBOutlet weak var paypalView: UIView!
    
    var selectedIndex = 0
    var arrCardData : [CardModel] = [CardModel]()
    var bankData = CardModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(serviceCallToGetPaymentCard), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DETAIL), object: nil)
        paymentCV.register(UINib.init(nibName: "CustomCardCVC", bundle: nil), forCellWithReuseIdentifier: "CustomCardCVC")
        pageControl.numberOfPages = arrCardData.count
        
        paymentCV.isHidden = true
        pageControl.isHidden = true
        constraintHeightpaymentCV.constant = 0
        paypalView.isHidden = true
        setBankDetail()
        serviceCallToGetPaymentCard()
    }
    
    //MARK:- Collectionview Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CustomCardCVC = paymentCV.dequeueReusableCell(withReuseIdentifier: "CustomCardCVC", for: indexPath) as! CustomCardCVC
        let dict = arrCardData[indexPath.row]
        cell.logoImg.image = UIImage.init(named: getCardImage(strType: dict.type))
        if dict.card_primary == "yes" {
            cell.primaryLbl.text = getTranslate("primary_billing")
        }else{
            cell.primaryLbl.text = getTranslate("primary_make_billing")
        }
        cell.numberLbl.text = "****" + String(dict.cardnumber.suffix(4))
        cell.nameLbl.text = dict.name_on_card
        if indexPath.row == selectedIndex {
            cell.yellowView.backgroundColor = YellowColor
            cell.grayView.isHidden = false
        }else{
            cell.yellowView.backgroundColor = LightBGColor
            cell.grayView.isHidden = true
        }
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(clickToEditCard(_:)), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(clickToDeleteCard(_:)), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        pageControl.currentPage = selectedIndex
    }
    
    @objc @IBAction func clickToEditCard(_ sender: UIButton) {
        
    }
    
    @objc @IBAction func clickToDeleteCard(_ sender: UIButton) {
        showAlertWithOption("delete_title", message: "delete_card", completionConfirm: {
            self.serviceCallToRemovePaymentCard(self.arrCardData[sender.tag].user_card_id)
        }) {
            
        }
    }
    
    @IBAction func clickToAddNewCard(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
        vc.selectedTab = 0
        vc.isAddCardBank = true
        vc.isFromProfile = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToAddNewBank(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
        vc.selectedTab = 2
        vc.isAddCardBank = true
        vc.isFromProfile = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToAddNewPaypal(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc : SelectPaymentMethodVC = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC
        vc.selectedTab = 1
        vc.isAddCardBank = true
        vc.isFromProfile = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = scrollView.contentOffset.x / scrollView.frame.width
//        pageControl.currentPage = Int(pageIndex)
    }
    
    @objc func serviceCallToGetPaymentCard()
    {
        if !isUserLogin() {
            return
        }
        APIManager.shared.serviceCallToGetPaymentCard(["userid":AppModel.shared.currentUser.userid!]) { (data) in
            if data.count > 0 {
                
                self.arrCardData = [CardModel]()
                for temp in data {
                    let dict = CardModel.init(dict: temp)
                    if dict.type == "bank" {
                        self.bankData = dict
                    }else{
                        self.arrCardData.append(dict)
                    }
                }
                if self.arrCardData.count > 0 {
                    self.pageControl.numberOfPages = self.arrCardData.count
                    self.paymentCV.isHidden = false
                    self.pageControl.isHidden = false
                    self.paymentCV.reloadData()
                    self.constraintHeightpaymentCV.constant = 250
                    if getPrimaryCard() != "" {
                        let index1 = self.arrCardData.firstIndex(where: { (temp) -> Bool in
                            temp.cardnumber == getPrimaryCard()
                        })
                        if index1 != nil {
                            if self.arrCardData[index1!].card_primary != "yes" {
                                setPrimaryCard(self.arrCardData[index1!].cardnumber)
                                self.serviceCallToSetPrimaryPaymentCard()
                            }
                        }
                    }
                    else{
                        let index1 = self.arrCardData.firstIndex(where: { (temp) -> Bool in
                            temp.card_primary == "yes"
                        })
                        if index1 != nil {
                            setPrimaryCard(self.arrCardData[index1!].cardnumber)
                        }else{
                            setPrimaryCard(self.arrCardData[0].cardnumber)
                            self.serviceCallToSetPrimaryPaymentCard()
                        }
                    }
                }
                self.setBankDetail()
            }
        }
    }
    
    @objc func serviceCallToRemovePaymentCard(_ cardid : String)
    {
        if !isUserLogin() {
            return
        }
        var param = [String : Any]()
        param["userid"] = AppModel.shared.currentUser.userid!
        param["cardid"] = cardid
        
        APIManager.shared.serviceCallToRemovePaymentCard(param) {
            let index = self.arrCardData.firstIndex { (temp) -> Bool in
                temp.user_card_id == cardid
            }
            if index != nil {
                self.arrCardData.remove(at: index!)
                self.paymentCV.reloadData()
                self.pageControl.numberOfPages = self.arrCardData.count
                if self.arrCardData.count == 0 {
                    self.paymentCV.isHidden = true
                    self.pageControl.isHidden = true
                    self.constraintHeightpaymentCV.constant = 0
                }
            }
        }
    }
    
    func serviceCallToSetPrimaryPaymentCard()
    {
        if !isUserLogin() {
            return
        }
        let index = arrCardData.firstIndex { (temp) -> Bool in
            temp.cardnumber == getPrimaryCard()
        }
        if index != nil {
            var param = [String : Any]()
            param["userid"] = AppModel.shared.currentUser.userid!
            param["cardid"] = arrCardData[index!].user_card_id
            printData(param)
            APIManager.shared.serviceCallToSetPrimaryPaymentCard(param) {
                
            }
        }
    }
    
    func setBankDetail()
    {
        if bankData.back_account_number == "" {
            bankView.isHidden = true
        }else{
            bankView.isHidden = false
            bankAccountLbl.text = "***" + String(bankData.back_account_number.suffix(4))
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
