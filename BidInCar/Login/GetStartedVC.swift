//
//  GetStartedVC.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button click event
    @IBAction func clickToLogin(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.LOGIN, EVENT.ACTION.LOGIN, String(describing: self))
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSignup(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.SIGNUP, EVENT.ACTION.SIGNUP, String(describing: self))
        let vc : SignupVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSkip(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.SKIP_HOME, EVENT.ACTION.SKIP_HOME, String(describing: self))
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
