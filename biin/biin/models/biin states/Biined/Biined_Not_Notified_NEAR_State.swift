//  Biined_Not_Notified_NEAR_State.swift
//  biin
//  Created by Esteban Padilla on 3/3/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation

class Biined_Not_Notified_NEAR_State: Biin_State {
    
    override init(biin: BNBiin?) {
        super.init(biin: biin)
        setNotificationMessage(2)
    }
    
    override func action() { }
}
