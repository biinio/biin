//  BNSite.swift
//  Biin
//  Created by Esteban Padilla on 9/26/14.
//  Copyright (c) 2014 Biin. All rights reserved.

import Foundation
import UIKit

class BNSite:NSObject {
    
    //TODO: jsonUrl only for testing, remove later
    var jsonUrl:String?
    
    var identifier:String?
    var proximityUUID:NSUUID?
    var major:Int?
    
    //Details
    var title:String?
    var subTitle:String?
    
    //Color
    var titleColor:UIColor?
    
    //Location
    var country:String?
    var state:String?
    var city:String?
    var zipCode:String?
    var streetAddress1:String?
    var streetAddress2:String?
    
    //Gallery
    var media:Array<BNMedia> = Array<BNMedia>()
//    var images:Array<UIImageView> = Array<UIImageView>()
    
    //Biins
    var biins = Array<BNBiin>()
    
    //Loyalty
    var loyalty:BNLoyalty?

    //Social interaction
    var biinedCount:Int = 0   //How many time users have biined this element.
    var comments:Int = 0    //How many time users have commented this element.
    
    var userBiined = false
    var userCommented = false
    var userShared = false
    
    var latitude:Float?
    var longitude:Float?
    
    override init(){
        super.init()
    }

    deinit{
        
    }
}