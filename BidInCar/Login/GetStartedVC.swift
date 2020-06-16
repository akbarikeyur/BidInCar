//
//  GetStartedVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import GoogleSignIn

class GetStartedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button click event
    @IBAction func clickToLogin(_ sender: Any) {
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        let vc : SignupVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func clickToSkip(_ sender: Any) {
        AppDelegate().sharedDelegate().navigateToDashBoard()
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
