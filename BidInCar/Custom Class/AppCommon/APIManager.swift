    
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire
import AlamofireJsonToObjects

//Development
struct API {
//    static let BASE_URL = "http://anglotestserver.website/auction_new/"
    static let BASE_URL = "https://bidincars.com/"
    
    static let LOGIN                        =       BASE_URL + "user/user_auth"
    static let SIGNUP                       =       BASE_URL + "user/registers"
    static let SEND_OTP                     =       BASE_URL + "user/sendotp"
    static let VERIFY_OTP                   =       BASE_URL + "user/verify_account"
    static let FORGOT_PASSWORD              =       BASE_URL + "user/forget_password"
    
    static let GET_USER_PROFILE             =       BASE_URL + "user/getprofile"
    static let UPLOAD_PROFILE_PICTURE       =       BASE_URL + "user/upload_profile_pic"
    static let UPDATE_PROFILE               =       BASE_URL + "user/update_profile"
    static let CHANGE_PASSWORD              =       BASE_URL + "user/update_password"
    
    static let GET_BUYER_DATA               =       BASE_URL + "user/topbuyerbar"
    static let GET_SELLER_DATA              =       BASE_URL + "user/topsellerbar"
    
    static let GET_COUNTRY                  =       BASE_URL + "getcountries"
    static let GET_CITY                     =       BASE_URL + "getcities"
//    static let GET_FEATURED_PRICE           =       BASE_URL + "admin/setting/get_featured_price"
    static let GET_AUCTION_CATEGORY         =       BASE_URL + "auctions/apicategories"
    
    static let SAVE_AUCTION                 =       BASE_URL + "auctions/save_auction"
    static let CONFIRM_AUCTION_DOC          =       BASE_URL + "auctions/confirm_auction"
    static let UPLOAD_AUCTION_IMAGE         =       BASE_URL + "auctions/upload_file_gallary"
    static let REMOVE_AUCTION_IMAGE         =       BASE_URL + "auctions/removepicture"
    static let UPLOAD_AUCTION_DOC           =       BASE_URL + "auctions/upload_doc"
    static let DECRESE_LEFT_AUCTION         =       BASE_URL + "payment/package_decrease"
    
    static let SEARCH_FEATURED_AUCTION      =       BASE_URL + "auctions/searchauctions"
    static let GET_AUCTION_DETAIL           =       BASE_URL + "auctions/getsingleauction"
    static let ADD_AUCTION_BID              =       BASE_URL + "auctions/insertbid"
    static let GET_AUCTION_BID              =       BASE_URL + "auctions/getbidsonly"
    static let WITHDRAW_AUCTION_BID         =       BASE_URL + "auctions/delete_withdraw_auction"
    static let GET_FEATURED_PRICE           =       BASE_URL + "auctions/getAuctionFeaturedPrice"
    static let MAKE_FEATURED_AUCTION        =       BASE_URL + "auctions/make_auction_featured"
    static let AUCTION_PAYMENT              =       BASE_URL + "payment/api_auction_payment"
    
    static let GET_FEATURED_AUCTION         =       BASE_URL + "payment/get_featured_auction"
    static let GET_PACKAGE_HISTORY          =       BASE_URL + "payment/package_history"
    static let GET_BID_AUCTION              =       BASE_URL + "payment/getbidedauctions"
    
    static let GET_MY_AUCTION               =       BASE_URL + "auctions/searchprofileseaction"
    static let GET_CATEGORY                 =       BASE_URL + "auctions/getCategories"
    static let GET_CHILD_CATEGORY           =       BASE_URL + "auctions/getChildCat"
    
    static let ADD_BOOKMARK                 =       BASE_URL + "user/save_bookmark"
    static let GET_MY_BOOKMARK              =       BASE_URL + "user/getmybookmarks"
    static let REMOVE_BOOKMARK              =       BASE_URL + "user/remove_bookmark"
    
    static let GET_CARD                     =       BASE_URL + "user/getcard"
    static let SAVE_CARD                    =       BASE_URL + "user/save_card"
    static let REMOVE_CARD                  =       BASE_URL + "user/removecard"
    static let SET_PRIMARY_CARD             =       BASE_URL + "user/cardfeatured"
    static let SAVE_BANK                    =       BASE_URL + "user/save_card"
    
    static let DEPOSITE_AMOUNT              =       BASE_URL + "payment/deposite_amount"
    static let WITHDRAW_AMOUNT              =       BASE_URL + "payment/withdraw_amount"
    static let GET_DEPOSITE_HISTORY         =       BASE_URL + "payment/getdepositshistory"
    static let GET_WITHDRAW_HISTORY         =       BASE_URL + "payment/getwithdrawstatus"
    
    static let GET_PACKAGE                  =       BASE_URL + "packages/api_packages"
    static let PURCHASE_PACKAGE             =       BASE_URL + "payment/package_purchase"
    static let GET_MY_PACKAGE               =       BASE_URL + "payment/getpackages"
    
    static let CONTACT_US                   =       BASE_URL + "contactmail"
    static let CONTACT_UPLOAD               =       BASE_URL + "contactupload"
    
    static let SHIPPING_CALCULATOR          =       BASE_URL + "admin/shipping/getshippingprices"
    static let FAQ                          =       BASE_URL + "admin/faq/getfaqs"
    
    static let GET_NOTIFICATION             =       BASE_URL + "notification/getnotification"
    static let UPDATE_NOTIFICATION          =       BASE_URL + "user/updatenotificationsettings"
}


public class APIManager {
    
    static let shared = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func getJsonHeader() -> [String:String] {
        return ["Content-Type":"application/json", "Accept" : "application/json"]
    }
    
    func getMultipartHeader() -> [String:String]{
        return ["Content-Type":"multipart/form-data", "Accept" : "application/json"]
    }
    
    func getJsonHeaderWithToken() -> [String:String] {
        return ["Content-Type":"application/json", "Accept" : "application/json", "Authorization": getAccessToken()]
    }
    
    func getMultipartHeaderWithToken() -> [String:String] {
        return ["Content-Type":"multipart/form-data", "Accept" : "application/json", "Authorization": getAccessToken()]
    }
    
    func networkErrorMsg()
    {
        removeLoader()
        showAlert("BidInCar", message: "You are not connected to the internet") {
            
        }
    }
    
    func convertToJson(_ dict:[String:Any]) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString!
    }
    
    func isServiceError(_ code: Int?) -> Bool {
        if(code == 401    )
        {
            //AppDelegate().sharedDelegate().logoutApp()
            return true
        }
        return false
    }

    //MARK:- Login Module
    func serviceCallToUserLogin(_ params : [String : Any], completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        
        Alamofire.request(API.LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [String : Any] = result["data"] as? [String : Any]
                            {
                                AppModel.shared.currentUser = UserModel.init(dict: data)
                                completion()
                                return
                            }
                        }
                        else if status == "error"
                        {
                            if let message = result["message"] as? String, message != "" {
                                displayToast(message)
                            }
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToUserSignup(_ params : [String : Any], completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams : [String : String] = ["Content-Type":"application/json", "Accept" : "application/json"]
        printData(params)
        Alamofire.request(API.SIGNUP, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [String : Any] = result["data"] as? [String : Any]
                            {
                                AppModel.shared.currentUser = UserModel.init(dict: data)
                                completion()
                                return
                            }
                        }
                        else if status == "error"
                        {
                            if let message = result["message"] as? String, message != "" {
                                displayToast(message)
                            }
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToSendOtp(_ params : [String : Any], completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        
        Alamofire.request(API.SEND_OTP, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else if status == "error"
                        {
                            if let message = result["message"] as? String, message != "" {
                                displayToast(message)
                            }
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToVerifyAccount(_ params : [String : Any], completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        
        Alamofire.request(API.VERIFY_OTP, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else if status == "error"
                        {
                            if let message = result["message"] as? String, message != "" {
                                displayToast(message)
                            }
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToForgotPassword(_ params : [String : Any], completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        
        Alamofire.request(API.FORGOT_PASSWORD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let message = result["message"] as? String, message != "" {
                                displayToast(message)
                            }
                            completion()
                            return
                        }
                        else if status == "error"
                        {
                            if let message = result["message"] as? String, message != "" {
                                displayToast(message)
                            }
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Profile
    func serviceCallToGetUserProfile(_ userId : String, _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_USER_PROFILE, method: .post, parameters: ["userid" : userId], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]], data.count > 0 {
                                completion(data[0])
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToUploadProfilePicture(_ image : UIImage, _ userId : String, completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        //showLoader()
        
        let headerParams :[String : String] = getJsonHeaderWithToken() //getMultipartHeaderWithToken()
        var params :[String : Any] = [String : Any] ()
        params["userid"] = userId
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(imageData, withName: "myfile", fileName: "myfile.jpg", mimeType: "image/jpg")
            }
            
        }, usingThreshold: UInt64.init(), to: API.UPLOAD_PROFILE_PICTURE, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    printData("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    //removeLoader()
                    if let result = response.result.value as? [String:Any] {
                        printData(result)
                        if let status = result["status"] as? String {
                            if(status == "success") {
                                if let data : [String : Any] = result["data"] as? [String : Any] {
                                    if let path : String = data["path"] as? String {
                                        AppModel.shared.currentUser.profile_pic = path
                                        setLoginUserData()
                                        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
                                    }
                                }
                                completion()
                                return
                            }
                            else
                            {
                                self.handleStatusCode(result)
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        printData(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                printData(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToUpdateUserProfile(_ params : [String : Any]) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(params)
        Alamofire.request(API.UPDATE_PROFILE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            AppDelegate().sharedDelegate().serviceCallToGetUserProfile()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToUpdateNotificationSetting(_ params : [String : Any]) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(params)
        Alamofire.request(API.UPDATE_NOTIFICATION, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToChangePassword(_ params : [String : Any], completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(params)
        Alamofire.request(API.CHANGE_PASSWORD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetBuyerData(_ userId : String, _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_BUYER_DATA, method: .post, parameters: ["userid" : userId], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetSellerData(_ userId : String, _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_SELLER_DATA, method: .post, parameters: ["userid" : userId], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Featured Auction
    func serviceCallToGetFeaturedAuction(_ params : [String : Any], completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(params)
        Alamofire.request(API.GET_FEATURED_AUCTION, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                                return
                            }
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetPackageHistory(_ params : [String : Any], completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(params)
        Alamofire.request(API.GET_PACKAGE_HISTORY, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                                return
                            }
                            else if let data : [String : Any] = result["data"] as? [String : Any] {
                                completion([data])
                                return
                            }
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetBidAuction(_ params : [String : Any], completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(params)
        Alamofire.request(API.GET_BID_AUCTION, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                                return
                            }
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Auction
    func serviceCallToUploadAuctionPicture(_ image : UIImage, completion: @escaping (_ mediaid : Int) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = getJsonHeaderWithToken() //getMultipartHeaderWithToken()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(imageData, withName: "myfile", fileName: "myfile.jpg", mimeType: "image/jpg")
            }
            
        }, usingThreshold: UInt64.init(), to: API.UPLOAD_AUCTION_IMAGE, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    printData("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    removeLoader()
                    if let result = response.result.value as? [String:Any] {
                        printData(result)
                        if let status = result["status"] as? String {
                            if(status == "success") {
                                if let data : [String : Any] = result["data"] as? [String : Any] {
                                    if let mediaid : Int = data["mediaid"] as? Int {
                                        completion(mediaid)
                                        return
                                    }
                                }
                            }
                            else
                            {
                                self.handleStatusCode(result)
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        printData(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                printData(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToUploadAuctionDocument(_ url : URL, completion: @escaping (_ mediaid : Int, _ path : String) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = getMultipartHeader() //getMultipartHeaderWithToken()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(url, withName: "upload_doc")
            
        }, usingThreshold: UInt64.init(), to: API.UPLOAD_AUCTION_DOC, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    printData("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    removeLoader()
                    if let result = response.result.value as? [String:Any] {
                        printData(result)
                        if let status = result["status"] as? String {
                            if(status == "success") {
                                if let data : [String : Any] = result["data"] as? [String : Any] {
                                    if let mediaid : Int = data["mediaid"] as? Int {
                                        if let path : String = data["path"] as? String {
                                            completion(mediaid,path)
                                        }
                                        else{
                                            completion(mediaid,"")
                                        }
                                        return
                                    }
                                }
                            }
                            else
                            {
                                self.handleStatusCode(result)
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        printData(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                printData(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToRemoveImage(_ params : [String : Any], completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(params)
        Alamofire.request(API.REMOVE_AUCTION_IMAGE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToPostAuction(_ param : [String : Any], _ completion: @escaping (_ code : Int, _ auctionid : Int, _ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = getMultipartHeader()
        printData(param)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, usingThreshold: UInt64.init(), to: API.SAVE_AUCTION, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    printData("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    removeLoader()
                    if let result = response.result.value as? [String:Any] {
                        printData(result)
                        if let status = result["status"] as? String {
                            if(status == "success") {
                                if let posted_auction = result["posted_auction"] as? [String : Any] {
                                    if let message = result["message"] as? String, message == "Auction is activated" {
                                        completion(100, 0, posted_auction)
                                        return
                                    }
                                    else {
                                        if let data : [String : Any] = result["data"] as? [String : Any] {
                                            if let auctionid : Int = data["auctionid"] as? Int {
                                                completion(101, auctionid, posted_auction)
                                                return
                                            }
                                            else if let auctionid : String = data["auctionid"] as? String {
                                                completion(101, Int(auctionid)!, posted_auction)
                                                return
                                            }
                                        }
                                        else {
                                            completion(101, -1, posted_auction)
                                        }
                                    }
                                }
                            }
                            else if(status == "Auction Limit") {
                                completion(101, 0, [String : Any]())
                            }
                            else
                            {
                                self.handleStatusCode(result)
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        printData(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                printData(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToConfirmAuction(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.CONFIRM_AUCTION_DOC, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToDecreseLeftAuction(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.DECRESE_LEFT_AUCTION, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.REDIRECT_DASHBOARD_TOP_DATA), object: nil)
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetAuction(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.SEARCH_FEATURED_AUCTION, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
//                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetAuctionDetail(_ auctionid : String, _ isLoaderDisplay : Bool, _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_AUCTION_DETAIL, method: .post, parameters: ["auctionid":auctionid], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [String : Any] = result["data"] as? [String : Any] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToAddAuctionBid(_ param : [String : Any], _ completion: @escaping (_ result : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.ADD_AUCTION_BID, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    completion(result)
                    return
                    
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetMyAuction(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]], _ package : PackageModel) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_MY_AUCTION, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                var package = PackageModel.init(dict: [String : Any]())
                                if let packagesDict : [String : Any] = result["packages"] as? [String : Any] {
                                    package = PackageModel.init(dict: packagesDict)
                                }
                                completion(data, package)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetAuctionBid(_ auctionid : String, _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        //showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_AUCTION_BID, method: .post, parameters: ["auctionid":auctionid], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            //removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToWithdrawAuctionBid(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.WITHDRAW_AUCTION_BID, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToMakeFeaturedAuction(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.MAKE_FEATURED_AUCTION, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Get auction payment detail
    func serviceCallToGetAuctionPayment(_ param : [String : Any], _ completion: @escaping (_ dict : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.AUCTION_PAYMENT, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let dict = result["data"] as? [String:Any] {
                                completion(dict)
                                return
                            }
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Bookmark
    func serviceCallToAddBookmark(_ param : [String : Any], _ completion: @escaping (_ bookmarkId : Int) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.ADD_BOOKMARK, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let bookmarkId = result["data"] as? Int {
                                completion(bookmarkId)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetMyBookmark(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_MY_BOOKMARK, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToRemoveBookmark(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.REMOVE_BOOKMARK, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Payment Card
    func serviceCallToGetPaymentCard(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_CARD, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToSavePaymentCard(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.SAVE_CARD, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToRemovePaymentCard(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.REMOVE_CARD, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToSetPrimaryPaymentCard(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.SET_PRIMARY_CARD, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToSaveBankAccount(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.SAVE_CARD, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Deposite Withdraw
    func serviceCallToDepositeAmount(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.DEPOSITE_AMOUNT, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToWithdrawAmount(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.WITHDRAW_AMOUNT, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetDepositeHistory(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_DEPOSITE_HISTORY, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data = result["data"] as? [[String : Any]] {
                                completion(data)
                            }else{
                                completion([[String : Any]]())
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetWithdrawHistory(_ param : [String : Any], _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_WITHDRAW_HISTORY, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data = result["data"] as? [[String : Any]] {
                                completion(data)
                            }else{
                                completion([[String : Any]]())
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Package
    func serviceCallToGetPackage(_ param : [String : Any], _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_PACKAGE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data = result["data"] as? [String : Any] {
                                completion(data)
                                return
                            }
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToPurchasePackage(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.PURCHASE_PACKAGE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            self.serviceCallToGetMyPackage(["userid":AppModel.shared.currentUser.userid!])
                            completion()
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetMyPackage(_ param : [String : Any]) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_MY_PACKAGE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data = result["data"] as? [[String : Any]] {
                                setPurchasePackageData(data)
                                return
                            }
                        }else{
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Shipping Calculator
    func serviceCallToGetShippingPrice(_ param : [String : Any], _ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.SHIPPING_CALCULATOR, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data = result["data"] as? [String:Any] {
                                completion(data)
                            }
                            
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- FAQs
    func serviceCallToGetFaqList(_ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.FAQ, method: .post, parameters: [String : Any](), encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data = result["data"] as? [[String:Any]] {
                                completion(data)
                            }
                            
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Contact
    func serviceCallToUploadContactUs(_ image : UIImage, completion: @escaping (_ path : String) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        
        let headerParams :[String : String] = getJsonHeaderWithToken()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                multipartFormData.append(imageData, withName: "contactfileupload", fileName: "contactfileupload.jpg", mimeType: "image/jpg")
            }
            
        }, usingThreshold: UInt64.init(), to: API.CONTACT_UPLOAD, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    printData("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    removeLoader()
                    if let result = response.result.value as? [String:Any] {
                        printData(result)
                        if let status = result["status"] as? String {
                            if(status == "success") {
                                if let data : [String : Any] = result["data"] as? [String : Any] {
                                    if let path : String = data["path"] as? String {
                                        completion(path)
                                    }
                                }
                                return
                            }
                            else
                            {
                                self.handleStatusCode(result)
                            }
                        }
                    }
                    else if let error = response.error{
                        displayToast(error.localizedDescription)
                        printData(error.localizedDescription)
                        return
                    }
                    //displayToast("Registeration error")
                }
            case .failure(let error):
                removeLoader()
                printData(error.localizedDescription)
                break
            }
        }
    }
    
    func serviceCallToContactUs(_ param : [String : Any], _ completion: @escaping () -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.CONTACT_US, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    printData(result)
                    completion()
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetNotification(_ completion: @escaping (_ data : [String : Any]) -> Void) {
        if !isUserLogin() {
            return
        }
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        showLoader()
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_NOTIFICATION, method: .post, parameters: ["userid" : AppModel.shared.currentUser.userid!], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                    printData(result)
                    if let data = result["data"] as? [String : Any] {
                        completion(data)
                    }
                    return
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    //MARK:- Get City Country Data
    func serviceCallToGetCountryList(_ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        
        Alamofire.request(API.GET_COUNTRY, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
//                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetCityList(_ country_id : String, _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        
        Alamofire.request(API.GET_CITY, method: .post, parameters: ["countryid":country_id], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
//                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetAuctionCategoryList(_ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        showLoader()
        Alamofire.request(API.GET_AUCTION_CATEGORY, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetCategoryList(_ param : [String : Any], _ isLoaderDisplay : Bool, _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        if isLoaderDisplay {
            showLoader()
        }
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_CATEGORY, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetChildCategory(_ catid : String, _ completion: @escaping (_ data : [[String : Any]]) -> Void) {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        printData(catid)
        showLoader()
        Alamofire.request(API.GET_CHILD_CATEGORY, method: .post, parameters: ["catid":catid], encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            removeLoader()
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [[String : Any]] = result["data"] as? [[String : Any]] {
                                completion(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func serviceCallToGetFeaturedPrice() {
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        let headerParams :[String : String] = getJsonHeader()
        Alamofire.request(API.GET_FEATURED_PRICE, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            switch response.result {
            case .success:
                printData(response.result.value!)
                if let result = response.result.value as? [String:Any] {
                
                    if let status = result["status"] as? String {
                        if(status == "success") {
                            if let data : [String : Any] = result["data"] as? [String : Any] {
                                setFeaturedPriceData(data)
                            }
                            return
                        }
                        else
                        {
                            self.handleStatusCode(result)
                        }
                    }
                }
                if let error = response.result.error
                {
                    displayToast(error.localizedDescription)
                    return
                }
                break
            case .failure(let error):
                printData(error)
                break
            }
        }
    }
    
    func handleStatusCode(_ result : [String : Any])
    {
        /*Mising Required Properites: 101
         Backend Connection Error with other hosts: 102
         Generic Error: Defaults to 400 but could be generalized at programming level.
         User not found: 103
         Number not registered: 107
         Success: 100
         Login Authentication Failure: 104
         Missing Authorization header in API call: 400
         Missing refresh token in API call: 400
         OTP Error: 108
         Nothing Modified. No changes made at backend: 105
         Invalid access token/ Expired access token: 106
         Phone number already taken: 107*/
        
        if let code = result["code"] as? Int {
            switch code {
            case 102:
                displayToast("backend_connection_error")
                break
            case 103:
                displayToast("user_not_found")
                break
            case 401:
                displayToast(result["message"] as! String)
                break
            default:
                if let message = result["message"] as? String {
                    displayToast(message)
                }
                break
            }
        }
    }
    
}
