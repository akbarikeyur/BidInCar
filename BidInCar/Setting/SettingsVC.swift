//
//  SettingsVC.swift
//  BidInCar
//
//  Created by Keyur on 20/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var participateBtn: Button!
    @IBOutlet weak var currentPwdTxt: FloatingTextfiledView!
    @IBOutlet weak var newPwdTxt: FloatingTextfiledView!
    @IBOutlet weak var confirmPwdTxt: FloatingTextfiledView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentPwdTxt.myTxt.isSecureTextEntry = true
        newPwdTxt.myTxt.isSecureTextEntry = true
        confirmPwdTxt.myTxt.isSecureTextEntry = true
        
        participateBtn.isSelected = (AppModel.shared.currentUser.notification == "on")
    }
    
    @IBAction func clickToSelectOption(_ sender: UIButton) {
        addButtonEvent(EVENT.TITLE.NOTIFICATION_SETTING, EVENT.ACTION.NOTIFICATION_SETTING, String(describing: self))
        participateBtn.isSelected = !participateBtn.isSelected
        var param = [String : Any]()
        param["userid"] = AppModel.shared.currentUser.userid
        param["usernotification"] = participateBtn.isSelected ? "on" : "off"
        APIManager.shared.serviceCallToUpdateNotificationSetting(param)
        if participateBtn.isSelected {
            AppModel.shared.currentUser.notification = "on"
        }else{
            AppModel.shared.currentUser.notification = "off"
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
    }
    
    @IBAction func clickToChangePassword(_ sender: Any) {
        self.view.endEditing(true)
        if currentPwdTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_current_pwd")
        }
        else if newPwdTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_new_pwd")
        }
        else if currentPwdTxt.myTxt.text == newPwdTxt.myTxt.text {
            displayToast("different_pwd")
        }
        else if confirmPwdTxt.myTxt.text?.trimmed == "" {
            displayToast("enter_confirm_pwd")
        }
        else if newPwdTxt.myTxt.text?.trimmed != confirmPwdTxt.myTxt.text?.trimmed {
            displayToast("new_confirm_pwd_same")
        }
        else{
            if !isUserLogin() {
                return
            }
            var param = [String : Any]()
            param["userid"] = AppModel.shared.currentUser.userid!
            param["current_password"] = currentPwdTxt.myTxt.text
            param["ppassword"] = newPwdTxt.myTxt.text
            addButtonEvent(EVENT.TITLE.CHANGE_PASSWORD, EVENT.ACTION.CHANGE_PASSWORD, String(describing: self))
            APIManager.shared.serviceCallToChangePassword(param) {
                displayToast("change_pwd_success")
                self.currentPwdTxt.myTxt.text = ""
                self.newPwdTxt.myTxt.text = ""
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
