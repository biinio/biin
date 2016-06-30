//  BNRequest_SendLikedElement.swift
//  biin
//  Created by Alison Padilla on 9/7/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation

class BNRequest_SendLikedElement: BNRequest {
    
    override init(){
        super.init()
    }
    
    deinit{
        
    }
    
    convenience init(requestString:String, errorManager:BNErrorManager, networkManager:BNNetworkManager, element:BNElement? ){
        self.init()
        //self.identifier = BNRequestData.requestCounter++
        self.requestString = requestString
        self.dataIdentifier = dataIdentifier
        self.requestType = BNRequestType.SendLikedElement
        self.errorManager = errorManager
        self.networkManager = networkManager
        self.element = element
    }
    
    override func run() {
        
        //print("BNRequest_SendLikedElement - \(requestString)")

        isRunning = true
        requestAttemps += 1
        
        var model = Dictionary<String, Dictionary <String, String>>()
        
        var modelContent = Dictionary<String, String>()
        modelContent["identifier"] = self.element!.identifier!
        modelContent["showcaseIdentifier"] = self.element!.showcase!.identifier!
        modelContent["siteIdentifier"] = self.element!.showcase!.site!.identifier!
        modelContent["type"] = "element"
        model["model"] = modelContent
        
        //var httpError: NSError?
        var htttpBody:NSData?
        do {
            htttpBody = try NSJSONSerialization.dataWithJSONObject(model, options:[])
        } catch _ as NSError {
            //httpError = error
            htttpBody = nil
        }
        
//        var response:BNResponse?
        
        self.networkManager!.epsNetwork!.put(self.identifier, url:self.requestString, htttpBody:htttpBody, callback: {
            
            (data: Dictionary<String, AnyObject>, error: NSError?) -> Void in
            
            if (error != nil) {
                self.networkManager!.handleFailedRequest(self, error: error )
//                response = BNResponse(code:10, type: BNResponse_Type.Suck)
            } else {
                
                //if let dataData = data["data"] as? NSDictionary {
//                    
//                    let status = BNParser.findInt("status", dictionary: data)
//                    let result = BNParser.findBool("result", dictionary: data)
//                    
//                    if result {
//                        response = BNResponse(code:status!, type: BNResponse_Type.Cool)
//                        
//                    } else {
//                        response = BNResponse(code:status!, type: BNResponse_Type.Suck)
//                    }
//                    
//                    self.networkManager!.delegateVC!.manager!(self.networkManager!, didReceivedUpdateConfirmation: response)
//                //}
                
                self.inCompleted = true
                self.networkManager!.removeFromQueue(self)
            }
        })
    }
}
