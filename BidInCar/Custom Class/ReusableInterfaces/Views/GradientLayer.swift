//
//  GradientLayer.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

class GradientLayer: CAGradientLayer {

    override func layoutSublayers() {
        super.layoutSublayers()
        
        frame = super.bounds
    }
}
