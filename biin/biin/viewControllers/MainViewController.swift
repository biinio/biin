//  MainViewController.swift
//  Biin
//  Created by Esteban Padilla on 7/25/14.
//  Copyright (c) 2014 Biin. All rights reserved.

import Foundation
import UIKit

class MainViewController:UIViewController, MenuViewDelegate, MainViewDelegate, BNNetworkManagerDelegate {
    
    var mainView:MainView?
    var mainViewDelegate:MainViewDelegate?
    
    var menuView:MenuView?
    var showMenuSwipe:UIScreenEdgePanGestureRecognizer?
    
    var fadeView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("MainViewController - viewDidLoad()")
        
        self.view.layer.cornerRadius = 5
        self.view.layer.masksToBounds = true
        self.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewController(frame:CGRect){
    
        BNAppSharedManager.instance.networkManager.delegateVC = self
        
        mainView = MainView(frame: frame, father:nil, rootViewController: self)
        mainView!.delegate = self
        self.view.addSubview(self.mainView!)
        
        fadeView = UIView(frame: frame)
        fadeView!.backgroundColor = UIColor.blackColor()
        fadeView!.alpha = 0
        fadeView!.userInteractionEnabled = false
        self.view.addSubview(fadeView!)
        
        menuView = MenuView(frame: CGRectMake(-140, 0, 140, frame.height))
        menuView!.delegate = self
        self.view.addSubview(menuView!)
        
        var hideMenuSwipe = UISwipeGestureRecognizer(target: self, action: "hideMenu:")
        hideMenuSwipe.direction = UISwipeGestureRecognizerDirection.Left
        menuView!.addGestureRecognizer(hideMenuSwipe)
        
        showMenuSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: "showMenu:")
        showMenuSwipe!.edges = UIRectEdge.Bottom
        self.view.addGestureRecognizer(showMenuSwipe!)

    }
    
    func showMenu(sender:UIScreenEdgePanGestureRecognizer) {
        if menuView!.isHidden {
            showMenuSwipe!.enabled = false

            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.35, initialSpringVelocity:10.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                self.menuView!.frame.origin.x = -40
                self.mainView!.frame.origin.x = 101
                self.fadeView!.frame.origin.x = 101
                }, completion: {(completed:Bool) -> Void in
                    self.menuView!.isHidden = false
                    
            })
            
            UIView.animateWithDuration(0.25, animations:{()-> Void in
                self.fadeView!.alpha = 0.5
            })
        }
    }
    
    func hideMenu(sender:UIGestureRecognizer) {
        showMenuSwipe!.enabled = true
        
        UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.menuView!.frame.origin.x = -140
            self.mainView!.frame.origin.x = 0
            self.fadeView!.frame.origin.x = 0
            self.fadeView!.alpha = 0
            }, completion: {(completed:Bool) -> Void in
                self.menuView!.isHidden = true
        })
    }
    
    func showFade(){
        
        fadeView!.frame.origin.x = 0
        fadeView!.frame.origin.y = 0
        
        UIView.animateWithDuration(0.25, animations:{()-> Void in
            self.fadeView!.alpha = 0.5
        })
    }
    
    func hideFade(){
        UIView.animateWithDuration(0.25, animations:{()-> Void in
            self.fadeView!.alpha = 0
        })
    }
    
    func disableMenuButton(index:Int){
        menuView!.disableButton(index)
    }
    
    func hideMenuOnChange(){
        showMenuSwipe!.enabled = true

        UIView.animateWithDuration(0.25, animations: {() -> Void in
            self.menuView!.frame.origin.x = -140
            self.mainView!.frame.origin.x = 0
            self.fadeView!.frame.origin.x = 320
            }, completion: {(completed:Bool) -> Void in
                
                self.menuView!.isHidden = true
                self.fadeView!.frame.origin.x = 0
                self.fadeView!.alpha = 0
        })
    }
    
    func tap(sender:UITapGestureRecognizer){

    }
    
    func setNextState(option:Int){

    }
    
    //MenuViewDelegate
    func menuView(menuView: MenuView!, showHome value: Bool) {
        mainView!.setNextState(2)
    }
    
    func menuView(menuView: MenuView!, showSearch value: Bool) {
        mainView!.setNextState(3)
    }
    
    func menuView(menuView: MenuView!, showSettings value: Bool) {
        mainView!.setNextState(4)
    }
    
    func menuView(menuView: MenuView!, showCollections value: Bool) {
        mainView!.setNextState(5)
    }
    
    func menuView(menuView: MenuView!, showProfile value: Bool) {
        mainView!.setNextState(6)
    }
    
    func menuView(menuView: MenuView!, showBoards value: Bool) {
        mainView!.setNextState(7)
    }
    
    //MainViewDelegate
    func mainView(mainView: MainView!, hideMenu value: Bool) {
        self.hideMenu(UIGestureRecognizer())
    }
    
    func mainView(mainView: MainView!, hideMenuOnChange value: Bool) {
        self.hideMenuOnChange()
    }
    
    func mainView(mainView: MainView!, showMenu value: Bool) {
        self.showMenu(UIScreenEdgePanGestureRecognizer())
    }
    
    //BNNetworkManagerDelegate Methods
    func manager(manager: BNNetworkManager!, didReceivedAllInitialData value: Bool) {

    }

    
}