//  BNUIButton_CloseAlert.swift
//  biin
//  Created by Esteban Padilla on 2/11/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit
import CoreGraphics
import QuartzCore

class BNUIButton_CloseAlert:BNUIButton {
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = BNIcon_CloseSmall(color: UIColor.redColor(), position: CGPoint(x: 1, y: 1))
    }
}