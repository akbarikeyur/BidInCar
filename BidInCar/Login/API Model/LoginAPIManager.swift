//
//  LoginAPIManager.swift
//  BidInCar
//
//  Created by Keyur on 20/04/21.
//  Copyright © 2021 Amisha. All rights reserved.
//

import Foundation

public class LoginAPIManager {
    
    static let shared = LoginAPIManager()


    func serviceCallToUserLogin(_ params : [String : Any], completion: @escaping () -> Void) {
        
        APIManager.shared.callPostRequest(API.LOGIN, params, true) { (dict) in
            if let status = dict["status"] as? String {
                if(status == "success") {
                    if let data : [String : Any] = dict["data"] as? [String : Any]
                    {
                        AppModel.shared.currentUser = UserModel.init(dict: data)
                        completion()
                        return
                    }
                }
                else if status == "error"
                {
                    if let message = dict["message"] as? String, message != "" {
                        displayToast(message)
                    }
                    APIManager.shared.handleStatusCode(dict)
                }
            }
        }
    }
    
    func serviceCallToCheckSocialLogin(_ params : [String : Any], completion: @escaping (_ dict : [String : Any]) -> Void) {
        
        APIManager.shared.callPostRequest(API.CHECK_SOCIAL_LOGIN, params, true) { (dict) in
            if let status = dict["status"] as? String {
                if(status == "success") {
                    if let data = dict["data"] as? [String : Any] {
                        completion(data)
                    }else{
                        completion([String : Any]())
                    }
                }
                else if status == "error"
                {
                    if let message = dict["message"] as? String, message != "" {
                        displayToast(message)
                    }
                    APIManager.shared.handleStatusCode(dict)
                }
            }
        }
    }
    
    func serviceCallToUserSignup(_ params : [String : Any], completion: @escaping () -> Void) {
        
        APIManager.shared.callPostRequest(API.SIGNUP, params, true) { (dict) in
            if let status = dict["status"] as? String {
                if(status == "success") {
                    if let data : [String : Any] = dict["data"] as? [String : Any]
                    {
                        AppModel.shared.currentUser = UserModel.init(dict: data)
                        completion()
                        return
                    }
                }
                else if status == "error"
                {
                    if let message = dict["message"] as? String, message != "" {
                        displayToast(message)
                    }
                    APIManager.shared.handleStatusCode(dict)
                }
            }
        }
    }
    
    func serviceCallToSendOtp(_ params : [String : Any], completion: @escaping () -> Void) {
        
        APIManager.shared.callPostRequest(API.SEND_OTP, params, true) { (dict) in
            if let status = dict["status"] as? String {
                if(status == "success") {
                    completion()
                    return
                }
                else if status == "error"
                {
                    if let message = dict["message"] as? String, message != "" {
                        displayToast(message)
                    }
                    APIManager.shared.handleStatusCode(dict)
                }
            }
        }
    }
    
    func serviceCallToVerifyAccount(_ params : [String : Any], completion: @escaping () -> Void) {
        
        APIManager.shared.callPostRequest(API.VERIFY_OTP, params, true) { (dict) in
            if let status = dict["status"] as? String {
                if(status == "success") {
                    completion()
                    return
                }
                else if status == "error"
                {
                    if let message = dict["message"] as? String, message != "" {
                        displayToast(message)
                    }
                    APIManager.shared.handleStatusCode(dict)
                }
            }
        }
    }
    
    func serviceCallToForgotPassword(_ params : [String : Any], completion: @escaping () -> Void) {
        
        APIManager.shared.callPostRequest(API.FORGOT_PASSWORD, params, true) { (dict) in
            if let status = dict["status"] as? String {
                if(status == "success") {
                    if let message = dict["message"] as? String, message != "" {
                        displayToast(message)
                    }
                    completion()
                    return
                }
                else if status == "error"
                {
                    if let message = dict["message"] as? String, message != "" {
                        displayToast(message)
                    }
                    APIManager.shared.handleStatusCode(dict)
                }
            }
        }
    }
    
    func serviceCallToRegisterDevice() {
        
        var param = [String : Any]()
        param["fcmtoken"] = getPushToken()
        param["device_id"] = DEVICE_ID
        param["type"] = "ios"
        printData(param)
        APIManager.shared.callPostRequest(API.REGISTER_DEVICE, param, true) { (dict) in
            printData(dict)
            if let status = dict["status"] as? String {
                if(status == "success") {
                    
                }
                else if status == "error"
                {
                    
                }
            }
        }
    }
    
    
}
