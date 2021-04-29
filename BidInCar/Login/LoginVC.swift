//
//  LoginVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class LoginVC: SocialLogin {

    @IBOutlet weak var unameTxt: FloatingTextfiledView!
    @IBOutlet weak var passwordTxt: FloatingTextfiledView!
    @IBOutlet weak var keepBtn: Button!
    @IBOutlet weak var signupLbl: Label!
    
    var isFromLogout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUIDesigning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if PLATFORM.isSimulator {
//            unameTxt.myTxt.text = "testbuyer@abc.com"
//            passwordTxt.myTxt.text = "qqqqqq"
            
            unameTxt.myTxt.text = "keyur@seller.com"
            passwordTxt.myTxt.text = "qqqqqq"
        }
    }
    
    func setUIDesigning()
    {
        unameTxt.myTxt.keyboardType = .emailAddress
        passwordTxt.myTxt.isSecureTextEntry = true
        
        signupLbl.text = getTranslate("not_member_signup")
        signupLbl.attributedText = attributedStringWithColor(signupLbl.text!, [getTranslate("signup_title")], color: PurpleColor, font: nil)
    }
    
    //MARK:- Button click event
    @IBAction func clickToSignup(_ sender: Any) {
        self.view.endEditing(true)
        addButtonEvent(EVENT.TITLE.SIGNUP, EVENT.ACTION.SIGNUP, String(describing: self))
        let vc : SignupVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSocialLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1 {
            addButtonEvent(EVENT.TITLE.GOOGLE_LOGIN, EVENT.ACTION.GOOGLE_LOGIN, String(describing: self))
            loginWithGoogle()
        }
        else if sender.tag == 2 {
            addButtonEvent(EVENT.TITLE.FACEBOOK_LOGIN, EVENT.ACTION.FACEBOOK_LOGIN, String(describing: self))
            loginWithFacebook()
        }
        else if sender.tag == 3 {
            addButtonEvent(EVENT.TITLE.APPLE_LOGIN, EVENT.ACTION.APPLE_LOGIN, String(describing: self))
            actionHandleAppleSignin()
        }
    }
    
    @IBAction func clickToLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        addButtonEvent(EVENT.TITLE.EMAIL_LOGIN, EVENT.ACTION.EMAIL_LOGIN, String(describing: self))
        if unameTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if passwordTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_password")
        }
        else{
            var param = [String : Any]()
            param["email"] = unameTxt.myTxt.text
            param["password"] = passwordTxt.myTxt.text
            param["user_token"] = getPushToken()
            printData(param)
            LoginAPIManager.shared.serviceCallToUserLogin(param) {
                if AppModel.shared.currentUser.verified {
                    setLoginUserData()
                    AppDelegate().sharedDelegate().serviceCallToGetUserProfile()
                    AppDelegate().sharedDelegate().navigateToDashBoard()
                }else{
                    let vc : VerificationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        if isFromLogout {
            AppDelegate().sharedDelegate().navigateToDashBoard()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clickToKeepLogin(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.KEEP_LOGIN, EVENT.ACTION.KEEP_LOGIN, String(describing: self))
        keepBtn.isSelected = !keepBtn.isSelected
    }
    
    @IBAction func clickToForgotPassword(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.FORGOT_PASSWORD, EVENT.ACTION.FORGOT_PASSWORD, String(describing: self))
        let vc : ForgotPasswordVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
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
