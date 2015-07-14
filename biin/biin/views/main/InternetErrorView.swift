//  InternetErrorView.swift
//  biin
//  Created by Esteban Padilla on 7/7/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class InternetErrorView: BNView {
    
    var delegate:InternetErrorView_Delegate?
    var title:UILabel?
    var backBtn:BNUIButton_Back?
    var fade:UIView?
    var warningLogo:BNUIWarningView?
    var errorViewController:ErrorViewController?
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.appMainColor()
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        var screenWidth = SharedUIManager.instance.screenWidth
        var screenHeight = SharedUIManager.instance.screenHeight
        
        var ypos:CGFloat = 8
        title = UILabel(frame: CGRectMake(6, ypos, screenWidth, (SharedUIManager.instance.errorView_title + 3)))
        title!.font = UIFont(name:"Lato-Black", size:SharedUIManager.instance.errorView_title)
        title!.textColor = UIColor.appTextColor()
        title!.textAlignment = NSTextAlignment.Center
        title!.text = NSLocalizedString("InternetErrorTitle", comment: "InternetErrorTitle")
        self.addSubview(title!)

//        var headerWidth = screenWidth - 60
//        var xpos:CGFloat = (screenWidth - headerWidth) / 2
        
        ypos = SharedUIManager.instance.siteView_headerHeight
        var line = UIView(frame: CGRectMake(0, ypos, screenWidth, 0.5))
        line.backgroundColor = UIColor.appButtonColor()
        self.addSubview(line)
        
        fade = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        fade!.backgroundColor = UIColor.blackColor()
        fade!.alpha = 0
        self.addSubview(fade!)
        
        ypos = 110
        warningLogo = BNUIWarningView(position:CGPoint(x:((screenWidth - 110) / 2), y:ypos), scale:2.0)
        warningLogo!.frame.origin.x = ((screenWidth - warningLogo!.frame.width) / 2)
        self.addSubview(warningLogo!)
        warningLogo!.setNeedsDisplay()
        
        ypos += (warningLogo!.frame.height + 10)

        var text = UILabel(frame: CGRectMake(40, ypos, (screenWidth - 80), (SharedUIManager.instance.errorView_text + 3)))
        text.font = UIFont(name:"Lato-Light", size:SharedUIManager.instance.errorView_text)
        text.textColor = UIColor.appTextColor()
        text.textAlignment = NSTextAlignment.Center
        text.text = NSLocalizedString("InternetErrorText", comment: "InternetErrorText")
        text.numberOfLines = 0
        text.sizeToFit()
        self.addSubview(text)
        
        ypos = (screenHeight - 100)
        var siteUrl =  UIButton(frame: CGRectMake(0, ypos, screenWidth, 55))
        siteUrl.setTitle(NSLocalizedString("InternetErrorButton", comment: "InternetErrorButton"), forState: UIControlState.Normal)
        siteUrl.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        siteUrl.backgroundColor = UIColor.biinColor()
        siteUrl.titleLabel!.font = UIFont(name:"Lato-Black", size:SharedUIManager.instance.errorView_button)
        siteUrl.addTarget(self, action: "tryAgainAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(siteUrl)
    }
    
    func tryAgainAction(sender:UILabel) {   
//        delegate!.hideErrorView!(self)
        BNAppSharedManager.instance.errorManager.isAlertOn = false
        var vc = LoadingViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        BNAppSharedManager.instance.errorManager.currentViewController!.presentViewController(vc, animated: true, completion: nil)
        BNAppSharedManager.instance.dataManager.requestInitialData()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func transitionIn() {
        
        UIView.animateWithDuration(0.25, animations: {()->Void in
            self.frame.origin.x = 0
        })
    }
    
    override func transitionOut( state:BNState? ) {
        state!.action()
        
        if state!.stateType == BNStateType.BiinieCategoriesState
            || state!.stateType == BNStateType.SiteState {
                
                UIView.animateWithDuration(0.25, animations: {()-> Void in
                    self.frame.origin.x = SharedUIManager.instance.screenWidth
                })
        } else {
            
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "hideView:", userInfo: nil, repeats: false)
        }
    }
    
    func hideView(sender:NSTimer){
        self.frame.origin.x = SharedUIManager.instance.screenWidth
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
    func backBtnAction(sender:UIButton) {
        delegate!.hideErrorView!(self)
    }
}

@objc protocol InternetErrorView_Delegate:NSObjectProtocol {
    optional func hideErrorView(view:InternetErrorView)
}