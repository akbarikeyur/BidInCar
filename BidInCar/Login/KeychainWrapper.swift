//
//  KeychainWrapper.swift
//  Reeveal
//
//  Created by MACBOOK on 26/02/21.
//  Copyright (c) 2014 Jason Rendel. All rights reserved.
//

import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"


/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */
let appleUserNameKey = "KeyForAppleUserName"
let appleUserIdKey = "KeyForAppleUserId"
let appleEmailKey = "KeyForAppleEmail"
let appleTokenKey = "KeyForAppleToken"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainService: NSObject {

    /**
     * Exposed methods to perform save and load queries.
     */

    public class func saveAppleUserName(token: NSString) {
        self.save(service: appleUserNameKey as NSString, data: token)
    }

    public class func loadAppleUserName() -> NSString? {
        return self.load(service: appleUserNameKey as NSString)
    }
    
    public class func saveAppleUserId(token: NSString) {
        self.save(service: appleUserIdKey as NSString, data: token)
    }

    public class func loadAppleUserId() -> NSString? {
        return self.load(service: appleUserIdKey as NSString)
    }
        
    public class func saveAppleEmail(token: NSString) {
        self.save(service: appleEmailKey as NSString, data: token)
    }

    public class func loadAppleEmail() -> NSString? {
        return self.load(service: appleEmailKey as NSString)
    }
    
    public class func saveAppleToken(token: NSString) {
        self.save(service: appleTokenKey as NSString, data: token)
    }

    public class func loadAppleToken() -> NSString? {
        return self.load(service: appleTokenKey as NSString)
    }
    
    /**
     * Internal methods for querying the keychain.
     */

    private class func save(service: NSString, data: NSString) {
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData

        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)

        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    private class func load(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

        var dataTypeRef :AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }

        return contentsOfKeychain
    }
}
