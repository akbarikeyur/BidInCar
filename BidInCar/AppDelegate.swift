//
//  AppDelegate.swift
//  BidInCar
//
//  Created by Keyur on 15/10/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import MFSideMenu
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import GooglePlaces
import SDWebImageWebPCoder

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var activityLoader : NVActivityIndicatorView!
    var container : MFSideMenuContainerViewController = MFSideMenuContainerViewController()
    let fbLoginManager = LoginManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
            
        //Facebook Login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google Login
        GIDSignIn.sharedInstance().clientID = GOOGLE_KEY
        GIDSignIn.sharedInstance().delegate = self
        
        GMSPlacesClient.provideAPIKey("AIzaSyAylhQHaV99yBh7-wyhTvnto2R3-QFHHHg")
        
        //Twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey: TWITTER_API_KEY, consumerSecret: TWITTER_API_SECRET_KEY)
        
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)
        SDWebImageDownloader.shared.setValue("image/webp,image/*,*/*;q=0.8", forHTTPHeaderField:"Accept")
        
        //PayPal
        //Live
        //PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: PAYPAL_CLIENT_ID])
        
        //Sandbox
//        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: PAYPAL_CLIENT_ID])

        //Firebase
        FirebaseApp.configure()
        
        //Push Notification
        registerPushNotification(application)
        Messaging.messaging().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        AppModel.shared.resetAllModel()
        
        if isUserLogin() {
            AppModel.shared.currentUser = getLoginUserData()
        }
        
        AppModel.shared.AUCTION_TYPE = getCategoryData()
        
        serviceCalledForData()
        return true
    }

    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    //MARK:- Share Appdelegate
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK:- Loader
    func showLoader()
    {
        removeLoader()
        window?.isUserInteractionEnabled = false
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((window?.frame.size.width)!-50)/2, y: ((window?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballSpinFadeLoader
        activityLoader.color = BlackColor
        window?.addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    
    func removeLoader()
    {
        window?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
    }
    
    //MARK:- Navigation
    func navigateToLogin()
    {
//        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "GetStartedVCNav") as! UINavigationController
//        UIApplication.shared.keyWindow?.rootViewController = navigationVC
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSignup()
    {
        let vc : SignupVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToDashBoard()
    {
        let rootVC: MFSideMenuContainerViewController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        container = rootVC
        
        var navController: UINavigationController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVCNav") as! UINavigationController
        if #available(iOS 9.0, *) {
            let vc : HomeVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            
            let leftSideMenuVC: UIViewController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SideMenuVC")
            container.menuWidth = SCREEN.WIDTH
            container.panMode = MFSideMenuPanModeSideMenu
            container.menuSlideAnimationEnabled = true
            container.leftMenuViewController = leftSideMenuVC
            container.centerViewController = navController
            
            container.view.layer.masksToBounds = false
            container.view.layer.shadowOffset = CGSize(width: 10, height: 10)
            container.view.layer.shadowOpacity = 0.5
            container.view.layer.shadowRadius = 5
            container.view.layer.shadowColor = UIColor.clear.cgColor
            let rootNavigatioVC : UINavigationController = self.window?.rootViewController
                as! UINavigationController
            rootNavigatioVC.pushViewController(container, animated: false)
        }
    }
    
    func logoutFromApp()
    {
        let arrCountry = getCountryData()
        removeUserDefaultValues()
        AppModel.shared.resetAllModel()
        
        let vc : LoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.isFromLogout = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        
        var arrData = [[String : Any]]()
        for temp in arrCountry {
            arrData.append(temp.dictionary())
        }
        setCountryData(arrData)
        serviceCalledForData()
    }
    
    func showLoginPopup(_ msg : String)
    {
        self.navigateToLogin()
//        showAlertWithOption("BidInCar", message: msg, completionConfirm: {
//            self.navigateToLogin()
//        }) {
//
//        }
    }
    
    func updateAuctionGlobally(_ dict : AuctionModel) {
        if AppModel.shared.AUCTION_DATA[String(dict.cattype)] == nil {
            return
        }
        var arrTemp = AppModel.shared.AUCTION_DATA[String(dict.cattype)]!
        let index = arrTemp.firstIndex { (temp) -> Bool in
            temp.auctionid == dict.auctionid
        }
        if index != nil {
            arrTemp[index!] = dict
            AppModel.shared.AUCTION_DATA[String(dict.cattype)]! = arrTemp
        }
    }
    
    //MARK:- service Call
    func serviceCalledForData()
    {
        if getCountryData().count == 0 {
            APIManager.shared.serviceCallToGetCountryList { (data) in
                setCountryData(data)
            }
        }
        if isUserLogin() && !isUserBuyer() && AppModel.shared.currentUser != nil {
            APIManager.shared.serviceCallToGetMyPackage(["userid":AppModel.shared.currentUser.userid!])
        }
        
        if isUserLogin() && !isUserBuyer() && AppModel.shared.currentUser != nil {
            APIManager.shared.serviceCallToGetFeaturedPrice()
        }
        
        getPackageHistory()
    }
    
    func serviceCallToGetUserProfile() {
        APIManager.shared.serviceCallToGetUserProfile(AppModel.shared.currentUser.userid) { (dict) in
            AppModel.shared.currentUser = UserModel.init(dict: dict)
            setLoginUserData()
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_DASHBOARD_TOP_DATA), object: nil)
        }
    }
    
    func serviceCallToDecreseLeftAuction() {
        APIManager.shared.serviceCallToDecreseLeftAuction(["userid":AppModel.shared.currentUser.userid!]) {
            self.getPackageHistory()
        }
    }
    
    func getPackageHistory()
    {
        if isUserLogin() && !isUserBuyer() {
            APIManager.shared.serviceCallToGetPackageHistory(["userid":AppModel.shared.currentUser.userid!]) { (data) in
                savePackageHistory(data)
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
            }
        }
    }
    
    //MARK:- Social Login
    func loginWithFacebook()
    {
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: window?.rootViewController) { (result, error) in
            if let error = error {
                showAlert("Error", message: error.localizedDescription, completion: {})
                return
            }
            
            guard let token = result?.token else {
                return
            }
            
            printData(token.tokenString)
            
            let request : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "picture.width(500).height(500), email, id, name, first_name, last_name, gender"])
            
            let connection : GraphRequestConnection = GraphRequestConnection()
            connection.add(request, completionHandler: { (connection, result, error) in
                
                if result != nil
                {
                    AppModel.shared.currentUser = UserModel.init()
                    let dict = result as! [String : AnyObject]
                    printData(dict)
                    
                    /*
                    APIManager.shared.serviceCallToFBLogin(accessToken, { (status) in
                        if status
                        {
                            self.navigateToDashBoard()
                        }
                        else
                        {
                            if let email : String = dict["email"] as? String
                            {
                                AppModel.shared.currentUser.email = email
                            }

                            if let temp : String = dict["first_name"] as? String
                            {
                                AppModel.shared.currentUser.display_name = temp
                            }

                            if let temp : String = dict["last_name"] as? String
                            {
                                AppModel.shared.currentUser.lname = temp
                            }

                            if let picture = dict["picture"] as? [String : Any]
                            {
                                if let data = picture["data"] as? [String : Any]
                                {
                                    if let url = data["url"]
                                    {
                                        AppModel.shared.currentUser.avatar = url as? String
                                    }
                                }
                            }
                            
                            let vc : BecomeListenerVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "BecomeListenerVC") as! BecomeListenerVC
                            vc.isFBLogin = true
                            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: false)
                        }
                    })
                    */
                }
                else
                {
                    printData(error?.localizedDescription ?? "error")
                }
            })
            connection.start()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          printData("The user has not signed in before or they have since signed out.")
        } else {
          printData("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
      //let userId = user.userID                  // For client-side use only!
//      let idToken = user.authentication.idToken // Safe to send to the server
//      let fullName = user.profile.name
//      let givenName = user.profile.givenName
//      let familyName = user.profile.familyName
//      let email = user.profile.email
      
    }
          
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        printData(error.localizedDescription)
    }

    //MARK:- Twitter
    func loginWithTwitter()
    {
        /*
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if session != nil {
                printData(session?.userID)
                printData(session?.userName)
                TWTRAPIClient.withCurrentUser().requestEmail { (email, error) in
                    if error == nil {
                        printData(email)
                    }else{
                        printData(error?.localizedDescription)
                    }
                }
            }
            else{
                printData(error?.localizedDescription)
            }
        }
        */
    }
    
    //MARK: - Facebook Function
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.scheme?.contains("google"))! {
            return GIDSignIn.sharedInstance().handle(url)
        }
        else if (url.scheme?.contains("twitter"))! {
            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    //MARK:- Change language
    func changeLanguage()
    {
        if L102Language.currentAppleLanguage() == "en" || L102Language.currentAppleLanguage().contains("en") {
            UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            // Update the language by swaping bundle
            Bundle.setLanguage("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else{
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            // Update the language by swaping bundle
            Bundle.setLanguage("en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        AppDelegate().sharedDelegate().window?.rootViewController = AppDelegate().sharedDelegate().storyboard().instantiateInitialViewController()
        container = MFSideMenuContainerViewController()
        AppModel.shared.AUCTION_TYPE = [AuctionTypeModel]()
        navigateToDashBoard()
//        delay(1.0) {
//            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.RELOAD_AFTER_CHANGE_LANGUAGE), object: nil)
//        }
    }
    
    //MARK:- Notification
    func registerPushNotification(_ application: UIApplication)
    {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        printData("Notification registered")
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printData("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    //Get Push Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //application.applicationIconBadgeNumber = Int((userInfo["aps"] as! [String : Any])["badge"] as! String)!
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        printData(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func getFCMToken() -> String
    {
        return Messaging.messaging().fcmToken ?? ""
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        printData("Firebase registration token: \(fcmToken)")
        if getPushToken() == ""
        {
            setPushToken(fcmToken)
            printData(fcmToken)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        printData("Received data message: \(remoteMessage.appData)")
    }
}

// MARK:- Push Notification
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        _ = notification.request.content.userInfo
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState == .inactive
        {
            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(delayForNotification(tempTimer:)), userInfo: userInfo, repeats: false)
        }
        else
        {
            notificationHandler(userInfo as! [String : Any])
        }
        
        completionHandler()
    }
    
    @objc func delayForNotification(tempTimer:Timer)
    {
        notificationHandler(tempTimer.userInfo as! [String : Any])
    }
    
    //Redirect to screen
    func notificationHandler(_ dict : [String : Any])
    {
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_NOTIFICATION_SCREEN), object: nil)
    }
}
