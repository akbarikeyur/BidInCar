//
//  SocialLogin.swift
//  Reeveal
//
//  Created by Keyur Akbari on 12/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class SocialLogin: UIViewController, GIDSignInDelegate {

    let fbLoginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().delegate = self
    }
    
    func serviceCallToSocialLogin(_ param : [String : Any]) {
        LoginAPIManager.shared.serviceCallToCheckSocialLogin(param) { (dict) in
            if dict.count == 0 {
                let vc : SignupVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
                vc.isSocial = true
                vc.socialDict = param
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                AppModel.shared.currentUser = UserModel.init(dict: dict)
                if AppModel.shared.currentUser.verified {
                    setLoginUserData()
                    AppDelegate().sharedDelegate().serviceCallToGetUserProfile()
                    AppDelegate().sharedDelegate().navigateToDashBoard()
                }else{
                    let vc : VerificationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    //MARK: - Facebook Login
    func loginWithFacebook() {
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: AppDelegate().sharedDelegate().window?.rootViewController) { (result, error) in
            if let error = error {
                return
            }
            guard let token = result?.token else {
                return
            }
            
            guard let accessToken : String = token.tokenString as? String else {
                return
            }
            
            let request : GraphRequest = GraphRequest(graphPath: "/me", parameters: ["fields" : "email, id, name"])
            
            let connection : GraphRequestConnection = GraphRequestConnection()
            connection.add(request, completionHandler: { (connection, result, error) in
                
                if result != nil
                {
                    let dict = result as! [String : AnyObject]
                    printData(dict)
                    
                    guard let userId = dict["id"] as? String else { return }
                    
                    var param = [String : Any]()
                    param["email"] = AppModel.shared.getStringValue(dict, "email")
                    param["social_login_id"] = userId
                    param["login_type"] = "Facebook"
                    printData(param)
                    self.serviceCallToSocialLogin(param)
                }
            })
            connection.start()
        }
    }
    
    func loginWithGoogle() {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //MARK: - GoogleLogin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            printData(error.localizedDescription)
        } else {
            // Perform any operations on signed in user here.
            printData(user.userID!)
            printData(user.authentication.idToken!)
            printData(user.profile.name!)
            printData(user.profile.givenName!)
            printData(user.profile.familyName!)
            printData(user.profile.email!)
            printData(user.profile.imageURL(withDimension: UInt(200))!.absoluteString)
            
            var param = [String : Any]()
            param["email"] = user.profile.email!
            param["social_login_id"] = user.userID!
            param["login_type"] = "Google"
            printData(param)
            serviceCallToSocialLogin(param)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        printData(error.localizedDescription)
    }
    
    
   //Apple login
   @objc func actionHandleAppleSignin() {
       if #available(iOS 13.0, *) {
           let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
           let authorizationRequest = authorizationAppleIDProvider.createRequest()
           authorizationRequest.requestedScopes = [.fullName, .email]

           let authorizationController = ASAuthorizationController(authorizationRequests: [authorizationRequest])
           authorizationController.presentationContextProvider = self
           authorizationController.delegate = self
           authorizationController.performRequests()
       } else {
           // Fallback on earlier versions
       }
   }
}

@available(iOS 13.0, *)
extension SocialLogin: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

     // ASAuthorizationControllerDelegate function for authorization failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.view.endEditing(true)
        printData(error.localizedDescription)
    }

    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential{
            case let credentials as ASAuthorizationAppleIDCredential:
                
                var appleUser = AppleUserModel.init([String : Any]())
                if credentials.fullName?.givenName != nil && credentials.fullName?.givenName != ""{
                    appleUser.name = credentials.fullName?.givenName
                    KeychainService.saveAppleUserName(token: appleUser.name! as NSString)
                }
                else{
                    appleUser.name = KeychainService.loadAppleUserName() as String?
                }
                if credentials.user != ""{
                    appleUser.socialId = credentials.user
                    KeychainService.saveAppleUserId(token: appleUser.socialId! as NSString)
                }
                else{
                    appleUser.socialId = KeychainService.loadAppleUserId() as String?
                }
                if credentials.email != nil && credentials.email != "" {
                    appleUser.email = credentials.email
                    KeychainService.saveAppleEmail(token: appleUser.email! as NSString)
                }
                else{
                    appleUser.email = KeychainService.loadAppleEmail() as String?
                }
                if let socialToken = String(decoding: credentials.identityToken ?? Data(), as: UTF8.self) as? String {
                    appleUser.socialToken = socialToken
                    KeychainService.saveAppleToken(token: socialToken as NSString)
                }
                else{
                    appleUser.socialToken = KeychainService.loadAppleToken() as String?
                }
                
                var param = [String : Any]()
                param["email"] = appleUser.email
                param["social_login_id"] = appleUser.socialId
                param["login_type"] = "Apple"
                printData(param)
                serviceCallToSocialLogin(param)
            
            case let passwordCredential as ASPasswordCredential:
                // Sign in using an existing iCloud Keychain credential.
                let username = passwordCredential.user
                let password = passwordCredential.password
                //  show the password credential as an alert.
                DispatchQueue.main.async {
                    self.showPasswordCredentialAlert(username: username, password: password)
                }
            default:
                break
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
