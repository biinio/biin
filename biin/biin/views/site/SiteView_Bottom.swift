//  SiteView_Bottom.swift
//  biin
//  Created by Esteban Padilla on 2/3/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class SiteView_Bottom:BNView {
    
    var pointsLbl:UILabel?
    var title:UILabel?
    var subTitle:UILabel?
    
    var informationBtn:BNUIButton_Information?
    
//    override init() {
//        super.init()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.appMainColor()
        
//        self.layer.masksToBounds = false
//        self.layer.shadowOffset = CGSizeMake(3, 0)
//        self.layer.shadowRadius = 2
//        self.layer.shadowOpacity = 0.5
        
        pointsLbl = UILabel(frame: CGRectMake(10, 8, (SharedUIManager.instance.screenWidth - 50), 14))
        pointsLbl!.textAlignment = NSTextAlignment.Left
        pointsLbl!.font = UIFont(name: "Lato-Black", size: 12)
        pointsLbl!.textColor = UIColor.appTextColor()
        //self.addSubview(pointsLbl!)

        title = UILabel(frame: CGRectMake(10, 10, (SharedUIManager.instance.screenWidth - 50), (SharedUIManager.instance.siteView_titleSize + 3)))
        title!.textAlignment = NSTextAlignment.Left
        title!.font = UIFont(name: "Lato-Regular", size: SharedUIManager.instance.siteView_titleSize)
        title!.textColor = UIColor.whiteColor()
        self.addSubview(title!)
        
        
        subTitle = UILabel(frame: CGRectMake(10, (SharedUIManager.instance.siteView_titleSize + 13), (SharedUIManager.instance.screenWidth - 50), (SharedUIManager.instance.siteView_subTittleSize + 3)))
        subTitle!.textAlignment = NSTextAlignment.Left
        subTitle!.font = UIFont(name: "Lato-Light", size: SharedUIManager.instance.siteView_subTittleSize)
        subTitle!.textColor = UIColor.whiteColor()
        self.addSubview(subTitle!)
        
        //informationBtn = BNUIButton_Information(frame: CGRectMake(5, 2, 26, 26))
        //informationBtn!.addTarget(father, action: "showInformationView:", forControlEvents: UIControlEvents.TouchUpInside)
        //self.addSubview(informationBtn!)

    }

    override func transitionIn() {
        println("trasition in on SiteView_Bottom")
    }
    
    override func transitionOut( state:BNState? ) {
        println("trasition out on SiteView_Bottom")
    }
    
    override func setNextState(option:Int){
        //Start transition on root view controller
        father!.setNextState(option)
    }
    
    override func showUserControl(value:Bool, son:BNView, point:CGPoint){
        if father == nil {
            println("showUserControl: SiteView_Bottom")
        }else{
            father!.showUserControl(value, son:son, point:point)
        }
    }
    
    override func updateUserControl(position:CGPoint){
        if father == nil {
            println("updateUserControl: SiteView_Bottom")
        }else{
            father!.updateUserControl(position)
        }
    }
    
    //Instance methods
    func updateForSite(site: BNSite?){
        var height:CGFloat = 0
        
        if site!.showcases == nil {
            height = SharedUIManager.instance.screenHeight - (SharedUIManager.instance.screenWidth + 20 + 2)
        } else if site!.showcases!.count == 1 {
             height = 100
//            height = SharedUIManager.instance.screenHeight - (SharedUIManager.instance.screenWidth + SharedUIManager.instance.siteView_showcaseHeaderHeight + SharedUIManager.instance.miniView_height + 20)
        } else {
            height = 100
        }
        
        self.backgroundColor = site!.media[0].domainColor!
        
        self.frame = CGRectMake(0, 0, SharedUIManager.instance.screenWidth, height)
        var points = NSLocalizedString("Points", comment: "Points")
        pointsLbl!.text = "\(points): \(site!.organization!.loyalty!.points)"
        
        self.title!.text = "More Comming soon!"
        self.subTitle!.text = "Come back in next few day and find more exiting infomation on our behalf."
    }
}
