//
//  VerificationVC.swift
//  BidInCar
//
//  Created by Keyur Akbari on 12/11/20.
//  Copyright © 2020 Amisha. All rights reserved.
//

import UIKit

class VerificationVC: UIViewController {

    @IBOutlet weak var codeTxt: FloatingTextfiledView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        codeTxt.myTxt.keyboardType = .numberPad
        serviceCallToSendOtp()
        
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToVerify(_ sender: Any) {
        self.view.endEditing(true)
        if codeTxt.myTxt.text?.trimmed == "" {
            displayToast("Please enter code")
        }
        else{
            var param = [String : Any]()
            param["otpnumber"] = codeTxt.myTxt.text
            
            APIManager.shared.serviceCallToVerifyAccount(param) {
                setLoginUserData()
                AppDelegate().sharedDelegate().navigateToDashBoard()
            }
        }
    }
    
    @IBAction func clickToResend(_ sender: Any) {
        serviceCallToSendOtp()
    }
    
    func serviceCallToSendOtp() {
        var param = [String : Any]()
        param["userid"] = AppModel.shared.currentUser.userid
        APIManager.shared.serviceCallToSendOtp(param) {
            
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
