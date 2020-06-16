//
//  MyProfileVC.swift
//  BidInCar
//
//  Created by Keyur on 19/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class MyProfileVC: UploadImageVC {

    @IBOutlet weak var personalBtn: Button!
    @IBOutlet weak var billingBtn: Button!
    @IBOutlet weak var paymentBtn: Button!
    @IBOutlet weak var settingBtn: Button!
    @IBOutlet weak var personalImg: UIImageView!
    @IBOutlet weak var billingImg: UIImageView!
    @IBOutlet weak var paymentImg: UIImageView!
    @IBOutlet weak var settingImg: UIImageView!
    
    @IBOutlet weak var mainContainerView: UIView!
    
    var profileVC : ProfileVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
    var billingVC : BillingInfoVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "BillingInfoVC") as! BillingInfoVC
    var paymentSellerVC : PaymentSellerVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PaymentSellerVC") as! PaymentSellerVC
    var paymentBuyerVC : PaymentBuyerVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PaymentBuyerVC") as! PaymentBuyerVC
    var settingVC : SettingsVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(uploadImageNotification), name: NSNotification.Name.init("NOTIFICATION_UPLOAD_IMAGE"), object: nil)
        clickToSelectTab(personalBtn)
    }
    
    //MARK:- Button click event
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
    }
    
    @IBAction func clickToSelectTab(_ sender: UIButton) {
        self.view.endEditing(true)
        resetAllTab()
        if sender == personalBtn {
            personalBtn.isSelected = true
            personalImg.isHidden = false
            displaySubViewtoParentView(mainContainerView, subview: profileVC.view)
        }
        else if sender == billingBtn {
            billingBtn.isSelected = true
            billingImg.isHidden = false
            displaySubViewtoParentView(mainContainerView, subview: billingVC.view)
        }
        else if sender == paymentBtn {
            paymentBtn.isSelected = true
            paymentImg.isHidden = false
            if isUserBuyer() {
                displaySubViewtoParentView(mainContainerView, subview: paymentBuyerVC.view)
            }else{
                displaySubViewtoParentView(mainContainerView, subview: paymentSellerVC.view)
            }
        }
        else if sender == settingBtn {
            settingBtn.isSelected = true
            settingImg.isHidden = false
            displaySubViewtoParentView(mainContainerView, subview: settingVC.view)
        }
    }
    
    @objc func uploadImageNotification()
    {
        uploadImage()
    }
    
    override func selectedImage(choosenImage: UIImage) {
        profileVC.selectedImage(choosenImage)
    }
    
    func resetAllTab() {
        personalBtn.isSelected = false
        billingBtn.isSelected = false
        paymentBtn.isSelected = false
        settingBtn.isSelected = false
        personalImg.isHidden = true
        billingImg.isHidden = true
        paymentImg.isHidden = true
        settingImg.isHidden = true
        profileVC.view.removeFromSuperview()
        billingVC.view.removeFromSuperview()
        paymentSellerVC.view.removeFromSuperview()
        paymentBuyerVC.view.removeFromSuperview()
        settingVC.view.removeFromSuperview()
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
