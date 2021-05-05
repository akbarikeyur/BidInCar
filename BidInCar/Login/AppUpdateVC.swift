//
//  AppUpdateVC.swift
//  BidInCar
//
//  Created by Keyur on 27/04/21.
//  Copyright © 2021 Amisha. All rights reserved.
//

import UIKit

class AppUpdateVC: UIViewController {

    @IBOutlet weak var versionLbl: Label!
    @IBOutlet weak var backBtn: Button!
    
    var isForcefully = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        versionLbl.text = ""
        if let info = Bundle.main.infoDictionary {
            let currentVersion = info["CFBundleShortVersionString"] as? String
            versionLbl.text = "New Version " + currentVersion!
        }
        
        backBtn.isHidden = isForcefully
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToUpdate(_ sender: Any) {
        
        openUrlInSafari(strUrl: APP_STORE_URL)
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
