//  BiinieCategoriesView_SitesContainer.swift
//  biin
//  Created by Esteban Padilla on 1/16/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class BiinieCategoriesView_SitesContainer: BNView, UIScrollViewDelegate {
    
    //var delegate:BiinieCategoriesView_SiteContainer_Delegate?
    
    var isWorking = false
    var category:BNCategory?
    var sites:Array<SiteMiniView>?
    var addedSitesIdentifiers:Dictionary<String, SiteMiniView>?
    var scroll:UIScrollView?
    var isScrollDecelerating = false
    
    var siteViewHeight:CGFloat = 0
    var siteViewWidth:CGFloat = 0
    var siteSpacer:CGFloat = 10.0
    var columns:Int = 2
//    var siteRequestIndex:Int = 0
    var siteRequestPreviousLimit:Int = 0
    
    
    var lastRowRequested:Int = 0
    
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
        
    }
    
    convenience init(frame:CGRect, father:BNView?, category:BNCategory?){
        self.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.appBackground()
        self.category = category
        
        let screenWidth = SharedUIManager.instance.screenWidth
        let screenHeight = SharedUIManager.instance.screenHeight
        
        scroll = UIScrollView(frame:CGRectMake(0, 0, screenWidth, (screenHeight - SharedUIManager.instance.categoriesHeaderHeight)))
//        scroll!.backgroundColor = UIColor.biinColor()
        scroll!.showsHorizontalScrollIndicator = false
        scroll!.showsVerticalScrollIndicator = false
        scroll!.delegate = self
        scroll!.bounces = false
        self.addSubview(scroll!)
        
        addSites()
    }
    
    convenience init(frame: CGRect, father: BNView?, allSites:Bool) {
        self.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.appBackground()
        
        let screenWidth = SharedUIManager.instance.screenWidth
        let screenHeight = SharedUIManager.instance.screenHeight
        
        scroll = UIScrollView(frame:CGRectMake(0, 0, screenWidth, (screenHeight - (SharedUIManager.instance.categoriesHeaderHeight + 20))))
        //        scroll!.backgroundColor = UIColor.biinColor()
        scroll!.showsHorizontalScrollIndicator = false
        scroll!.showsVerticalScrollIndicator = false
        scroll!.delegate = self
        scroll!.bounces = false
        self.addSubview(scroll!)
        
        addAllSites()
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
    
    //instance methods
    //Start all category work, download etc.
    override func getToWork(){
        isWorking = true
        manageSitesImageRequest()
        //println("\(category!.identifier!) is working")
    }
    
    //Stop all category work, download etc.
    override func getToRest(){
        isWorking = false
        //println("\(category!.identifier!) is resting")
    }
    
    func addSites() {
        
        siteRequestPreviousLimit = 0
        lastRowRequested = 0
        
        var xpos:CGFloat = 0
        var ypos:CGFloat = siteSpacer
        
        var columnCounter = 0
        
        sites = Array<SiteMiniView>()
        
        switch SharedUIManager.instance.deviceType {
        case .iphone4s, .iphone5, .iphone6:
            siteViewWidth = (SharedUIManager.instance.screenWidth - 30) / 2
            siteViewHeight = 240.0
            columns = 2
            break
        case .iphone6Plus:
            siteViewWidth = (SharedUIManager.instance.screenWidth - 40) / 3
            siteViewHeight = SharedUIManager.instance.screenHeight / 4
            columns = 3
            break
        case .ipad:
            siteViewWidth = (SharedUIManager.instance.screenWidth - 40) / 3
            siteViewHeight = SharedUIManager.instance.screenHeight / 3
            columns = 3
            break
        default:
            break
        }
        
        
        print("Number of sites: \(category?.sitesDetails.count)")
        
        for var i = 0; i < category?.sitesDetails.count; i++ {
            
            
            let siteIdentifier = category?.sitesDetails[i].identifier!
            let site = BNAppSharedManager.instance.dataManager.sites[ siteIdentifier!]
  
            if !isSiteAdded(siteIdentifier!) {
                if columnCounter < columns {
                    columnCounter++
                    xpos = xpos + siteSpacer
                    
                } else {
                    ypos = ypos + siteViewHeight + siteSpacer
                    xpos = siteSpacer
                    columnCounter = 1
                }
                
                let miniSiteView = SiteMiniView(frame: CGRectMake(xpos, ypos, siteViewWidth, siteViewHeight), father: self, site:site)
                
                miniSiteView.delegate = father?.father! as! MainView
                
                sites!.append(miniSiteView)
                scroll!.addSubview(miniSiteView)

                xpos = xpos + siteViewWidth
            } else {
                
            }
        }
        
        ypos = ypos + siteViewHeight + siteSpacer
        scroll!.contentSize = CGSizeMake(SharedUIManager.instance.screenWidth, ypos)

        //SharedUIManager.instance.miniView_height = siteViewHeight
        //SharedUIManager.instance.miniView_width = siteViewWidth
        //SharedUIManager.instance.miniView_columns = columns
    }
    
    func addAllSites(){
        
        siteRequestPreviousLimit = 0
        lastRowRequested = 0
        
        var xpos:CGFloat = 0
        var ypos:CGFloat = siteSpacer
        
        var columnCounter = 0
        
        if sites != nil {
            addedSitesIdentifiers!.removeAll(keepCapacity: false)
            for view in sites! {
                view.isPositionedInFather = false
                view.isReadyToRemoveFromFather = true
            }
//
//            sites!.removeAll(keepCapacity: false)
            
        } else {
            sites = Array<SiteMiniView>()
            addedSitesIdentifiers = Dictionary<String, SiteMiniView>()
        }
        
        switch SharedUIManager.instance.deviceType {
        case .iphone4s, .iphone5, .iphone6:
            siteViewWidth = (SharedUIManager.instance.screenWidth - 30) / 2
            siteViewHeight = 240.0
            columns = 2
            break
        case .iphone6Plus:
            siteViewWidth = (SharedUIManager.instance.screenWidth - 30) / 2
            siteViewHeight = SharedUIManager.instance.screenHeight / 3
            columns = 2
            break
        case .ipad:
            siteViewWidth = (SharedUIManager.instance.screenWidth - 40) / 3
            siteViewHeight = SharedUIManager.instance.screenHeight / 3
            columns = 3
            break
        default:
            break
        }
        
        
        
        
        
        
        
        
        /*
        //println("categories backup \(BNAppSharedManager.instance.biinieCategoriesBckup.count)")
        println("user categories(): \(bnUser!.categories.count)")
        
        var sitesArray:Array<BNSite> = Array<BNSite>()
        
        for (key, value) in sites {
            sitesArray.append(value)
        }
        
        sitesArray = sorted(sitesArray){ $0.biinieProximity > $1.biinieProximity  }
        
        sites.removeAll(keepCapacity: false)
        
        for orderedSite in sitesArray {
            sites[orderedSite.identifier!] = orderedSite
        }
        */
        
        var sitesArray:Array<BNSite> = Array<BNSite>()
        
        //let dataManager = BNAppSharedManager.instance.dataManager
        //let user = dataManager.bnUser!
        //var categories = user.categories

        for category in BNAppSharedManager.instance.dataManager.bnUser!.categories {
            if category.hasSites {
                for var i = 0; i < category.sitesDetails.count; i++ {
                    
                    let siteIdentifier = category.sitesDetails[i].identifier!
                    
                    if let site = BNAppSharedManager.instance.dataManager.sites[ siteIdentifier ] {
                        if site.showInView {
                            sitesArray.append(site)
                            print("Adding site.....")
                        }
                    }
                }
            }
        }
        
        sitesArray = sitesArray.sort{ $0.biinieProximity < $1.biinieProximity  }

        /*
        for category in BNAppSharedManager.instance.dataManager.bnUser!.categories {
            if category.hasSites {
                
                println("----------------------------------------------------------------")
                println("Category:\(category.name!), sites:\(category.sitesDetails.count)")
                
                for var i = 0; i < category.sitesDetails.count; i++ {

                    var siteIdentifier = category.sitesDetails[i].identifier!

                    var site = BNAppSharedManager.instance.dataManager.sites[ siteIdentifier ]
                    println("Site:\(site!.title!),  \(siteIdentifier) in category:\(category.identifier!)")
*/
        
        
//        if sitesArray.count == 0 {
//            print("Number of sites: \(sitesArray.count)")
//        }

        for site in sitesArray {
                    if site.showInView {
                        if !isSiteAdded(site.identifier!) {
                            //println("***** ADDING SITE:\(site.identifier!) title: \(site.title!)")
                            
                            if columnCounter < columns {
                                columnCounter++
                                xpos = xpos + siteSpacer
                                
                            } else {
                                ypos = ypos + siteViewHeight + siteSpacer
                                xpos = siteSpacer
                                columnCounter = 1
                            }

                            let miniSiteView = SiteMiniView(frame: CGRectMake(xpos, ypos, siteViewWidth, siteViewHeight), father: self, site:site)
                            miniSiteView.isPositionedInFather = true
                            miniSiteView.isReadyToRemoveFromFather = false
                            miniSiteView.delegate = father?.father! as! MainView
                            
                            sites!.append(miniSiteView)
                            scroll!.addSubview(miniSiteView)
                            
                            xpos = xpos + siteViewWidth
                        
                        } else {
                            for siteView in sites! {
                                if siteView.site!.identifier == site.identifier! && !siteView.isPositionedInFather {
                                    
                                    //println("***** POSITIONING SITE:\(site.identifier!) title: \(site.title!)")
                                    if columnCounter < columns {
                                        columnCounter++
                                        xpos = xpos + siteSpacer
                                        
                                    } else {
                                        ypos = ypos + siteViewHeight + siteSpacer
                                        xpos = siteSpacer
                                        columnCounter = 1
                                    }
                                    siteView.isPositionedInFather = true
                                    siteView.isReadyToRemoveFromFather = false
                                    siteView.frame = CGRectMake(xpos, ypos, siteViewWidth, siteViewHeight)
                                    xpos = xpos + siteViewWidth
                                    
                                    break
                                }
                            }
                            
                            //var miniSiteView = SiteMiniView(frame: CGRectMake(xpos, ypos, siteViewWidth, siteViewHeight), father: self, site:site)
                            
                            //miniSiteView.delegate = father?.father! as! MainView
  
//                            sites!.append(miniSiteView)
//                            scroll!.addSubview(miniSiteView)
                            


                        }
                    }
        }
                    /*
                    else {
//                        for var i = 0; i < sites!.count; i++ {
//                            if sites![i].site!.identifier == siteIdentifier {
//                                println("***** REMOVE SITE:\(siteIdentifier) title: \(sites![i].site!.title!)")
//                                sites![i].removeFromSuperview()
//                                sites!.removeAtIndex(i)
//                                break
//                            }
//                        }
                    }
                }
            }
        }
        */
        ypos = ypos + siteViewHeight + siteSpacer
        scroll!.contentSize = CGSizeMake(SharedUIManager.instance.screenWidth, ypos)
        
        //SharedUIManager.instance.miniView_height = siteViewHeight
        //SharedUIManager.instance.miniView_width = siteViewWidth
        //SharedUIManager.instance.miniView_columns = columns

        
        //var sitesCount = sites!.count
        for var i = 0; i < sites!.count; i++ {
            if sites![i].isReadyToRemoveFromFather {
                //println("***** REMOVE SITE:title: \(sites![i].site!.title!)")
                sites![i].removeFromSuperview()
                sites!.removeAtIndex(i)
                i = 0
    
            }
        }
        
        
    }
    
    override func refresh() {
        addAllSites()
        //getToWork()
    }
    
    /* UIScrollViewDelegate Methods */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //        println("scrollViewDidScroll")
        manageSitesImageRequest()
    }// any offset changes
    
    // called on start of dragging (may require some time and or distance to move)
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //handlePan(scrollView.panGestureRecognizer)
        let mainView = father!.father! as! MainView
        mainView.delegate!.mainView!(mainView, hideMenu: false)
    }
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
    }// called on finger up as we are moving
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    }// called when scroll view grinds to a halt
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    }// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return true
    }// return a yes if you want to scroll to the top. if not defined, assumes YES
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    
    }// called when scrolling animation finished. may be called immediately if already at top
    
    
    func manageSitesImageRequest(){
        
        if !isWorking || sites == nil { return }
        
        if sites!.count > 0 {
            let height = self.siteViewHeight + self.siteSpacer
            let row:Int = Int(floor(self.scroll!.contentOffset.y / height)) + 1

            if lastRowRequested < row {
                
                lastRowRequested = row
                var requestLimit:Int = Int((lastRowRequested + columns) * columns)

                if requestLimit >= sites?.count {
                    requestLimit = sites!.count - 1
                }

                var i:Int = requestLimit
                var stop:Bool = false
                
                while !stop {

                    if i >= siteRequestPreviousLimit {
                        let siteView = sites![i] as SiteMiniView
                        siteView.requestImage()
                        i--
                    } else  {
                        stop = true
                    }
                }
                
                //Error when archiving: command failed due to signal: segmentation fault: 11
                /*
                for var i = requestLimit; i >= siteRequestPreviousLimit ; i-- {
                    //println("requesting for  \(i)")
                    var siteView = sites![i] as SiteMiniView
                    siteView.requestImage()
                }
                */
                
                siteRequestPreviousLimit = requestLimit + 1
            }
        }
    }
    
    func isSiteAdded(identifier:String) -> Bool {
        for siteView in sites! {
            if siteView.site!.identifier == identifier {
                return true
            }
        }
        return false
    }
}

//@objc protocol BiinieCategoriesView_SiteContainer_Delegate:NSObjectProtocol {
    ///Update categories icons on header
    //optional func updateCategorControl(view:BiinieCategoriesView_Header,  position:CGFloat)
//}