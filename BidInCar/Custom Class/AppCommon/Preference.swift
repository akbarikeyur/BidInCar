//
//  Preference.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

class Preference: NSObject {

    static let sharedInstance = Preference()
    
    let IS_USER_LOGIN_KEY       =   "IS_USER_LOGIN"
    let USER_DATA_KEY           =   "USER_DATA"
    let MUSIC_DATA_KEY          =   "MUSIC_DATA_KEY"
}


func setDataToPreference(data: AnyObject, forKey key: String)
{
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

func getDataFromPreference(key: String) -> AnyObject?
{
    return UserDefaults.standard.object(forKey: key) as AnyObject?
}

func removeDataFromPreference(key: String)
{
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaultValues()
{
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}

//MARK: - Access Token
func setAccessToken(_ token: String)
{
    setDataToPreference(data: token as AnyObject, forKey: "user_access_token")
}

func getAccessToken() -> String
{
    if let token : String = getDataFromPreference(key: "user_access_token") as? String
    {
        return token
    }
    return ""
}

//MARK: - Country List
func setCountryData(_ data: [[String : Any]])
{
    setDataToPreference(data: data as AnyObject, forKey: "country_list")
}

func getCountryData() -> [CountryModel]
{
    var allCountry = [CountryModel]()
    if let data : [[String : Any]] = getDataFromPreference(key: "country_list") as? [[String : Any]]
    {
        for temp in data {
            allCountry.append(CountryModel.init(dict: temp))
        }
        return allCountry
    }
    return allCountry
}

//MARK: - Login User Data
func setLoginUserData()
{
    setDataToPreference(data: AppModel.shared.currentUser.dictionary() as AnyObject, forKey: "login_user_data")
    setUserLogin(true)
    if AppModel.shared.currentUser.user_accountype == "buyer" {
        setUserBuyer(true)
    }else{
        setUserBuyer(false)
    }
}

func getLoginUserData() -> UserModel
{
    if let data : [String : Any] = getDataFromPreference(key: "login_user_data") as? [String : Any]
    {
        return UserModel.init(dict: data)
    }
    return UserModel.init()
}

func setUserLogin(_ value: Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: "is_user_login")
}

func isUserLogin() -> Bool
{
    if let value : Bool = getDataFromPreference(key: "is_user_login") as? Bool
    {
        return value
    }
    return false
}

func setUserBuyer(_ value: Bool)
{
    setDataToPreference(data: value as AnyObject, forKey: "is_user_buyer")
}

func isUserBuyer() -> Bool
{
    if let value : Bool = getDataFromPreference(key: "is_user_buyer") as? Bool
    {
        return value
    }
    return false
}

func setCategoryData(_ data: [[String : Any]])
{
    setDataToPreference(data: data as AnyObject, forKey: "cayegory_data")
}

func getCategoryData() -> [AuctionTypeModel]
{
    var arrData = [AuctionTypeModel]()
    if let data : [[String : Any]] = getDataFromPreference(key: "cayegory_data") as? [[String : Any]]
    {
        for temp in data {
            arrData.append(AuctionTypeModel.init(dict: temp))
        }
    }
    return arrData
}

func setPrimaryCard(_ value: String)
{
    setDataToPreference(data: value as AnyObject, forKey: "primary_card_number")
}

func getPrimaryCard() -> String
{
    if let value : String = getDataFromPreference(key: "primary_card_number") as? String
    {
        return value
    }
    return ""
}

func setPurchasePackageData(_ data: [[String : Any]])
{
    var arrPackage = [PackageModel]()
    for temp in data {
        arrPackage.append(PackageModel.init(dict: temp))
    }
    var arrData = [[String : Any]]()
    for temp in arrPackage {
        arrData.append(temp.dictionary())
    }
    setDataToPreference(data: arrData as AnyObject, forKey: "purchase_package_data")
}

func getPurchasePackageData() -> [PackageModel]
{
    var arrPackage = [PackageModel]()
    if let data : [[String : Any]] = getDataFromPreference(key: "purchase_package_data") as? [[String : Any]]
    {
        for temp in data {
            arrPackage.append(PackageModel.init(dict: temp))
        }
    }
    return arrPackage
}

func setFeaturedPriceData(_ data: [String : Any])
{
    setDataToPreference(data: data as AnyObject, forKey: "featured_price_data")
}

func getFeaturedPriceData() -> PackageFeatureModel
{
    if let data : [String : Any] = getDataFromPreference(key: "featured_price_data") as? [String : Any]
    {
        return PackageFeatureModel.init(dict: data)
    }
    return PackageFeatureModel.init(dict: [String : Any]())
}

func setReminderData(_ data : [String : Any])
{
    setDataToPreference(data: data as AnyObject, forKey: "auction_close_reminder_data")
}

func setNewReminder(_ key : String, _ value : String)
{
    if var data : [String : Any] = getDataFromPreference(key: "auction_close_reminder_data") as? [String : Any]
    {
        data[key] = value
        setReminderData(data)
    }
}

func getReminderData() -> [String : Any]
{
    var reminderData = [String : Any]()
    if let data : [String : Any] = getDataFromPreference(key: "auction_close_reminder_data") as? [String : Any]
    {
        reminderData = data
    }
    return reminderData
}

//MARK: - Push notification device token
func setPushToken(_ token: String)
{
    setDataToPreference(data: token as AnyObject, forKey: "PUSH_DEVICE_TOKEN")
}

func getPushToken() -> String
{
    if let token : String = getDataFromPreference(key: "PUSH_DEVICE_TOKEN") as? String
    {
        return token
    }
    return AppDelegate().sharedDelegate().getFCMToken()
}

func savePackageHistory(_ data : [[String : Any]])
{
    var arrData = [[String : Any]]()
    for temp in data {
        arrData.append(PackageHistoryModel.init(temp).dictionary())
    }
    setDataToPreference(data: arrData as AnyObject, forKey: "PACKAGE_HISTORY")
}

func getPackageHistory() -> [PackageHistoryModel]
{
    var arrPackage = [PackageHistoryModel]()
    if let data : [[String : Any]] = getDataFromPreference(key: "PACKAGE_HISTORY") as? [[String : Any]] {
        for temp in data {
            arrPackage.append(PackageHistoryModel.init(temp))
        }
    }
    return arrPackage
}

func saveBuyerTopData(_ data : [String : Any])
{
    setDataToPreference(data: data as AnyObject, forKey: "BUYER_TOP_DATA")
}

func getBuyerTopData() -> [String : Any]
{
    if let data : [String : Any] = getDataFromPreference(key: "BUYER_TOP_DATA") as? [String : Any] {
        return data
    }
    return [String : Any]()
}

func saveSellerTopData(_ data : [String : Any])
{
    setDataToPreference(data: data as AnyObject, forKey: "SELLER_TOP_DATA")
}

func getSellreTopData() -> [String : Any]
{
    if let data : [String : Any] = getDataFromPreference(key: "SELLER_TOP_DATA") as? [String : Any] {
        return data
    }
    return [String : Any]()
}
