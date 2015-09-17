//  BiinieCategoriesView_Header.swift
//  biin
//  Created by Esteban Padilla on 1/16/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class BiinieCategoriesView_Header: BNView, BiinieCategoriesView_Delegate {
    
    
    var points = Array<BNUIPointView>()
    var icons = Array<UIView>()
    var previousPoint:Int = 0
    
    var categoryNameLbl:UILabel?
    var notificationBtn:BNUIButton?
    var notificationRedCircle:BNUINotificationView_RedCircle?
    var searchBtn:BNUIButton?
    var showMenuBtn:BNUIButton?
    
//    override init() {
//        super.init()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.appMainColor()
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSizeMake(0, 3)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.25
        /*
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = frame
        addSubview(effectView)
        */
        
        categoryNameLbl = UILabel(frame: CGRectMake(0, 3, SharedUIManager.instance.screenWidth, (SharedUIManager.instance.siteView_titleSize + 3)))
        categoryNameLbl!.font = UIFont(name: "Lato-Black", size: SharedUIManager.instance.siteView_titleSize)
        categoryNameLbl!.textColor = UIColor.appTextColor()
        categoryNameLbl!.textAlignment = NSTextAlignment.Center
        self.addSubview(categoryNameLbl!)

        addButtons()
        
        //if BNAppSharedManager.instance.dataManager.bnUser!.categories.count > 0 {
        //    addCategoriesPoints()
        //}
        
        //HACK: show only three options
        add3Options()
    }
    
    override func transitionIn() {
        
    }
    
    override func transitionOut( state:BNState? ) {
        
    }
    
    override func setNextState(option:Int){
        //Start transition on root view controller
        father!.setNextState(option)
    }
    
    override func showUserControl(value:Bool, son:BNView, point:CGPoint){
        if father == nil {

        }else{
            father!.showUserControl(value, son:son, point:point)
        }
    }
    
    override func updateUserControl(position:CGPoint){
        if father == nil {

        }else{
            father!.updateUserControl(position)
        }
    }
    
    //Instance Methods
    func addButtons(){
        
        //notificationRedCircle = BNUINotificationView_RedCircle(position: CGPoint(x: 20, y: 14))
        //notificationBtn = BNUIButton_WithLabel(position: CGPoint(x:2, y: 10), text: "", iconType: BNIconType.notificationMedium, hasLabel: false)
        //notificationBtn!.addTarget(self, action: "showNotificationsView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //searchBtn = BNUIButton(position: CGPoint(x: (SharedUIManager.instance.screenWidth - 45), y: 10), iconType: BNIconType.searchMedium)
        //searchBtn!.addTarget(self, action: "showSearchView:", forControlEvents: UIControlEvents.TouchUpInside)

        //self.addSubview(notificationBtn!)
        //self.addSubview(notificationRedCircle!)
        //self.addSubview(searchBtn!)
        
        //notificationRedCircle!.setNotifitionNumber(23)
        //hideNotification()
        
        
        showMenuBtn = BNUIButton_Menu(frame: CGRectMake(10, 12, 60, 40), text: "", iconType: BNIconType.menuMedium)
        showMenuBtn!.addTarget(father, action: "showMenuBtnActon:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(showMenuBtn!)
    }
    
    func addCategoriesPoints(){
        
        let totalLength:CGFloat = CGFloat((BNAppSharedManager.instance.dataManager.bnUser!.categories.count - 1) * 20)
        let space:CGFloat = (SharedUIManager.instance.screenWidth - totalLength) / 2.0
        var xpos:CGFloat = (space - 5)
        
        categoryNameLbl!.text = NSLocalizedString(BNAppSharedManager.instance.dataManager.bnUser!.categories[0].identifier!, comment:"")

        for var i:Int = 0; i < BNAppSharedManager.instance.dataManager.bnUser!.categories.count; i++ {
            
            let point = BNUIPointView(frame: CGRectMake((xpos), 25, 14, 14), categoryIdentifier: BNAppSharedManager.instance.dataManager.bnUser!.categories[i].identifier!, activeColor:UIColor.blackColor())
            self.points.append(point)
            self.addSubview(point)
            /*
            var icon = BiinieCategoriesView_Icon(frame: CGRectMake((xpos), 22, 25, 25), categoryType: BNAppSharedManager.instance.dataManager.bnUser!.categories[i].categoryType!)
            
            if i != 0 {
                icon.transform = CGAffineTransformMakeScale(0.7, 0.7)
                icon.alpha = 0.5
            } else {
                icon.frame.origin.x = point.frame.origin.x - 6
                icon.frame.origin.y = 18
            }
            
            self.icons.append(icon)
            self.addSubview(icon)
            */
            xpos += 20
        }
        
        points[0].setActive()
    }
    
    func add3Options() {
        let totalLength:CGFloat = CGFloat( 2 * 20)
        let space:CGFloat = (SharedUIManager.instance.screenWidth - totalLength) / 2.0
        var xpos:CGFloat = (space - 5)
        
        categoryNameLbl!.text = NSLocalizedString("Places", comment:"Places")
        let point1 = BNUIPointView(frame: CGRectMake((xpos), 25, 14, 14), categoryIdentifier:NSLocalizedString("Places", comment:"Places"), activeColor:UIColor.blackColor())
        self.points.append(point1)
        self.addSubview(point1)
        xpos += 20

        
        let point2 = BNUIPointView(frame: CGRectMake((xpos), 25, 14, 14), categoryIdentifier:NSLocalizedString("HightLights", comment:"HightLights"), activeColor:UIColor.blackColor())
        self.points.append(point2)
        self.addSubview(point2)
        xpos += 20
        
        let point3 = BNUIPointView(frame: CGRectMake((xpos), 25, 14, 14), categoryIdentifier:NSLocalizedString("Biins", comment:"Biins"), activeColor:UIColor.blackColor())
        self.points.append(point3)
        self.addSubview(point3)
        xpos += 20
        
        points[0].setActive()
    }
    
    func showNotification(){
        
        notificationRedCircle!.show(BNAppSharedManager.instance.dataManager.bnUser!.newNotificationCount!)
        notificationBtn!.showEnable()
        //TODO: animate button and circle here
    }
    
    func hideNotification(){
        //TODO: Hide notifications here on main view
        notificationBtn!.showDisable()
        notificationRedCircle!.hide()
    }
    
    func showSearchView(sender:BNUIButton){
        //TODO: show search view here
    }
    
    func showNotificationsView(sender:BNUIButton) {
        //TODO: show notifications view here
    }
    
    func updateCategoriesControl(view: BiinieCategoriesView, position: CGFloat) {
        //TODO: update categories control here.
        //aView!.frame.origin.x = position
    }
    
    func updateCategoriesPoints(view: BiinieCategoriesView, index: Int) {
        
        //categoryNameLbl!.alpha = 0
        
        points[previousPoint].setInactive()
        
        /*
        UIView.animateWithDuration(0.25, animations: {()->Void in
            self.icons[self.previousPoint].transform = CGAffineTransformMakeScale(0.7, 0.7)
            self.icons[self.previousPoint].alpha = 0.5
            
            if index < self.previousPoint {
                self.icons[self.previousPoint].frame.origin.x = (self.points[self.previousPoint].frame.origin.x + 3)
                self.icons[self.previousPoint].frame.origin.y = 26
            } else {
                self.icons[self.previousPoint].frame.origin.x = (self.points[self.previousPoint].frame.origin.x - 8)
                self.icons[self.previousPoint].frame.origin.y = 26
            }
        })
        */
        points[index].setActive()
        /*
        UIView.animateWithDuration(0.25, animations: {()->Void in
            
            self.icons[index].transform = CGAffineTransformMakeScale(1, 1)
            self.icons[index].frame.origin.x = (self.points[index].frame.origin.x - 6)
            self.icons[index].frame.origin.y = 18
            self.icons[index].alpha = 1
        })*/
        
        //categoryNameLbl!.text = NSLocalizedString(BNAppSharedManager.instance.dataManager.bnUser!.categories[index].identifier!, comment:"")
        
        
        //HACK
        if index == 0 {
            categoryNameLbl!.text = NSLocalizedString("Places", comment: "Places")
        } else  if index == 1 {
            categoryNameLbl!.text = NSLocalizedString("HightLights", comment: "HightLights")
        } else if index == 2 {
            categoryNameLbl!.text = NSLocalizedString("Biins", comment: "Biins")
        }
        
        
        //categoryNameLbl!.sizeToFit()
        //self.categoryNameLbl!.frame.origin.x = self.points[index].frame.origin.x - (self.categoryNameLbl!.frame.width / 2) + 7
        
        //UIView.animateWithDuration(0.2, animations: {()->Void in

            //self.categoryNameLbl!.alpha = 1
        //})
        
        previousPoint = index
        
    }

}

@objc protocol BiinieCategoriesView_Header_Delegate:NSObjectProtocol {
    optional func updateCategoryStatus(view:BiinieCategoriesView_Header,  position:CGFloat)
}
