//
//  SideMenuVC.swift
//  BidInCar
//
//  Created by Keyur on 17/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit

var screenType = 0

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var profilePicBtn: Button!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signupLbl: Label!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userNameLbl: Label!
    @IBOutlet weak var userTypeLbl: Label!
    @IBOutlet weak var addDepositeView: View!
    @IBOutlet weak var postAuctionView: View!
    @IBOutlet weak var notiLbl: Label!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var arrMenuData = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToHomePage), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_HOME), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToMyAuctionDraft), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_DRAFT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToMyProfile), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_MY_PROFILE), object: nil)
        
        tblView.register(UINib.init(nibName: "CustomSideMenuTVC", bundle: nil), forCellReuseIdentifier: "CustomSideMenuTVC")
        if isUserLogin() {
            profileView.isHidden = false
            loginView.isHidden = true
            updateUserData()
        }
        else{
            profileView.isHidden = true
            loginView.isHidden = false
            signupLbl.text = getTranslate("not_member_signup")
            signupLbl.attributedText = attributedStringWithColor(signupLbl.text!, [getTranslate("signup_title")], color: BlueColor)
        }
        setupMenu()
    }
    
    @objc func redirectToHomePage()
    {
        let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
    }
    
    @objc func redirectToMyAuctionDraft()
    {
        let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "MyAuctionSellerVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
    }
    
    @objc func redirectToMyProfile()
    {
        let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "MyProfileVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
    }
    
    @objc func updateUserData()
    {
        setButtonBackgroundImage(profilePicBtn, AppModel.shared.currentUser.profile_pic, IMAGE.USER_PLACEHOLDER)
        userNameLbl.text = AppModel.shared.currentUser.user_name
        if AppModel.shared.currentUser.notification == "on" {
            notificationSwitch.setOn(true, animated: false)
            notiLbl.text = getTranslate("off_noti")
        }else{
            notificationSwitch.setOn(false, animated: false)
            notiLbl.text = getTranslate("on_noti")
        }
        if isUserBuyer() {
            userTypeLbl.text = "Buyer"
            postAuctionView.isHidden = true
            addDepositeView.isHidden = false
//            subTitleLbl.text = "Your current bidding Limit: " + AppModel.shared.currentUser.biding_limit
//            let myLimit = "Limit: " + AppModel.shared.currentUser.biding_limit
//            subTitleLbl.attributedText = attributedStringWithColor(subTitleLbl.text!, [myLimit], color: RedColor, font: UIFont.init(name: APP_BOLD, size: 14))
        }else{
            userTypeLbl.text = "Seller"
            postAuctionView.isHidden = false
            addDepositeView.isHidden = true
            
//            subTitleLbl.text = "Your current package auctions Left: " + String(remaining)
//            let myLeft = "Left: " + String(remaining)
//            subTitleLbl.attributedText = attributedStringWithColor(subTitleLbl.text!, [myLeft], color: RedColor, font: UIFont.init(name: APP_BOLD, size: 14))
        }
    }
    
    func setupMenu()
    {
        arrMenuData = [[String : Any]]()
        var arrMenuTitle = [String]()
        
        if isUserLogin() {
            arrMenuTitle = [getTranslate("menu_home"), getTranslate("menu_auction"), getTranslate("menu_bookmark"), getTranslate("menu_profile"), getTranslate("menu_contact"), getTranslate("menu_terms"), getTranslate("menu_privacy"), getTranslate("menu_lang"), /*getTranslate("menu_calc"),*/ getTranslate("menu_logout")]
        }
        else{
            arrMenuTitle = [getTranslate("menu_home"), getTranslate("menu_auction"), getTranslate("menu_bookmark"), getTranslate("menu_contact"), getTranslate("menu_terms"), getTranslate("menu_privacy"), getTranslate("menu_lang")/*, getTranslate("menu_calc")*/]
        }
        //menu_lang
        var arrMenuImage = [String]()
        if isUserLogin() {
            arrMenuImage = ["menu_home", "menu_auction", "menu_bookmark", "menu_profile", "menu_contact", "menu_terms","menu_privacy", "menu_lang", /*"menu_calculator",*/ "logout"]
        }else{
            arrMenuImage = ["menu_home", "menu_auction", "menu_bookmark", "menu_contact", "menu_terms","menu_privacy", "menu_lang"/*, "menu_calculator"*/]
        }
        for i in 0..<arrMenuTitle.count {
            arrMenuData.append(["title" : arrMenuTitle[i], "image" : arrMenuImage[i]])
        }
        tblView.reloadData()
    }
    
    //MARK:- Button click event
    @IBAction func clickToLogin(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        AppDelegate().sharedDelegate().navigateToLogin()
    }
    
    @IBAction func clickToRegister(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        AppDelegate().sharedDelegate().navigateToSignup()
    }
    
    @IBAction func clickToLogout(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        showAlertWithOption("logout_title", message: "logout_msg", completionConfirm: {
            addButtonEvent(EVENT.TITLE.LOGOUT, EVENT.ACTION.LOGOUT, String(describing: self))
            AppDelegate().sharedDelegate().logoutFromApp()
        }) {
            
        }
    }
    
    @IBAction func clickToPostAuction(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        if !isUserLogin() {
            AppDelegate().sharedDelegate().navigateToLogin()
            //AppDelegate().sharedDelegate().showLoginPopup("post_auction_login_msg")
            return
        }
        addButtonEvent(EVENT.TITLE.POST_AUCTION, EVENT.ACTION.POST_AUCTION, String(describing: self))
        let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostAuctionVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
    }
    
    @IBAction func clickToAddDeposite(_ sender: UIButton) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        if !isUserLogin() {
            AppDelegate().sharedDelegate().navigateToLogin()
//            AppDelegate().sharedDelegate().showLoginPopup("add_deposite_login_msg")
            return
        }
        addButtonEvent(EVENT.TITLE.ADD_DEPOSIT, EVENT.ACTION.ADD_DEPOSIT, String(describing: self))
        let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
        
//        let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "MyProfileVCNav") as! UINavigationController
//        navController.isNavigationBarHidden = true
//        menuContainerViewController.centerViewController = navController
    }
    
    @IBAction func changeNotification(_ sender: Any) {
        addButtonEvent(EVENT.TITLE.NOTIFICATION_SETTING, EVENT.ACTION.NOTIFICATION_SETTING, String(describing: self))
        var param = [String : Any]()
        param["userid"] = AppModel.shared.currentUser.userid
        param["usernotification"] = notificationSwitch.isOn ? "on" : "off"
        APIManager.shared.serviceCallToUpdateNotificationSetting(param)
        if notificationSwitch.isOn {
            notiLbl.text = getTranslate("off_noti")
            AppModel.shared.currentUser.notification = "on"
        }else{
            notiLbl.text = getTranslate("on_noti")
            AppModel.shared.currentUser.notification = "off"
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
    }
    
    // MARK: - Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomSideMenuTVC = tblView.dequeueReusableCell(withIdentifier: "CustomSideMenuTVC") as! CustomSideMenuTVC
        let dict = arrMenuData[indexPath.row]
        cell.titleLbl.text = dict["title"] as? String ?? ""
        cell.imgBtn.setImage(UIImage.init(named: dict["image"] as? String ?? "menu_home"), for: .normal)
        if cell.titleLbl.text == getTranslate("menu_lang") {
            cell.langSwitch.isHidden = false
        }else{
            cell.langSwitch.isHidden = true
        }
        cell.contentView.backgroundColor = ClearColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        let dict = arrMenuData[indexPath.row]
        switch (dict["title"] as? String ?? "") {
            case getTranslate("menu_home"):
                addButtonEvent(EVENT.TITLE.HOME, EVENT.ACTION.HOME, String(describing: self))
                let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_auction"):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("my_auction_list_login_msg")
                    return
                }
                var navController = UINavigationController()
                if isUserBuyer() {
                    addButtonEvent(EVENT.TITLE.MY_AUCTION_BUYER, EVENT.ACTION.MY_AUCTION_BUYER, String(describing: self))
                    navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "MyAuctionVCNav") as! UINavigationController
                }else{
                    addButtonEvent(EVENT.TITLE.MY_AUCTION_SELLER, EVENT.ACTION.MY_AUCTION_SELLER, String(describing: self))
                    navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "MyAuctionSellerVCNav") as! UINavigationController
                }
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_bookmark"):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("bookmark_list_login_msg")
                    return
                }
                addButtonEvent(EVENT.TITLE.WISHLIST, EVENT.ACTION.WISHLIST, String(describing: self))
                let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookmarkVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_post"):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("post_auction_login_msg")
                    return
                }
                let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostAuctionVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_package"):
                let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PackageVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_calc"):
                let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "ShippingCalculatorVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_profile"):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("my_profile_login_msg")
                    return
                }
                addButtonEvent(EVENT.TITLE.MY_PROFILE, EVENT.ACTION.MY_PROFILE, String(describing: self))
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "MyProfileVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_contact"):
                addButtonEvent(EVENT.TITLE.CONTACT_US, EVENT.ACTION.CONTACT_US, String(describing: self))
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "ContactUsVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_terms"):
//                openUrlInSafari(strUrl: TERMS_URL)
                addButtonEvent(EVENT.TITLE.TERMS, EVENT.ACTION.TERMS, String(describing: self))
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                screenType = 1
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_privacy"):
//                openUrlInSafari(strUrl: POLICY_URL )
                addButtonEvent(EVENT.TITLE.POLICY, EVENT.ACTION.POLICY, String(describing: self))
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                screenType = 0
                menuContainerViewController.centerViewController = navController
                break
            case getTranslate("menu_lang"):
                AppDelegate().sharedDelegate().changeLanguage()
                break
            case getTranslate("menu_how_buy"):
                
                break
            case getTranslate("menu_logout"):
                showAlertWithOption("logout_title", message: "logout_msg", completionConfirm: {
                    addButtonEvent(EVENT.TITLE.LOGOUT, EVENT.ACTION.LOGOUT, String(describing: self))
                    AppDelegate().sharedDelegate().logoutFromApp()
                }) {
                    
                }
                break
            
            default:
                break
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
