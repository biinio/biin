//  BNRequest_SendBiinie.swift
//  biin
//  Created by Alison Padilla on 9/3/15.
//  Copyright (c) 2015 Esteban Padilla. All rights reserved.

import Foundation

class BNRequest_SendBiinie:BNRequest {
    
    override init() {
        super.init()
    }
    
    deinit{
        
    }
    
    convenience init(requestString:String, errorManager:BNErrorManager, networkManager:BNNetworkManager, user:Biinie) {
        
        self.init()
        self.identifier = BNRequestData.requestCounter++
        self.requestString = requestString
        self.dataIdentifier = ""
        self.requestType = BNRequestType.SendBiinie
        self.errorManager = errorManager
        self.networkManager = networkManager
        self.user  = user
    }
    
    override func run() {
        
        //self.start = NSDate()
        
        isRunning = true
        requestAttemps++
        
        var model = Dictionary<String, Dictionary <String, String>>()
        var modelContent = Dictionary<String, String>()
        modelContent["firstName"] = self.user!.firstName!
        modelContent["lastName"] = self.user!.lastName!
        modelContent["email"] = self.user!.email!
        modelContent["gender"] = self.user!.gender!
        modelContent["facebook_id"] = self.user!.facebook_id!
        
        if self.user!.isEmailVerified! {
            modelContent["isEmailVerified"] = "1"
        } else {
            modelContent["isEmailVerified"] = "0"
        }
        
        if self.user!.birthDate != nil {
            modelContent["birthDate"] = self.user!.birthDate!.bnDateFormatt()
        }
        
        model["model"] = modelContent
        
        //var httpError: NSError?
        var htttpBody:NSData?
        do {
            htttpBody = try NSJSONSerialization.dataWithJSONObject(model, options:[])
        } catch _ as NSError {
            //httpError = error
            htttpBody = nil
        }
        
        var response:BNResponse?
        
        self.networkManager!.epsNetwork!.post(self.identifier, url:self.requestString, htttpBody:htttpBody, callback: {
            
            (data: Dictionary<String, AnyObject>, error: NSError?) -> Void in
            
            if (error != nil) {

                self.networkManager!.handleFailedRequest(self, error: error )
//                response = BNResponse(code:10, type: BNResponse_Type.Suck)
            } else {
                
                //if let dataData = data["data"] as? NSDictionary {
                    
                    let status = BNParser.findInt("status", dictionary: data)
                    let result = BNParser.findBool("result", dictionary: data)
                    
                    if result {
                        response = BNResponse(code:status!, type: BNResponse_Type.Cool)
                    } else {
                        response = BNResponse(code:status!, type: BNResponse_Type.Suck)
                    }
                    
                    self.networkManager!.delegateVC!.manager!(self.networkManager!, didReceivedUpdateConfirmation: response)
         
                //let end = NSDate()
                //let timeInterval: Double = end.timeIntervalSinceDate(self.start!)
                //print("BNRequest_SendBiinie [\(timeInterval)] - \(self.requestString)")
                
                self.inCompleted = true
                self.networkManager!.removeFromQueue(self)
            }
        })
    }
}