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
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    var isBackDisplay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backBtn.isHidden = !isBackDisplay
        menuBtn.isHidden = isBackDisplay
        
        if screenType == 0 {
            titleLbl.text = getTranslate("privacy_policy_title")
            myWebView.load(URLRequest(url: URL(string: POLICY_URL)!))
        }
        else if screenType == 1 {
            titleLbl.text = getTranslate("terms_conditions_title")
            myWebView.load(URLRequest(url: URL(string: TERMS_URL)!))            
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
