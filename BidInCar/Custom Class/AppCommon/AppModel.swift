//
//  AppModel.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//
import UIKit


class AppModel: NSObject {
    static let shared = AppModel()
    var currentUser : UserModel!
    var AUCTION_DATA : [String : [AuctionModel]]!
    var AUCTION_TYPE : [AuctionTypeModel]!
    
    func resetAllModel()
    {
        currentUser = UserModel.init()
        AUCTION_DATA = [String : [AuctionModel]]()
        AUCTION_TYPE = [AuctionTypeModel]()
    }
    
    func getIntValue(_ dict : [String : Any], _ key : String) -> Int {
        if let temp = dict[key] as? Int {
            return temp
        }
        else if let temp = dict[key] as? String, temp != "" {
            return Int(temp)!
        }
        else if let temp = dict[key] as? Float {
            return Int(temp)
        }
        else if let temp = dict[key] as? Double {
            return Int(temp)
        }
        return 0
    }
    
    func getStringValue(_ dict : [String : Any], _ key : String) -> String {
        if let temp = dict[key] as? String {
            return temp
        }
        else if let temp = dict[key] as? Int {
            return String(temp)
        }
        else if let temp = dict[key] as? Float {
            return String(temp)
        }
        else if let temp = dict[key] as? Double {
            return String(temp)
        }
        return ""
    }
    
    func getFloatValue(_ dict : [String : Any], _ key : String) -> Float {
        if let temp = dict[key] as? Float {
            return temp
        }
        else if let temp = dict[key] as? String, temp != "" {
            return Float(temp)!
        }
        else if let temp = dict[key] as? Int {
            return Float(temp)
        }
        else if let temp = dict[key] as? Double {
            return Float(temp)
        }
        return 0
    }
    
    func getDoubleValue(_ dict : [String : Any], _ key : String) -> Double {
        if let temp = dict[key] as? Double {
            return temp
        }
        else if let temp = dict[key] as? String, temp != "" {
            return Double(temp)!
        }
        else if let temp = dict[key] as? Int {
            return Double(temp)
        }
        else if let temp = dict[key] as? Float {
            return Double(temp)
        }
        return 0
    }
    
}
class UserModel : AppModel
{
    var userid : String!
    var profile_pic : String!
    var user_accountype : String!
    var user_buildingname : String!
    var user_cityid : String!
    var user_countryid : String!
    var user_deposit : String!
    var biding_limit : String!
    var user_email : String!
    var user_flatnumber : String!
    var user_lastname : String!
    var user_name : String!
    var user_password : String!
    var user_phonenumber : String!
    var user_pobox : String!
    var user_postingtype : String!
    var user_status : String!
    var user_streetaddress : String!
    var city_name : String!
    var country_name : String!
    var sortname : String!
    var phonecode : String!
    var verified : Bool!
    var notification : String!
    var user_company : CompanyModel!
    
    override init(){
        userid = ""
        profile_pic = ""
        user_accountype = ""
        user_buildingname = ""
        user_cityid = ""
        user_countryid = ""
        user_deposit = "0"
        biding_limit = "0"
        user_email = ""
        user_flatnumber = ""
        user_lastname = ""
        user_name = ""
        user_password = ""
        user_phonenumber = ""
        user_pobox = ""
        user_postingtype = ""
        user_status = ""
        user_streetaddress = ""
        city_name = ""
        country_name = ""
        sortname = ""
        phonecode = ""
        verified = false
        notification = "on"
        user_company = CompanyModel.init([String : Any]())
    }
    
    init(dict : [String : Any])
    {
        userid = ""
        profile_pic = ""
        user_accountype = ""
        user_buildingname = ""
        user_cityid = ""
        user_countryid = ""
        user_deposit = "0"
        biding_limit = "0"
        user_email = ""
        user_flatnumber = ""
        user_lastname = ""
        user_name = ""
        user_password = ""
        user_phonenumber = ""
        user_pobox = ""
        user_postingtype = ""
        user_status = ""
        user_streetaddress = ""
        city_name = ""
        country_name = ""
        sortname = ""
        phonecode = ""
        verified = false
        notification = "on"
        user_company = CompanyModel.init([String : Any]())
        
        userid = AppModel.shared.getStringValue(dict, "userid")
        if let temp = dict["profile_pic"] as? String {
            profile_pic = temp
        }
        if let temp = dict["user_accountype"] as? String {
            user_accountype = temp
        }
        if let temp = dict["user_buildingname"] as? String {
            user_buildingname = temp
        }
        user_cityid = AppModel.shared.getStringValue(dict, "user_cityid")
        user_countryid = AppModel.shared.getStringValue(dict, "user_countryid")
        user_deposit = AppModel.shared.getStringValue(dict, "user_deposit")
        biding_limit = AppModel.shared.getStringValue(dict, "biding_limit")
        if let temp = dict["user_email"] as? String {
            user_email = temp
        }
        if let temp = dict["user_flatnumber"] as? String {
            user_flatnumber = temp
        }
        if let temp = dict["user_lastname"] as? String {
            user_lastname = temp
        }
        if let temp = dict["user_name"] as? String {
            user_name = temp
        }
        if let temp = dict["user_password"] as? String {
            user_password = temp
        }
        if let temp = dict["user_phonenumber"] as? String {
            user_phonenumber = temp
        }
        if let temp = dict["user_pobox"] as? String {
            user_pobox = temp
        }
        if let temp = dict["user_postingtype"] as? String {
            user_postingtype = temp
        }
        if let temp = dict["user_status"] as? String {
            user_status = temp
        }
        if let temp = dict["user_streetaddress"] as? String {
            user_streetaddress = temp
        }
        if let temp = dict["city_name"] as? String {
            city_name = temp
        }
        if let temp = dict["country_name"] as? String {
            country_name = temp
        }
        if let temp = dict["sortname"] as? String {
            sortname = temp
        }
        if let temp = dict["phonecode"] as? String {
            phonecode = temp
        }
        if let temp = dict["verified"] as? Bool {
            verified = temp
        }
        else if let temp = dict["verified"] as? String {
            if temp == "true" {
                verified = true
            }
            else{
                verified = false
            }
        }
        notification = dict["notification"] as? String ?? "on"
        user_company = CompanyModel.init(dict["user_company"] as? [String : Any] ?? [String : Any]())
    }
    
    func dictionary() -> [String:Any]  {
        return ["userid":userid!, "profile_pic":profile_pic!, "user_accountype":user_accountype!, "user_buildingname":user_buildingname!, "user_cityid":user_cityid!, "user_countryid":user_countryid!, "user_deposit":user_deposit!, "user_email":user_email!, "user_flatnumber":user_flatnumber!, "user_lastname":user_lastname!, "user_name":user_name!, "user_password":user_password!, "user_phonenumber":user_phonenumber!, "user_pobox":user_pobox!, "user_postingtype":user_postingtype!, "user_status":user_status!, "user_streetaddress":user_streetaddress!, "city_name":city_name!, "country_name":country_name!, "sortname":sortname!, "phonecode":phonecode!, "biding_limit" : biding_limit!, "verified" : verified!, "notification" : notification!, "user_company" : user_company.dictionary()]
    }
}

class CompanyModel : AppModel
{
    var companyid : String!
    var company_name : String!
    var company_address : String!
    var company_email : String!
    var company_phone : String!
    
    init(_ dict : [String : Any]) {
        companyid = AppModel.shared.getStringValue(dict, "companyid")
        company_name = dict["company_name"] as? String ?? ""
        company_address = dict["company_address"] as? String ?? ""
        company_email = dict["company_email"] as? String ?? ""
        company_phone = dict["company_phone"] as? String ?? ""
    }
    
    func dictionary() -> [String : Any] {
        return ["companyid" : companyid!, "company_name" : company_name!, "company_address" : company_address!, "company_email" : company_email!, "company_phone" : company_phone!]
    }
}

class AuctionModel : AppModel
{
    var auctionid : String!
    var auction_title : String!
    var auction_price : String!
    var auction_bidprice : String!
    var userid : String!
    var year : String!
    var auctioncategoryid : String!
    var auctioncategorychildid : String!
    var auction_start : String!
    var auction_end : String!
    var auction_bodytype : String!
    var auction_countrymade : String!
    var auction_vin : String!
    var auction_motorno : String!
    var auction_extcolour : String!
    var auction_millage : String!
    var auction_transmission : String!
    var auction_fueltype : String!
    var auction_desc : String!
    var auction_terms : String!
    var auction_created_on : String!
    var auction_featured : String!
    var auction_status : String!
    var auction_lat : String!
    var auction_long : String!
    var auction_address : String!
    var auction_body_condition : String!
    var auction_winby : String!
    var categoryid : String!
    var category_name : String!
    var cat_created_on : String!
    var catchild_id : String!
    var catid : String!
    var catchild_name : String!
    var catchild_createdon : String!
    var countryid : String!
    var sortname : String!
    var country_name : String!
    var phonecode : String!
    var pictures : [PictureModel]!
    var autocheckupload : PictureModel!
    var active_auction_price : String!
    var auction_bidscount : String!
    var usertype : String!
    var delete_authority : String!
    var bookmark : String!
    var bookmarkid : String!
    var auction_winner : WinnerModel!
    var bookmarks : [String : Any]!
    var bidlist : [BidModel]!
    var your_bid : Int!
    var is_bid : Int!
    var auto_check_upload : String!
    var removePicture : [String]!
    var cattype : Int!
    var categorytype : String!
    var mechanical : String!
    var wheels : String!
    var drive_system : String!
    var engine_size : String!
    var body_condition : String!
    var boat_length : String!
    var interior_color : String!
    var no_of_cylinder : String!
    var doors : String!
    var auction_horse_power : String!
    var warranty : String!
    var auction_age : String!
    
    override init(){
        auctionid = "0"
        auction_title = ""
        auction_price = ""
        auction_bidprice = ""
        userid = ""
        year = ""
        auctioncategoryid = ""
        auctioncategorychildid = ""
        auction_start = ""
        auction_end = ""
        auction_bodytype = ""
        auction_countrymade = ""
        auction_vin = ""
        auction_motorno = ""
        auction_extcolour = ""
        auction_millage = ""
        auction_transmission = ""
        auction_fueltype = ""
        auction_desc = ""
        auction_terms = ""
        auction_created_on = ""
        auction_featured = ""
        auction_status = ""
        auction_lat = ""
        auction_long = ""
        auction_address = ""
        auction_body_condition = ""
        auction_winby = ""
        categoryid = ""
        category_name = ""
        cat_created_on = ""
        catchild_id = ""
        catid = ""
        catchild_name = ""
        catchild_createdon = ""
        countryid = ""
        sortname = ""
        country_name = ""
        phonecode = ""
        pictures = [PictureModel]()
        active_auction_price = ""
        auction_bidscount = ""
        usertype = ""
        delete_authority = ""
        bookmark = ""
        bookmarkid = ""
        auction_winner = WinnerModel()
        bookmarks = [String : Any]()
        bidlist = [BidModel]()
        your_bid = 0
        is_bid = 0
        auto_check_upload = ""
        removePicture = [String]()
        cattype = 0
        categorytype = ""
        mechanical = ""
        wheels = ""
        drive_system = ""
        engine_size = ""
        body_condition = ""
        boat_length = ""
        interior_color = ""
        no_of_cylinder = ""
        doors = ""
        auction_horse_power = ""
        warranty = ""
        auction_age = ""
        autocheckupload = PictureModel.init()
    }
    
    init(dict : [String : Any])
    {
        auctionid = "0"
        auction_title = ""
        auction_price = ""
        auction_bidprice = ""
        userid = ""
        year = ""
        auctioncategoryid = ""
        auctioncategorychildid = ""
        auction_start = ""
        auction_end = ""
        auction_bodytype = ""
        auction_countrymade = ""
        auction_vin = ""
        auction_motorno = ""
        auction_extcolour = ""
        auction_millage = ""
        auction_transmission = ""
        auction_fueltype = ""
        auction_desc = ""
        auction_terms = ""
        auction_created_on = ""
        auction_featured = ""
        auction_status = ""
        auction_lat = ""
        auction_long = ""
        auction_address = ""
        auction_body_condition = ""
        auction_winby = ""
        categoryid = ""
        category_name = ""
        cat_created_on = ""
        catchild_id = ""
        catid = ""
        catchild_name = ""
        catchild_createdon = ""
        countryid = ""
        sortname = ""
        country_name = ""
        phonecode = ""
        pictures = [PictureModel]()
        active_auction_price = ""
        auction_bidscount = ""
        usertype = ""
        delete_authority = ""
        bookmark = ""
        bookmarkid = ""
        auction_winner = WinnerModel()
        bookmarks = [String : Any]()
        bidlist = [BidModel]()
        your_bid = 0
        is_bid = 0
        auto_check_upload = ""
        removePicture = [String]()
        cattype = 0
        categorytype = ""
        mechanical = ""
        wheels = ""
        drive_system = ""
        engine_size = ""
        body_condition = ""
        boat_length = ""
        interior_color = ""
        no_of_cylinder = ""
        doors = ""
        auction_horse_power = ""
        warranty = ""
        auction_age = ""
        autocheckupload = PictureModel.init()
        
        auctionid = AppModel.shared.getStringValue(dict, "auctionid")
        if let temp = dict["auction_title"] as? String {
            auction_title = temp
        }
        if let temp = dict["auction_price"] as? String {
            auction_price = temp
        }
        else if let temp = dict["auction_price"] as? Int {
            auction_price = String(temp)
        }
        auction_bidprice = AppModel.shared.getStringValue(dict, "auction_bidprice")
        userid = AppModel.shared.getStringValue(dict, "userid")
        if let temp = dict["year"] as? String {
            year = temp
        } else if let temp = dict["auction_year"] as? String {
            year = temp
        }
        auctioncategoryid = AppModel.shared.getStringValue(dict, "auctioncategoryid")
        auctioncategorychildid = AppModel.shared.getStringValue(dict, "auctioncategorychildid")
        if let temp = dict["auction_start"] as? String {
            auction_start = temp
        }
        if let temp = dict["auction_end"] as? String {
            auction_end = temp
        }
        if let temp = dict["auction_bodytype"] as? String {
            auction_bodytype = temp
        }
        if let temp = dict["auction_countrymade"] as? String {
            auction_countrymade = temp
        }
        if let temp = dict["auction_vin"] as? String {
            auction_vin = temp
        }
        if let temp = dict["auction_motorno"] as? String {
            auction_motorno = temp
        }
        if let temp = dict["auction_extcolour"] as? String {
            auction_extcolour = temp
        }
        if let temp = dict["auction_millage"] as? String {
            auction_millage = temp
        }
        if let temp = dict["auction_transmission"] as? String {
            auction_transmission = temp
        }
        if let temp = dict["auction_fueltype"] as? String {
            auction_fueltype = temp
        }
        if let temp = dict["auction_desc"] as? String {
            auction_desc = temp
        }
        if let temp = dict["auction_terms"] as? String {
            auction_terms = temp
        }
        if let temp = dict["auction_created_on"] as? String {
            auction_created_on = temp
        }
        if let temp = dict["auction_featured"] as? String {
            auction_featured = temp
        }
        if let temp = dict["auction_status"] as? String {
            auction_status = temp
        }
        if let temp = dict["auction_lat"] as? String {
            auction_lat = temp
        }
        if let temp = dict["auction_long"] as? String {
            auction_long = temp
        }
        if let temp = dict["auction_address"] as? String {
            auction_address = temp
        }
        if let temp = dict["auction_body_condition"] as? String {
            auction_body_condition = temp
        }
        if let temp = dict["auction_winby"] as? String {
            auction_winby = temp
        }
        if let temp = dict["categoryid"] as? String {
            categoryid = temp
        }
        if let temp = dict["categories"] as? String {
            categoryid = temp
        }
        if let temp = dict["category_name"] as? String {
            category_name = temp
        }
        else if let temp = dict["categories_name"] as? String {
            category_name = temp
        }
        if let temp = dict["cat_created_on"] as? String {
            cat_created_on = temp
        }
        catchild_id = AppModel.shared.getStringValue(dict, "catchild_id")
        catid = AppModel.shared.getStringValue(dict, "catid")
        if let temp = dict["catchild_name"] as? String {
            catchild_name = temp
        }
        if let temp = dict["catchild_createdon"] as? String {
            catchild_createdon = temp
        }
        countryid = AppModel.shared.getStringValue(dict, "countryid")
        if let temp = dict["sortname"] as? String {
            sortname = temp
        }
        if let temp = dict["country_name"] as? String {
            country_name = temp
        }
        if let temp = dict["phonecode"] as? String {
            phonecode = temp
        }
        if let tempData = dict["pictures"] as? [[String : Any]] {
            for temp in tempData {
                pictures.append(PictureModel.init(dict: temp))
            }
        }
        if let temp = dict["active_auction_price"] as? String {
            active_auction_price = temp
        }
        else if let temp = dict["active_auction_price"] as? Int {
            active_auction_price = String(temp)
        }
        if let temp = dict["auction_bidscount"] as? String {
            auction_bidscount = temp
        }
        else if let temp = dict["auction_bidscount"] as? Int {
            auction_bidscount = String(temp)
        }
        if let temp = dict["usertype"] as? String {
            usertype = temp
        }
        if let temp = dict["delete_authority"] as? String {
            delete_authority = temp
        }
        if let temp = dict["bookmark"] as? String {
            bookmark = temp
        }
        bookmarkid = AppModel.shared.getStringValue(dict, "bookmarkid")
        if let temp = dict["auction_winner"] as? [String : Any] {
            auction_winner = WinnerModel.init(dict: temp)
        }
        if let temp = dict["bookmarks"] as? [String : Any] {
            if let temp1 = temp["bookmark"] as? String {
                bookmark = temp1
            }
            if let temp1 = temp["bookmarkid"] as? String {
                bookmarkid = temp1
            }
        }
        if let tempData = dict["bidlist"] as? [[String : Any]] {
            for temp in tempData {
                bidlist.append(BidModel.init(dict: temp))
            }
        }
        your_bid = AppModel.shared.getIntValue(dict, "your_bid")
        if let temp = dict["is_bid"] as? Int {
            is_bid = temp
        }
        if let temp = dict["auto_check_upload"] as? String {
            auto_check_upload = temp
        }
        if let temp = dict["removePicture"] as? [String] {
            removePicture = temp
        }
        if let temp = dict["cattype"] as? String {
            cattype = Int(temp)
        }
        if let temp = dict["categorytype"] as? String {
            categorytype = temp
        }
        if let temp = dict["mechanical"] as? String {
            mechanical = temp
        }
        if let temp = dict["wheels"] as? String {
            wheels = temp
        }
        if let temp = dict["drive_system"] as? String {
            drive_system = temp
        }
        if let temp = dict["engine_size"] as? String {
            engine_size = temp
        }
        if let temp = dict["body_condition"] as? String {
            body_condition = temp
        }
        if let temp = dict["boat_length"] as? String {
            boat_length = temp
        }
        if let temp = dict["interior_color"] as? String {
            interior_color = temp
        }
        if let temp = dict["no_of_cylinder"] as? String {
            no_of_cylinder = temp
        }
        if let temp = dict["doors"] as? String {
            doors = temp
        }
        if let temp = dict["auction_horse_power"] as? String {
            auction_horse_power = temp
        }
        if let temp = dict["warranty"] as? String {
            warranty = temp
        }
        if let temp = dict["auction_age"] as? String {
            auction_age = temp
        }
        if let temp = dict["autocheckupload"] as? [String : Any] {
            autocheckupload = PictureModel.init(dict: temp)
        }
    }
}

class PictureModel : AppModel
{
    var apid : String!
    var auctionid : String!
    var path : String!
    var ap_uploadedon : String!
    var type : String!
    
    override init(){
        apid = ""
        auctionid = ""
        path = ""
        ap_uploadedon = ""
        type = ""
    }
    
    init(dict : [String : Any])
    {
        apid = ""
        auctionid = ""
        path = ""
        ap_uploadedon = ""
        type = ""
        
        apid = AppModel.shared.getStringValue(dict, "apid")
        auctionid = AppModel.shared.getStringValue(dict, "auctionid")
        if let temp = dict["path"] as? String {
            path = temp
        }
        if let temp = dict["ap_uploadedon"] as? String {
            ap_uploadedon = temp
        }
        if let temp = dict["type"] as? String {
            type = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["apid":apid!, "auctionid":auctionid!, "path":path!, "ap_uploadedon":ap_uploadedon!, "type":type!]
    }
}

class WinnerModel : AppModel
{
    var winner_name : String!
    var status : String!
    var winneing_price : String!
    var winnerid : String!
    
    override init(){
        winner_name = ""
        status = ""
        winneing_price = ""
        winnerid = ""
    }
    
    init(dict : [String : Any])
    {
        winner_name = ""
        status = ""
        winneing_price = ""
        winnerid = ""
        
        if let temp = dict["winner_name"] as? String {
            winner_name = temp
        }
        if let temp = dict["status"] as? String {
            status = temp
        }
        if let temp = dict["winneing_price"] as? String {
            winneing_price = temp
        }
        if let temp = dict["winnerid"] as? String {
            winnerid = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["winner_name":winner_name!, "status":status!, "winneing_price":winneing_price!, "winnerid":winnerid!]
    }
}

class BidModel : AppModel
{
    var bidid : String!
    var userid : String!
    var auctionid : String!
    var bidprice : String!
    var bidon : String!
    
    override init(){
        bidid = ""
        userid = ""
        auctionid = ""
        bidprice = ""
        bidon = ""
    }
    
    init(dict : [String : Any])
    {
        bidid = ""
        userid = ""
        auctionid = ""
        bidprice = ""
        bidon = ""
        
        if let temp = dict["bidid"] as? String {
            bidid = temp
        }
        if let temp = dict["userid"] as? String {
            userid = temp
        }
        if let temp = dict["auctionid"] as? String {
            auctionid = temp
        }
        if let temp = dict["bidprice"] as? String {
            bidprice = temp
        }
        if let temp = dict["bidon"] as? String {
            bidon = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["bidid":bidid!, "userid":userid!, "auctionid":auctionid!, "bidprice":bidprice!, "bidon":bidon!]
    }
}

//Other Data
class CountryModel : AppModel
{
    var countryid : String!
    var sortname : String!
    var country_name : String!
    var phonecode : String!
    var flag : String!
    
    override init(){
        countryid = ""
        sortname = ""
        country_name = ""
        phonecode = ""
        flag = ""
    }
    
    init(dict : [String : Any])
    {
        countryid = ""
        sortname = ""
        country_name = ""
        phonecode = ""
        flag = ""
        
        if let temp = dict["countryid"] as? String {
            countryid = temp
        }
        if let temp = dict["sortname"] as? String {
            sortname = temp
        }
        if let temp = dict["country_name"] as? String {
            country_name = temp
        }
        if let temp = dict["phonecode"] as? String {
            phonecode = temp
        }
        if let temp = dict["flag"] as? String {
            flag = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["countryid":countryid!, "sortname":sortname!, "country_name":country_name!, "phonecode":phonecode!, "flag":flag!]
    }
}

class CityModel : AppModel
{
    //{"statesid":"1","states_name":"Andaman and Nicobar Islands","country_id":"101","cityid":"1","city_name":"Bombuflat","state_id":"1"}
    var state_id : String!
    var states_name : String!
    var country_id : String!
    var cityid : String!
    var city_name : String!
    
    override init(){
        state_id = ""
        states_name = ""
        country_id = ""
        cityid = ""
        city_name = ""
    }
    
    init(dict : [String : Any])
    {
        state_id = ""
        states_name = ""
        country_id = ""
        cityid = ""
        city_name = ""
        
        if let temp = dict["state_id"] as? String {
            state_id = temp
        }
        if let temp = dict["states_name"] as? String {
            states_name = temp
        }
        if let temp = dict["country_id"] as? String {
            country_id = temp
        }
        if let temp = dict["cityid"] as? String {
            cityid = temp
        }
        if let temp = dict["city_name"] as? String {
            city_name = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["state_id":state_id!, "states_name":states_name!, "country_id":country_id!, "cityid":cityid!, "city_name":city_name!]
    }
}

//Other Data
class FaqModel : AppModel
{
    var faqid : String!
    var faq_title : String!
    var faq_desc : String!
    var faq_like : String!
    var faq_dislike : String!
    
    override init(){
        faqid = ""
        faq_title = ""
        faq_desc = ""
        faq_like = ""
        faq_dislike = ""
    }
    
    init(dict : [String : Any])
    {
        faqid = ""
        faq_title = ""
        faq_desc = ""
        faq_like = ""
        faq_dislike = ""
        
        if let temp = dict["faqid"] as? String {
            faqid = temp
        }
        if let temp = dict["faq_title"] as? String {
            faq_title = temp
        }
        if let temp = dict["faq_desc"] as? String {
            faq_desc = temp
        }
        if let temp = dict["faq_like"] as? String {
            faq_like = temp
        }
        if let temp = dict["faq_dislike"] as? String {
            faq_dislike = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["faqid":faqid!, "faq_title":faq_title!, "faq_desc":faq_desc!, "faq_like":faq_like!, "faq_dislike":faq_dislike!]
    }
}

class CardModel : AppModel
{
    var back_account_number : String!
    var bank_name : String!
    var card_primary : String!
    var cardnumber : String!
    var csv : String!
    var email : String!
    var exp_month : String!
    var exp_year : String!
    var name_on_card : String!
    var type : String!
    var user_card_id : String!
    var userid : String!
    
    override init(){
        back_account_number = ""
        bank_name = ""
        card_primary = ""
        cardnumber = ""
        csv = ""
        email = ""
        exp_month = ""
        exp_year = ""
        name_on_card = ""
        type = ""
        user_card_id = ""
        userid = ""
    }
    
    init(dict : [String : Any])
    {
        back_account_number = ""
        bank_name = ""
        card_primary = ""
        cardnumber = ""
        csv = ""
        email = ""
        exp_month = ""
        exp_year = ""
        name_on_card = ""
        type = ""
        user_card_id = ""
        userid = ""
        
        if let temp = dict["back_account_number"] as? String {
            back_account_number = temp
        }
        if let temp = dict["bank_name"] as? String {
            bank_name = temp
        }
        if let temp = dict["card_primary"] as? String {
            card_primary = temp
        }
        if let temp = dict["cardnumber"] as? String {
            cardnumber = temp
        }
        if let temp = dict["csv"] as? String {
            csv = temp
        }
        if let temp = dict["email"] as? String {
            email = temp
        }
        if let temp = dict["exp_month"] as? String {
            exp_month = temp
        }
        if let temp = dict["exp_year"] as? String {
            exp_year = temp
        }
        if let temp = dict["name_on_card"] as? String {
            name_on_card = temp
        }
        if let temp = dict["type"] as? String {
            type = temp
        }
        if let temp = dict["user_card_id"] as? String {
            user_card_id = temp
        }
        if let temp = dict["userid"] as? String {
            userid = temp
        }
    }
}

class AuctionTypeModel : AppModel
{
    var img : String!
    var name : String!
    var id : Int!
    
    init(dict : [String : Any])
    {
        img = dict["img"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        id = dict["id"] as? Int ?? -1
    }
    
    func dictionary() -> [String:Any]  {
        return ["img":img!, "name":name!, "id":id!]
    }
}

class CategoryModel : AppModel
{
    var category_name : String!
    var categoryid : String!
    
    override init(){
        category_name = ""
        categoryid = ""
    }
    
    init(dict : [String : Any])
    {
        category_name = ""
        categoryid = ""
        
        if let temp = dict["category_name"] as? String {
            category_name = temp
        }
        if let temp = dict["categoryid"] as? String {
            categoryid = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["category_name":category_name!, "categoryid":categoryid!]
    }
}

class ChildCategoryModel : AppModel
{
    var catchild_name : String!
    var catchild_id : String!
    var catid : String!
    
    override init(){
        catchild_name = ""
        catchild_id = ""
        catid = ""
    }
    
    init(dict : [String : Any])
    {
        catchild_name = ""
        catchild_id = ""
        catid = ""
        
        if let temp = dict["catchild_name"] as? String {
            catchild_name = temp
        }
        if let temp = dict["catchild_id"] as? String {
            catchild_id = temp
        }
        if let temp = dict["catid"] as? String {
            catid = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["catchild_name":catchild_name!, "catchild_id":catchild_id!, "catid":catid!]
    }
}


class PackageDetailModel : AppModel
{
    var packages : [PackageModel]!
    var featured_price : PackageFeatureModel!
    var social_media_promotion : PackageFeatureModel!
    
    override init(){
        packages = [PackageModel]()
        featured_price = PackageFeatureModel.init()
        social_media_promotion = PackageFeatureModel.init()
    }
    
    init(dict : [String : Any])
    {
        packages = [PackageModel]()
        featured_price = PackageFeatureModel.init()
        social_media_promotion = PackageFeatureModel.init()
        
        if let tempData = dict["packages"] as? [[String : Any]] {
            for temp in tempData {
                packages.append(PackageModel.init(dict: temp))
            }
        }
        if let temp = dict["featured_price"] as? [String : Any] {
            featured_price = PackageFeatureModel.init(dict: temp)
        }
        if let temp = dict["social_media_promotion"] as? [String : Any] {
            social_media_promotion = PackageFeatureModel.init(dict: temp)
        }
    }
}


class PackageModel : AppModel
{
    var packageid : String!
    var package_title : String!
    var catid : String!
    var package_decription : String!
    var days : String!
    var number_of_auction : String!
    var type : String!
    var extras : String!
    var package_createdon : String!
    var package_status : String!
    var package_price : String!
    var package_savings : String!
    var isSocial : Bool!
    var isFeatured : Bool!
    var package_boughton : String!
    var package_expireon : String!
    var auction_history : AuctionHistoryModel!
    var remaining_auction : Int!
    var active_auction : Int!
    var auctionsleft : Int!
    var featured_price : String!
    
    override init(){
        packageid = ""
        package_title = ""
        catid = ""
        package_decription = ""
        days = ""
        number_of_auction = ""
        type = ""
        extras = ""
        package_createdon = ""
        package_status = ""
        package_price = ""
        package_savings = ""
        isSocial = false
        isFeatured = false
        package_boughton = ""
        package_expireon = ""
        auction_history = AuctionHistoryModel.init()
        remaining_auction = 0
        active_auction = 0
        auctionsleft = 0
        featured_price = ""
    }
    
    init(dict : [String : Any])
    {
        packageid = ""
        package_title = ""
        catid = ""
        package_decription = ""
        days = ""
        number_of_auction = ""
        type = ""
        extras = ""
        package_createdon = ""
        package_status = ""
        package_price = ""
        package_savings = ""
        isSocial = false
        isFeatured = false
        package_boughton = ""
        package_expireon = ""
        auction_history = AuctionHistoryModel.init()
        remaining_auction = 0
        active_auction = 0
        auctionsleft = 0
        featured_price = ""
        
        if let temp = dict["packageid"] as? String {
            packageid = temp
        }
        if let temp = dict["package_title"] as? String {
            package_title = temp
        }
        if let temp = dict["catid"] as? String {
            catid = temp
        }
        if let temp = dict["package_decription"] as? String {
            package_decription = temp
        }
        if let temp = dict["days"] as? String {
            days = temp
        }
        if let temp = dict["number_of_auction"] as? String {
            number_of_auction = temp
        }
        if let temp = dict["type"] as? String {
            type = temp
        }
        if let temp = dict["extras"] as? String {
            extras = temp
        }
        if let temp = dict["package_createdon"] as? String {
            package_createdon = temp
        }
        if let temp = dict["package_status"] as? String {
            package_status = temp
        }
        if let temp = dict["package_price"] as? String {
            package_price = temp
        }
        if let temp = dict["package_savings"] as? String {
            package_savings = temp
        }
        if let temp = dict["isSocial"] as? Bool {
            isSocial = temp
        }
        if let temp = dict["isFeatured"] as? Bool {
            isFeatured = temp
        }
        if let temp = dict["package_boughton"] as? String {
            package_boughton = temp
        }
        if let temp = dict["package_expireon"] as? String {
            package_expireon = temp
        }
        if let temp = dict["auction_history"] as? [String : Any] {
            auction_history = AuctionHistoryModel.init(dict: temp)
        }
        else if let temp = dict["history"] as? [String : Any] {
            auction_history = AuctionHistoryModel.init(dict: temp)
        }
        if let temp = dict["remaining_auction"] as? String {
            remaining_auction = Int(temp)
        }
        else if let temp = dict["remaining_auction"] as? Int {
            remaining_auction = temp
        }
        if let temp = dict["active_auction"] as? Int {
            active_auction = temp
        }
        if let temp = dict["auctionsleft"] as? Int {
            auctionsleft = temp
        }
        if let temp = dict["featured_price"] as? String {
            featured_price = temp
        }
        
        if let tempDict = dict["packages"] as? [String : Any] {
            days = AppModel.shared.getStringValue(tempDict, "days")
            extras = AppModel.shared.getStringValue(tempDict, "extras")
            package_title = AppModel.shared.getStringValue(tempDict, "package_title")
            number_of_auction = AppModel.shared.getStringValue(tempDict, "number_of_auction")
            package_expireon = AppModel.shared.getStringValue(tempDict, "package_expireon")
            package_boughton = AppModel.shared.getStringValue(tempDict, "package_boughton")
            package_price = AppModel.shared.getStringValue(tempDict, "package_price")
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["packageid":packageid!, "package_title":package_title!, "catid":catid!, "package_decription":package_decription!, "days":days!, "number_of_auction":number_of_auction!, "type":type!, "extras":extras!, "package_createdon":package_createdon!, "package_status":package_status!, "package_price":package_price!, "package_savings":package_savings!, "package_boughton":package_boughton!, "package_expireon":package_expireon!, "auction_history":auction_history.dictionary(), "remaining_auction":remaining_auction!, "active_auction":active_auction!, "auctionsleft":auctionsleft!, "featured_price" : featured_price!]
    }
}

class PackageFeatureModel : AppModel
{
    var featured_price_id : String!
    var featured_price : String!
    var featured_price_createdon : String!
    var featured_price_status : String!
    var type : String!
    
    override init(){
        featured_price_id = ""
        featured_price = ""
        featured_price_createdon = ""
        featured_price_status = ""
        type = ""
    }
    
    init(dict : [String : Any])
    {
        featured_price_id = ""
        featured_price = ""
        featured_price_createdon = ""
        featured_price_status = ""
        type = ""
        
        if let temp = dict["featured_price_id"] as? String {
            featured_price_id = temp
        }
        if let temp = dict["featured_price"] as? String {
            featured_price = temp
        }
        if let temp = dict["featured_price_createdon"] as? String {
            featured_price_createdon = temp
        }
        if let temp = dict["featured_price_status"] as? String {
            featured_price_status = temp
        }
        if let temp = dict["type"] as? String {
            type = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["featured_price_id":featured_price_id!, "featured_price":featured_price!, "featured_price_createdon":featured_price_createdon!, "featured_price_status":featured_price_status!, "type":type!]
    }
}

struct PackageHistoryModel {
    var amount : Float!
    var featured_auction_no, packageid, userid, package_purchase_id : Int!
    var get_packages : PackageModel!
    var get_user : UserModel!
    var package_boughton, package_expireon, package_status : String!
    var package_featured, package_promotion : Bool!
    
    init(_ dict : [String : Any]) {
        amount = AppModel.shared.getFloatValue(dict, "amount")
        featured_auction_no = AppModel.shared.getIntValue(dict, "featured_auction_no")
        packageid = AppModel.shared.getIntValue(dict, "packageid")
        userid = AppModel.shared.getIntValue(dict, "userid")
        package_purchase_id = AppModel.shared.getIntValue(dict, "package_purchase_id")
        get_packages = PackageModel.init(dict: dict["get_packages"] as? [String : Any] ?? [String : Any]())
        get_user = UserModel.init(dict: dict["get_user"] as? [String : Any] ?? [String : Any]())
        package_boughton = dict["package_boughton"] as? String ?? ""
        package_expireon = dict["package_expireon"] as? String ?? ""
        package_status = dict["package_status"] as? String ?? ""
        package_featured = dict["package_featured"] as? Bool ?? false
        package_promotion = dict["package_promotion"] as? Bool ?? false
    }
    
    func dictionary() -> [String : Any] {
        return ["amount" : amount!, "featured_auction_no" : featured_auction_no!, "packageid" : packageid!,"userid" : userid!,"package_purchase_id" : package_purchase_id!,"get_packages" : get_packages.dictionary(),"get_user" : get_user.dictionary(),"package_boughton" : package_boughton!,"package_expireon" : package_expireon!,"package_status" : package_status!,"package_featured" : package_featured!, "package_promotion" : package_promotion!]
    }
}

class AuctionHistoryModel : AppModel
{
    var posted_historyid : String!
    var package_purchaseid : String!
    var package_userid : String!
    var total_auction : String!
    var auction_posted : String!
    var postedon : String!
    
    override init(){
        posted_historyid = ""
        package_purchaseid = ""
        package_userid = ""
        total_auction = ""
        auction_posted = ""
        postedon = ""
    }
    
    init(dict : [String : Any])
    {
        posted_historyid = ""
        package_purchaseid = ""
        package_userid = ""
        total_auction = ""
        auction_posted = ""
        postedon = ""
        
        if let temp = dict["posted_historyid"] as? String {
            posted_historyid = temp
        }
        if let temp = dict["package_purchaseid"] as? String {
            package_purchaseid = temp
        }
        if let temp = dict["package_userid"] as? String {
            package_userid = temp
        }
        if let temp = dict["total_auction"] as? String {
            total_auction = temp
        }
        else if let temp = dict["total_auction"] as? Int {
            total_auction = String(temp)
        }
        if let temp = dict["auction_posted"] as? String {
            auction_posted = temp
        }
        else if let temp = dict["auction_posted"] as? Int {
            auction_posted = String(temp)
        }
        if let temp = dict["postedon"] as? String {
            postedon = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["posted_historyid":posted_historyid!, "package_purchaseid":package_purchaseid!, "package_userid":package_userid!, "total_auction":total_auction!, "auction_posted":auction_posted!, "postedon":postedon!]
    }
}

class FeatureAuctionModel : AppModel
{
    var deposite_amount : String!
    var userid : String!
    var auctionid : String!
    var featured_price_status : String!
    var deposite_status : String!
    var type : String!
    var auction_title : String!
    var createdon : String!
    
    override init(){
        deposite_amount = ""
        userid = ""
        auctionid = ""
        featured_price_status = ""
        deposite_status = ""
        type = ""
        auction_title = ""
        createdon = ""
    }
    
    init(dict : [String : Any])
    {
        deposite_amount = ""
        userid = ""
        auctionid = ""
        featured_price_status = ""
        deposite_status = ""
        type = ""
        auction_title = ""
        createdon = ""
        
        if let temp = dict["deposite_amount"] as? String {
            deposite_amount = temp
        }
        if let temp = dict["userid"] as? String {
            userid = temp
        }
        if let temp = dict["auctionid"] as? String {
            auctionid = temp
        }
        if let temp = dict["featured_price_status"] as? String {
            featured_price_status = temp
        }
        if let temp = dict["deposite_status"] as? String {
            deposite_status = temp
        }
        if let temp = dict["type"] as? String {
            type = temp
        }
        if let temp = dict["auction_title"] as? String {
            auction_title = temp
        }
        if let temp = dict["createdon"] as? String {
            createdon = temp
        }
    }
}

class BidAuctionModel : AppModel
{
    var bidid : String!
    var userid : String!
    var auctionid : String!
    var bidprice : String!
    var bidon : String!
    var auction_price : String!
    var auction_title : String!
    var auction_status : String!
    
    override init(){
        bidid = ""
        userid = ""
        auctionid = ""
        bidprice = ""
        bidon = ""
        auction_price = ""
        auction_title = ""
        auction_status = ""
    }
    
    init(dict : [String : Any])
    {
        bidid = ""
        userid = ""
        auctionid = ""
        bidprice = ""
        bidon = ""
        auction_price = ""
        auction_title = ""
        auction_status = ""
        
        if let temp = dict["bidid"] as? String {
            bidid = temp
        }
        if let temp = dict["userid"] as? String {
            userid = temp
        }
        if let temp = dict["auctionid"] as? String {
            auctionid = temp
        }
        if let temp = dict["bidprice"] as? String {
            bidprice = temp
        }
        if let temp = dict["bidon"] as? String {
            bidon = temp
        }
        if let temp = dict["auction_price"] as? String {
            auction_price = temp
        }
        if let temp = dict["auction_title"] as? String {
            auction_title = temp
        }
        if let temp = dict["auction_status"] as? String {
            auction_status = temp
        }
    }
    
    func dictionary() -> [String:Any]  {
        return ["bidid":bidid!, "userid":userid!, "auctionid":auctionid!, "bidprice":bidprice!, "bidon":bidon!, "auction_price":auction_price!, "auction_title":auction_title!, "auction_status":auction_status!]
    }
}

class NotificationModel : AppModel
{
    var notificationid : String!
    var userid : String!
    var auctionid : String!
    var createdon : String!
    var status : String!
    var auction_title : String!
    var message : String!
    
    init(dict : [String : Any])
    {
        notificationid = dict["notificationid"] as? String ?? ""
        userid = dict["userid"] as? String ?? ""
        auctionid = dict["auctionid"] as? String ?? ""
        createdon = dict["createdon"] as? String ?? ""
        status = dict["status"] as? String ?? ""
        auction_title = dict["auction_title"] as? String ?? ""
        message = dict["message"] as? String ?? ""
    }
}

class InfoModel : AppModel
{
    var image, name, value, link : String!
    
    init(dict : [String : Any])
    {
        image = dict["image"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        value = dict["value"] as? String ?? ""
        link = dict["link"] as? String ?? ""
    }
    
    func dictionary() -> [String : Any] {
        return ["image" : image!, "name" : name!, "value" : value!, "link" : link!]
    }
}

class DepositeModel : AppModel
{
    var depositeid, deposite_amount, createdon, deposite_status, payment_reference : String!
    
    init(dict : [String : Any])
    {
        depositeid = AppModel.shared.getStringValue(dict, "depositeid")
        deposite_amount = AppModel.shared.getStringValue(dict, "deposite_amount")
        createdon = dict["createdon"] as? String ?? ""
        deposite_status = dict["deposite_status"] as? String ?? ""
        payment_reference = AppModel.shared.getStringValue(dict, "payment_reference")
    }
}

class WithdrawModel : AppModel
{
    var id, userid, withdrawl_amount, status, created_at : String!
    
    init(dict : [String : Any])
    {
        id = AppModel.shared.getStringValue(dict, "id")
        userid = AppModel.shared.getStringValue(dict, "userid")
        withdrawl_amount = AppModel.shared.getStringValue(dict, "withdrawl_amount")
        status = dict["status"] as? String ?? ""
        created_at = dict["created_at"] as? String ?? ""
    }
}
