//
//  ForgotPasswordVC.swift
//  BidInCar
//
//  Created by Keyur on 18/11/20.
//  Copyright © 2020 Amisha. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: FloatingTextfiledView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTxt.myTxt.keyboardType = .emailAddress
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToSend(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_email")
        }
        else if !emailTxt.myTxt.text!.isValidEmail {
            displayToast("invalid_email")
        }
        else {
            APIManager.shared.serviceCallToForgotPassword(["email" : emailTxt.myTxt.text!]) {
                self.navigationController?.popViewController(animated: true)
            }
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
