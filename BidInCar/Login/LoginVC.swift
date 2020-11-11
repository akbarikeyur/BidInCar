//
//  LoginVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController {

    @IBOutlet weak var unameTxt: FloatingTextfiledView!
    @IBOutlet weak var passwordTxt: FloatingTextfiledView!
    @IBOutlet weak var keepBtn: Button!
    
    @IBOutlet weak var signupLbl: Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUIDesigning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if PLATFORM.isSimulator {
            unameTxt.myTxt.text = "buyer@abc.com"
            passwordTxt.myTxt.text = "abc"
        }
    }
    
    func setUIDesigning()
    {
        unameTxt.myTxt.keyboardType = .emailAddress
        passwordTxt.myTxt.isSecureTextEntry = true
        signupLbl.attributedText = attributedStringWithColor(signupLbl.text!, ["Sign up"], color: PurpleColor, font: nil)
    }
    
    //MARK:- Button click event
    @IBAction func clickToSignup(_ sender: Any) {
        self.view.endEditing(true)
        let vc : SignupVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToLogin(_ sender: UIButton) {
        self.view.endEditing(true)
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
            print(param)
            APIManager.shared.serviceCallToUserLogin(param) {
                if isUserLogin() {
                    AppDelegate().sharedDelegate().navigateToDashBoard()
                }
            }
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToKeepLogin(_ sender: Any) {
        keepBtn.isSelected = !keepBtn.isSelected
    }
    
    @IBAction func clickToSocialLogin(_ sender: UIButton) {
        if sender.tag == 1
        {
            //facebook
            AppDelegate().sharedDelegate().loginWithFacebook()
        }
        else if sender.tag == 2
        {
            //Twitter
            AppDelegate().sharedDelegate().loginWithTwitter()
        }
        else if sender.tag == 3
        {
            //Google
            GIDSignIn.sharedInstance()?.presentingViewController = self
            // Automatically sign in the user.
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            GIDSignIn.sharedInstance().signIn()
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
