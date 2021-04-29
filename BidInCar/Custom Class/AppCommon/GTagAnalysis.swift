//
//  GTagAnalysis.swift
//  BidInCar
//
//  Created by Keyur on 24/04/21.
//  Copyright © 2021 Amisha. All rights reserved.
//

import Foundation

func addButtonEvent(_ title : String, _ action : String, _ screenName : String) {
    var param = [String : Any]()
    param["device"] = "iOS"
    param["version"] = APP_VERSION
    param["action"] = action
    param["page"] = screenName
    AppDelegate().sharedDelegate().logEvent("button_click_" + title, param)
}

struct EVENT {
    struct TITLE {
        static let LOGIN = "login"
        static let KEEP_LOGIN = "keep_login"
        static let SIGNUP = "sigup"
        static let SKIP_HOME = "skip_home"
        static let GOOGLE_LOGIN = "google_login"
        static let FACEBOOK_LOGIN = "google_login"
        static let APPLE_LOGIN = "google_login"
        static let EMAIL_LOGIN = "email_login"
        static let FORGOT_PASSWORD = "forgot_password"
        static let TERMS = "terms"
        static let POLICY = "policy"
        static let NOTIFICATION = "notification"
        static let AUCTION_DETAIL = "auction_detail"
        static let FILTER = "filter"
        static let ADD_WISHLIST = "add_wishlist"
        static let REMOVE_WISHLIST = "remove_wishlist"
        static let ADD_DEPOSIT = "add_deposit"
        static let PACKAGE = "package"
        static let BIDNOW = "bidnow"
        static let INSPECT_REPORT = "inspect_report"
        static let HOME = "home"
        static let MY_AUCTION_BUYER = "my_auction_buyer"
        static let MY_AUCTION_SELLER = "my_auction_seller"
        static let WISHLIST = "wishlist"
        static let MY_PROFILE = "my_profile"
        static let CONTACT_US = "contact_us"
        static let CHANGE_ARABIC = "change_arabic"
        static let CHANGE_ENGLISH = "change_english"
        static let LOGOUT = "logout"
        static let POST_AUCTION = "post_auction"
        static let BID_DEAIL = "bid_detail"
        static let MAKE_FEATURE = "make_feature"
        static let EDIT_PROFILE = "edit_profile"
        static let NOTIFICATION_SETTING = "notification_setting"
        static let CHANGE_PASSWORD = "change_password"
        static let CONTACT_ADMIN = "contact_admin"
    }
    
    struct ACTION {
        static let LOGIN = "Redirect to login screen"
        static let KEEP_LOGIN = "Save login"
        static let SIGNUP = "Redirect to signup screen"
        static let SKIP_HOME = "Redirect to Home"
        static let GOOGLE_LOGIN = "Google login"
        static let FACEBOOK_LOGIN = "Facebook login"
        static let APPLE_LOGIN = "Apple login"
        static let EMAIL_LOGIN = "Email login"
        static let FORGOT_PASSWORD = "Redirect to forgot password"
        static let TERMS = "Redirect to terms condition screen"
        static let POLICY = "Redirect to privacy policy screen"
        static let NOTIFICATION = "Redirect to notification screen"
        static let AUCTION_DETAIL = "Redirect to auction detail screen"
        static let FILTER = "Redirect to filter screen"
        static let ADD_WISHLIST = "Auction add to wishlist"
        static let REMOVE_WISHLIST = "Auction remove from wishlist"
        static let ADD_DEPOSIT = "Add deposit amount"
        static let PACKAGE = "Redirect to package screen"
        static let BIDNOW = "Add Bid on auction"
        static let INSPECT_REPORT = "Download inspect report"
        static let HOME = "Redirect to Home"
        static let MY_AUCTION_BUYER = "Redirect to My Auction Buyer"
        static let MY_AUCTION_SELLER = "Redirect to My Auction Seller"
        static let WISHLIST = "Redirect to My Wishlist"
        static let MY_PROFILE = "Redirect to My Profile"
        static let CONTACT_US = "Redirect to Contact us"
        static let CHANGE_ARABIC = "Change to arabic language"
        static let CHANGE_ENGLISH = "Change to english language"
        static let LOGOUT = "Logout from app"
        static let POST_AUCTION = "Post Auction"
        static let BID_DEAIL = "Redirect to auction bid detail"
        static let MAKE_FEATURE = "Make auction featured"
        static let EDIT_PROFILE = "Edit Profile"
        static let NOTIFICATION_SETTING = "Change Notification On Off"
        static let CHANGE_PASSWORD = "Change Password"
        static let CONTACT_ADMIN = "Contact Admin"
    }
    
}
