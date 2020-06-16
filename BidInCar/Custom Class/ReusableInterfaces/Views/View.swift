//
//  View.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

@IBDesignable
class View: UIView {
    
    @IBInspectable var backgroundColorTypeAdapter : Int32 = 0 {
        didSet {
            self.backgroundColorType = ColorType(rawValue: self.backgroundColorTypeAdapter)
        }
    }
    var backgroundColorType : ColorType? {
        didSet {
            setBackgroundColor(backgroundColorType: backgroundColorType)
        }
    }
    
    @IBInspectable var gradientBackgroundTypeAdapter : Int32 = 0 {
        didSet {
            gradientBackgroundType = GradientColorTypeForView(rawValue: gradientBackgroundTypeAdapter) ?? .Clear
        }
    }
    var gradientBackgroundType : GradientColorTypeForView = .Clear {
        didSet {
            setGradientBackground1(gradientBackgroundType: gradientBackgroundType)
        }
    }
    
    @IBInspectable var borderColorTypeAdapter : Int32 = 0 {
        didSet {
            self.borderColorType = ColorType(rawValue: self.borderColorTypeAdapter)
        }
    }
    var borderColorType : ColorType? {
        didSet {
            setBorderColor(borderColorType: borderColorType)
        }
    }
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            setCornerRadius(cornerRadius)
        }
    }
    
    @IBInspectable var applyShadow : Bool = false {
        didSet {
            setShadow(applyShadow: applyShadow)
        }
    }
    
    @IBInspectable var topShadow : Bool = false {
        didSet {
            setTopShadow(applyShadow: topShadow)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setGradientBackground1(gradientBackgroundType: gradientBackgroundType)
    }
}

extension UIView {
    func setBackgroundColor(backgroundColorType : ColorType?) {
        backgroundColor = backgroundColorType?.value
    }
    
    func setBorderColor(borderColorType : ColorType?) {
        self.layer.borderColor = borderColorType?.value.cgColor
    }
    
    func setTintColor(tintColorType : ColorType?) {
        self.tintColor = tintColorType?.value
    }
    
    func setCornerRadius(_ cornerRadius : CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func setShadow(applyShadow : Bool) {
        if applyShadow {
            self.layer.masksToBounds = false;
            self.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 2
        } else {
            self.layer.shadowRadius = 0
            self.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    func setTopShadow(applyShadow : Bool) {
        if applyShadow {
            self.layer.masksToBounds = false;
            self.layer.shadowOffset = CGSize(width: 0.5, height: -1.5)
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 2
        } else {
            self.layer.shadowRadius = 0
            self.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    
    func setGradientBackground(gradientBackgroundType : GradientColorType) {
        
        if gradientBackgroundType == .Clear {
            return
        }
        
        if let gradient = self.layer.value(forKeyPath: "GradientLayer") as? GradientLayer {
            gradient.frame = self.bounds
            return
        }
        
        let layer = gradientBackgroundType.layer
        layer.frame = self.bounds
        
        self.layer.insertSublayer(layer, at: 0)
        self.layer.setValue(layer, forKey: "GradientLayer")
    }
    
    func setGradientBackground1(gradientBackgroundType : GradientColorTypeForView) {
        
        if gradientBackgroundType == .Clear {
            return
        }
        
        if let gradient = self.layer.value(forKeyPath: "GradientLayer") as? GradientLayer {
            gradient.frame = self.bounds
            return
        }
        
        let layer = gradientBackgroundType.layer
        layer.frame = self.bounds
        
        self.layer.insertSublayer(layer, at: 0)
        self.layer.setValue(layer, forKey: "GradientLayer")
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
