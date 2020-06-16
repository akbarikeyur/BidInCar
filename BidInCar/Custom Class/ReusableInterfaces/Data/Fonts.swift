//
//  Fonts.swift
//  Cozy Up
//
//  Created by Keyur on 22/05/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation

import UIKit

let APP_REGULAR = "Poppins-Regular"
let APP_BOLD = "Poppins-Bold"
let APP_MEDIUM = "Poppins-Medium"
let APP_LIGHT = "Poppins-Light"

let APP_TITLE = "ADAM.CGPRO"

enum FontType : String {
    case Clear = ""
    case ARegular = "ar"
    case ABold = "ab"
    case AMedium = "am"
    case ALight = "al"
    case ATitle = "at"
}


extension FontType {
    var value: String {
        get {
            switch self {
            case .Clear:
                return APP_REGULAR
            
            case .ARegular:
                return APP_REGULAR
            case .ABold:
                return APP_BOLD
            case .AMedium:
                return APP_MEDIUM
            case .ALight :
                return APP_LIGHT
            case .ATitle :
                return APP_TITLE
            }
        }
    }
}

