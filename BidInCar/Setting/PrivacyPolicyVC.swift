//
//  PrivacyPolicyVC.swift
//  BidInCar
//
//  Created by Keyur on 21/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {
    
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if screenType == 0 {
            titleLbl.text = "Privacy Policy"
            myWebView.load(URLRequest(url: URL(string: POLICY_URL)!))
        }
        else if screenType == 1 {
            titleLbl.text = "Terms and Conditions"
            myWebView.load(URLRequest(url: URL(string: TERMS_URL)!))            
        }
    }
    
    @IBAction func clickToNotification(_ sender: Any) {
        let vc : NotificationVC = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion {}
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
