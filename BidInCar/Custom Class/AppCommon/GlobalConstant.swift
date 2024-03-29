//
//  GlobalConstant.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation
import UIKit


let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let DEVICE_ID = UIDevice.current.identifierForVendor?.uuidString
let APPLE_LANGUAGE_KEY = "AppleLanguages"
let APP_STORE_URL = "https://apps.apple.com/us/app/bidincars-auctions/id1559354497"

/*
Social Account
Email : bidincar@gmail.com
Password : Bidcar@2019
*/

let GOOGLE_CLIENT_ID = "335995289028-8q0t81lmf0jbgopkcencf17j9f1ar56j.apps.googleusercontent.com"
let GOOGLE_KEY = "335995289028-8q0t81lmf0jbgopkcencf17j9f1ar56j.apps.googleusercontent.com"
let PLACE_API_KEY = ""

let TWITTER_API_KEY = ""
let TWITTER_API_SECRET_KEY = ""
let TWITTER_ACCESS_TOKEN = ""
let TWITTER_ACCESS_SECRET_TOKEN = ""

//Sandbox
//let PAYPAL_CLIENT_ID = "ASkI6VdfQAeRyNDe5Enbel_8DOG_8uwd6OnHewxnUsd8GdKajObFyCCpMgiNhnr5kpBJ3LfAfgyDCrmA"
//let PAYPAL_SECRET = "EMT6w-Fo4NxdNJkOoQL4DGEHPXbLMh9zdi3bU1azcaJ_JMxQtb371iUekDiiucN-KzyagSW0JJFgNXQq"
//Live
let PAYPAL_CLIENT_ID = ""
let PAYPAL_SECRET = ""

let PAYTAB_KEY = ""

let TERMS_URL = "https://www.bidincars.com/api_termsandcondition"
let POLICY_URL = "https://www.bidincars.com/api_privacy_policy"

let MONTH_ARRAY = [NSLocalizedString("month_jan", comment: ""), NSLocalizedString("month_feb", comment: ""), NSLocalizedString("month_mar", comment: ""), NSLocalizedString("month_apr", comment: ""), NSLocalizedString("month_may", comment: ""), NSLocalizedString("month_jun", comment: ""), NSLocalizedString("month_jul", comment: ""), NSLocalizedString("month_aug", comment: ""), NSLocalizedString("month_sept", comment: ""), NSLocalizedString("month_oct", comment: ""), NSLocalizedString("month_nov", comment: ""), NSLocalizedString("month_dec", comment: "")]

let CAR_COLOR = ["White","Yellow","Blue","Red","Green","Black","Brown","Azure","Ivory","Teal","Silver","Purple","Navy blue","Pea green","Gray","Orange","Maroon","Charcoal","Aquamarine","Coral","Fuchsia","Wheat","Lime","Crimson","Khaki","Hot pink","Magenta","Olden","Plum","Olive","Cyan"]

let BOAT_LENGTH = ["Select Boat Length", "Less than 10 feet", "10-15 feet", "15-20 feet", "20-25 feet", "25-30 feet", "30+ feet", "50+ feet", "100+ feet"]
let BOAT_AGE = ["Select Boat Age", "New", "Less than 1 year", "1-2 years", "2-4 years", "4-8 years", "8+ years"]
let BOAT_WARRANTY = ["Select Boat Warranty", "0-1 Year", "1 Year+", "No warranty"]

struct SCREEN
{
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}

struct DATE_FORMAT {
    static var SERVER_DATE_FORMAT = "YYYY-MM-dd"
    static var SERVER_TIME_FORMAT = "HH:mm"
    static var SERVER_DATE_TIME_FORMAT = "yyyy-MM-dd" //HH:mm:ss"
    static var DISPLAY_DATE_FORMAT = "dd/MM/yyyy"
    static var DISPLAY_DATE_FORMAT1 = "MM/dd/yyyy"
    static var DISPLAY_TIME_FORMAT = "hh:mm a"
    static var DISPLAY_DATE_TIME_FORMAT = "YYYY-MM-dd HH:mm:ss"
}

struct CONSTANT{
    static var DP_IMAGE_WIDTH     =  1000
    static var DP_IMAGE_HEIGHT    =  1000
    
    static let MAX_EMAIL_CHAR = 254
    static let MAX_PREFER_NAME_CHAR = 40
    static let MIN_PWD_CHAR = 8
    static let MAX_PWD_CHAR = 16
    static let MAX_FIRST_NAME_CHAR = 40
    static let MAX_MIDDLE_NAME_CHAR = 40
    static let MAX_LAST_NAME_CHAR = 40
    
    static let DOB_CHAR = 8
    static let DOB_SPACE_CHAR = 4
    static let DOB_DATE_CHAR = 2
    static let DOB_MONTH_CHAR = 2
    static let DOB_YEAR_CHAR = 4
    
    static let MOBILE_NUMBER_CHAR = 8
    static let MOBILE_NUMBER_SPACE_CHAR = 2
    static let MOBILE_NUMBER_CODE = ""
    
    static let CARD_NUMBER_CHAR = 16
    static let CARD_NUMBER_DASH_CHAR = 3
    static let CARD_EXP_DATE_CHAR = 5
    static let CARD_CVV_CHAR = 3
    
    static let SMS_CODE_CHAR = 4
    static let SMS_CODE_SPACE_CHAR = 3
    
    static let IMAGE_QUALITY   =  1
    
    static let CURRENCY   =  "AED"
    static let DIST_MEASURE   =  "km"
    static let TIME_ZONE = "Australia/Sydney"
    
    static let DEF_TAKE : Int = 24
    
    
}

struct MEDIA {
    static var IMAGE = "IMAGE"
    static var VIDEO = "VIDEO"
}

struct IMAGE {
    static var USER_PLACEHOLDER = "user_placeholder"
    static var AUCTION_PLACEHOLDER = "ic_placeholder"
}

struct STORYBOARD {
    static var MAIN = UIStoryboard(name: "Main", bundle: nil)
    static var HOME = UIStoryboard(name: "Home", bundle: nil)
    static var AUCTION = UIStoryboard(name: "Auction", bundle: nil)
    static var SETTING = UIStoryboard(name: "Setting", bundle: nil)
}

struct NOTIFICATION {
    static var UPDATE_CURRENT_USER_DATA     =   "UPDATE_CURRENT_USER_DATA"
    static var UPDATE_AUCTION_DATA          =   "UPDATE_AUCTION_DATA"
    static var UPDATE_CARD_DETAIL           =   "UPDATE_CARD_DETAIL"
    static var REDIRECT_TO_HOME             =   "REDIRECT_TO_HOME"
    static var WITHDRAW_BID_DATA            =   "WITHDRAW_BID_DATA"
    static var AUCTION_FEATURED_DATA        =   "AUCTION_FEATURED_DATA"
    static var REMOVE_AUCTION_DATA          =   "REMOVE_AUCTION_DATA"
    static var REDIRECT_TO_DRAFT            =   "REDIRECT_TO_DRAFT"
    static var REDIRECT_TO_MY_PROFILE            =   "REDIRECT_TO_MY_PROFILE"
    static var REDIRECT_DASHBOARD_TOP_DATA            =   "REDIRECT_DASHBOARD_TOP_DATA"
    static var REDIRECT_NOTIFICATION_SCREEN            =   "REDIRECT_NOTIFICATION_SCREEN"
    static var REDIRECT_BUYER_PAYMENT            =   "REDIRECT_BUYER_PAYMENT"
    static var OPEN_ADD_DEPOSIT            =   "OPEN_ADD_DEPOSIT"
    static var REFRESH_DEPOSIE_AMOUNT            =   "REFRESH_DEPOSIE_AMOUNT"
}



struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

struct PAYMENT {
    static let PACKAGE = "Package_payment"
    static let DEPOSITE = "deposite_payment"
    static let FEATURED = "featured_payment"
    static let AUCTION = "auction_payment"
}
