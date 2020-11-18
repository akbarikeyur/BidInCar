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
    @IBOutlet weak var subTitleLbl: Label!
    
    var arrMenuData = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToHomePage), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_HOME), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToMyAuctionDraft), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_DRAFT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserData), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToMyProfile), name: NSNotification.Name.init(NOTIFICATION.REDIRECT_TO_MY_PROFILE), object: nil)
        
        tblView.register(UINib.init(nibName: "CustomSideMenuTVC", bundle: nil), forCellReuseIdentifier: "CustomSideMenuTVC")
        subTitleLbl.isHidden = true
        if isUserLogin() {
            profileView.isHidden = false
            loginView.isHidden = true
            updateUserData()
        }
        else{
            profileView.isHidden = true
            loginView.isHidden = false
            signupLbl.text = "Not a member? Register Now"
            signupLbl.attributedText = attributedStringWithColor(signupLbl.text!, ["Register Now"], color: BlueColor)
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
            
            var remaining = 0
            let arrPackageData = getPackageHistory()
            for i in 0..<arrPackageData.count {
                let package = arrPackageData[i]
                remaining += package.auctionsleft
            }
            
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
            arrMenuTitle = [NSLocalizedString("menu_home", comment: ""), NSLocalizedString("menu_auction", comment: ""), NSLocalizedString("menu_bookmark", comment: ""), NSLocalizedString("menu_profile", comment: ""), NSLocalizedString("menu_contact", comment: ""), NSLocalizedString("menu_terms", comment: ""), NSLocalizedString("menu_privacy", comment: ""), NSLocalizedString("menu_calc", comment: ""), NSLocalizedString("menu_logout", comment: "")]
        }
        else{
            arrMenuTitle = [NSLocalizedString("menu_home", comment: ""), NSLocalizedString("menu_auction", comment: ""), NSLocalizedString("menu_bookmark", comment: ""), NSLocalizedString("menu_contact", comment: ""), NSLocalizedString("menu_terms", comment: ""), NSLocalizedString("menu_privacy", comment: ""), NSLocalizedString("menu_calc", comment: "")]
        }
        
        var arrMenuImage = [String]()
        if isUserLogin() {
            arrMenuImage = ["menu_home", "menu_auction", "menu_bookmark", "menu_profile", "menu_contact", "menu_terms","menu_privacy", "menu_calculator", "logout"]
        }else{
            arrMenuImage = ["menu_home", "menu_auction", "menu_bookmark", "menu_contact", "menu_terms","menu_privacy", "menu_calculator"]
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
        showAlertWithOption("Logout", message: "Are you sure want to logout?", completionConfirm: {
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
        let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
        navController.isNavigationBarHidden = true
        menuContainerViewController.centerViewController = navController
        
//        let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "MyProfileVCNav") as! UINavigationController
//        navController.isNavigationBarHidden = true
//        menuContainerViewController.centerViewController = navController
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
        cell.contentView.backgroundColor = ClearColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        let dict = arrMenuData[indexPath.row]
        switch (dict["title"] as? String ?? "") {
            case NSLocalizedString("menu_home", comment: ""):
                let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_auction", comment: ""):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("my_auction_list_login_msg")
                    return
                }
                var navController = UINavigationController()
                if isUserBuyer() {
                    navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "MyAuctionVCNav") as! UINavigationController
                }else{
                    navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "MyAuctionSellerVCNav") as! UINavigationController
                }
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_bookmark", comment: ""):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("bookmark_list_login_msg")
                    return
                }
                let navController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookmarkVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_post", comment: ""):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("post_auction_login_msg")
                    return
                }
                let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PostAuctionVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_package", comment: ""):
                let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "PackageVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_calc", comment: ""):
                let navController = STORYBOARD.AUCTION.instantiateViewController(withIdentifier: "ShippingCalculatorVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_profile", comment: ""):
                if !isUserLogin() {
                    AppDelegate().sharedDelegate().showLoginPopup("my_profile_login_msg")
                    return
                }
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "MyProfileVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_contact", comment: ""):
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "ContactUsVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_terms", comment: ""):
//                openUrlInSafari(strUrl: TERMS_URL)
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                screenType = 1
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_privacy", comment: ""):
//                openUrlInSafari(strUrl: POLICY_URL )
                let navController = STORYBOARD.SETTING.instantiateViewController(withIdentifier: "PrivacyPolicyVCNav") as! UINavigationController
                navController.isNavigationBarHidden = true
                screenType = 0
                menuContainerViewController.centerViewController = navController
                break
            case NSLocalizedString("menu_how_sell", comment: ""):
                
                break
            case NSLocalizedString("menu_how_buy", comment: ""):
                
                break
            case NSLocalizedString("menu_logout", comment: ""):
                showAlertWithOption("Logout", message: "Are you sure want to logout?", completionConfirm: {
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
