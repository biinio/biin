//  BNUIButton_CollectionIt.swift
//  biin
//  Created by Esteban Padilla on 9/13/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit
import CoreGraphics
import QuartzCore

class BNUIButton_CollectionIt:BNUIButton {

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = BNIcon_CollectIt(color: UIColor.biinColor(), position: CGPointMake(5, 5))
    }
    
    func changeToCollectIcon(value:Bool){

        icon = nil
        
        if value {
            icon = BNIcon_CollectedIt(color: UIColor.blackColor(), position: CGPointMake(5, 5))
        } else {
            icon = BNIcon_CollectIt(color: UIColor.blackColor(), position: CGPointMake(5, 5))
        }
        
        setNeedsDisplay()
    }
    
}

