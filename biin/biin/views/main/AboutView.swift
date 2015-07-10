//  AboutView.swift
//  biin
//  Created by Esteban Padilla on 7/9/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class AboutView: BNView {
    
    var delegate:AboutView_Delegate?
    var title:UILabel?
    var backBtn:BNUIButton_Back?
    var fade:UIView?
    var biinLogo:BNUIBiinView?

    
    var scroll:UIScrollView?
    
    
    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.appMainColor()
        
        var screenWidth = SharedUIManager.instance.screenWidth
        var screenHeight = SharedUIManager.instance.screenHeight
        
        var ypos:CGFloat = 12
        title = UILabel(frame: CGRectMake(6, ypos, screenWidth, (SharedUIManager.instance.siteView_titleSize + 3)))
        title!.font = UIFont(name:"Lato-Black", size:SharedUIManager.instance.siteView_titleSize)
        title!.textColor = UIColor.appTextColor()
        title!.textAlignment = NSTextAlignment.Center
        title!.text = NSLocalizedString("About", comment: "About")
        self.addSubview(title!)
        
        backBtn = BNUIButton_Back(frame: CGRectMake(0, 10, 50, 50))
        backBtn!.addTarget(self, action: "backBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(backBtn!)
        
        var headerWidth = screenWidth - 60
        var xpos:CGFloat = (screenWidth - headerWidth) / 2
    
        ypos = SharedUIManager.instance.siteView_headerHeight
        var line = UIView(frame: CGRectMake(0, ypos, screenWidth, 0.5))
        line.backgroundColor = UIColor.appButtonColor()
        
        scroll = UIScrollView(frame: CGRectMake(0, ypos, screenWidth, (screenHeight - ypos)))
        scroll!.backgroundColor = UIColor.appMainColor()
        self.addSubview(scroll!)
        self.addSubview(line)
        
        fade = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        fade!.backgroundColor = UIColor.blackColor()
        fade!.alpha = 0
        self.addSubview(fade!)
        
        ypos = 30
        biinLogo = BNUIBiinView(position:CGPoint(x:((screenWidth - 110) / 2), y:ypos), scale:5.0)
        biinLogo!.frame.origin.x = ((screenWidth - biinLogo!.frame.width) / 2)
        scroll!.addSubview(biinLogo!)
        biinLogo!.setNeedsDisplay()
        
        ypos += (biinLogo!.frame.height + 50)
        var aboutTitle = UILabel(frame: CGRectMake(6, ypos, screenWidth, (SharedUIManager.instance.siteView_titleSize + 3)))
        aboutTitle.font = UIFont(name:"Lato-Black", size:SharedUIManager.instance.siteView_titleSize)
        aboutTitle.textColor = UIColor.appTextColor()
        aboutTitle.textAlignment = NSTextAlignment.Center
        aboutTitle.text = NSLocalizedString("AboutTitle", comment: "AboutTitle")
        scroll!.addSubview(aboutTitle)
        
        ypos += (aboutTitle.frame.height + 5)
        var aboutText = UILabel(frame: CGRectMake(40, ypos, (screenWidth - 80), (SharedUIManager.instance.siteView_subTittleSize + 3)))
        aboutText.font = UIFont(name:"Lato-Light", size:SharedUIManager.instance.siteView_subTittleSize)
        aboutText.textColor = UIColor.appTextColor()
        aboutText.textAlignment = NSTextAlignment.Center
        aboutText.text = NSLocalizedString("AboutText", comment: "AboutText")
        aboutText.numberOfLines = 0
        aboutText.sizeToFit()
        scroll!.addSubview(aboutText)
        
        ypos += (aboutText.frame.height + 20)
        var siteUrl =  UIButton(frame: CGRectMake(0, ypos, screenWidth, 20))
        siteUrl.setTitle("www.biinapp.com", forState: UIControlState.Normal)
        siteUrl.setTitleColor(UIColor.biinColor(), forState: UIControlState.Normal)
        siteUrl.setTitleColor(UIColor.appTextColor(), forState: UIControlState.Selected)
        siteUrl.titleLabel!.font = UIFont(name:"Lato-Light", size:SharedUIManager.instance.siteView_titleSize)
        siteUrl.addTarget(self, action: "openUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        scroll!.addSubview(siteUrl)
    }
    
    func openUrl(sender:UILabel) {
        var targetURL = NSURL(string:"http://www.biinapp.com")
        let application=UIApplication.sharedApplication()
        application.openURL(targetURL!)
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
        delegate!.hideAboutView!(self)
        //delegate!.hideElementView!(elementMiniView)
    }
}

@objc protocol AboutView_Delegate:NSObjectProtocol {
    optional func hideAboutView(view:AboutView)
}
