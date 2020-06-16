//
//  Colors.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

var ClearColor : UIColor = UIColor.clear //0
var WhiteColor : UIColor = UIColor.white //1
var DarkGrayColor : UIColor = colorFromHex(hex: "222222") //2
var LightGrayColor : UIColor = colorFromHex(hex: "9C9C9C") //3
var ExtraLightGrayColor : UIColor = colorFromHex(hex: "B2B0B0") //4
var BlackColor : UIColor = UIColor.black   //5
var PurpleColor : UIColor = colorFromHex(hex: "6862FA") //6
var PinkColor : UIColor = colorFromHex(hex: "FC7E8C") //7
var DarkBlueColor : UIColor = colorFromHex(hex: "4E4C6E")//8
var OrangeColor : UIColor = colorFromHex(hex: "EB8E00")//9
var YellowColor : UIColor = colorFromHex(hex: "F4C23D")//10
var DarkPinkColor : UIColor = colorFromHex(hex: "FF465B")//11
var RedColor : UIColor = colorFromHex(hex: "E31E24")//12
var BlueColor : UIColor = colorFromHex(hex: "2C4AD9")//13
var GreenColor : UIColor = colorFromHex(hex: "8AC767")//14
var LightBGColor : UIColor = colorFromHex(hex: "EAEEF0")//15
var LightPurpleColor : UIColor = colorFromHex(hex: "4B497D")//16

enum ColorType : Int32 {
    case Clear = 0
    case White = 1
    case DarkGray = 2
    case LightGray = 3
    case ExtraLightGray = 4
    case Black = 5
    case Purple = 6
    case Pink = 7
    case DarkBlue = 8
    case Orange = 9
    case Yellow = 10
    case DarkPink = 11
    case Red = 12
    case Blue = 13
    case Green = 14
    case LightBG = 15
    case LightPurple = 16
}

extension ColorType {
    var value: UIColor {
        get {
            switch self {
            case .Clear: //0
                return ClearColor
            case .White: //1
                return WhiteColor
            case .DarkGray: //2
                return DarkGrayColor
            case .LightGray: //3
                return LightGrayColor
            case .ExtraLightGray: //4
                return ExtraLightGrayColor
            case .Black: //5
                return BlackColor
            case .Purple: //6
                return PurpleColor
            case .Pink: //7
                return PinkColor
            case .DarkBlue: //8
                return DarkBlueColor
            case .Orange: //9
                return OrangeColor
            case .Yellow: //10
                return YellowColor
            case .DarkPink: //11
                return DarkPinkColor
            case .Red: //12
                return RedColor
            case .Blue: //13
                return BlueColor
            case .Green: //14
                return GreenColor
            case .LightBG: //15
                return LightBGColor
            case .LightPurple: //16
                return LightPurpleColor
            }
        }
    }
}

enum GradientColorType : Int32 {
    case Clear = 0
    case App = 1
}

extension GradientColorType {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .App: //1
                gradient.colors = [
                    WhiteColor.cgColor,
                    BlackColor.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint.zero
                gradient.endPoint = CGPoint(x: 1, y: 0)
            }
            
            return gradient
        }
    }
}


enum GradientColorTypeForView : Int32 {
    case Clear = 0
    case App = 1
}


extension GradientColorTypeForView {
    var layer : GradientLayer {
        get {
            let gradient = GradientLayer()
            switch self {
            case .Clear: //0
                gradient.frame = CGRect.zero
            case .App: //1
                gradient.colors = [
                    WhiteColor.cgColor,
                    BlackColor.cgColor
                ]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint(x: 0.8, y: 1.0)
                gradient.endPoint = CGPoint(x: 0.8, y: 0.0)

            }
            
            return gradient
        }
    }
}

