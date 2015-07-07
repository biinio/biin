//  BNBiin.swift
//  Biin
//  Created by Esteban Padilla on 6/3/14.
//  Copyright (c) 2014 Biin. All rights reserved.

import Foundation


class BNBiin:NSObject
{
    //Identification properties
    var identifier:String?
    var name:String?
    var lastUpdate:NSDate?
    var venue:String?
    var proximityUUID:NSUUID?
    var major:Int?
    var minor:Int?
    
    //Relationship properties
    var accountIdentifier:String?
    var siteIdentifier:String?
    var organizationIdentifier:String?
    var biinType = BNBiinType.NONE
    
    var isBiinDataCorrupted:Bool = false
    var isBiinDetected:Bool = false
    
    //REMOVE ->
    weak var site:BNSite?
    var showcase:BNShowcase?
    var showcases:Array<BNShowcase>?//REMOVE LATER
    var currentShowcaseIndex:Int = 0
    //REMOVE <-
    
    var objects:Array<BNBiinObject>?
    var currentObjectIndex:Int = 0
    
    var state:Biin_State?
    var proximity = BNBiinProximityType.NA
    var children:Array<Int>?
    
    override init() {
        super.init()
        self.isBiinDataCorrupted = false
        self.isBiinDetected = false
    }
    
    deinit{
        
    }
    
    func currectShowcase()->BNShowcase {
        //assingCurrectShowcase()
        return showcases![currentShowcaseIndex]
    }
    
    func currectObject() ->BNBiinObject {
        assingCurrectObject()
        return objects![currentObjectIndex]
    }
    
    func setBiinState(){
        
        if objects != nil {
            if objects!.count > 0 {
                assingCurrectObject()
                if objects![currentObjectIndex].isBiined {
                    //Biined
                    if objects![currentObjectIndex].isUserNotified {
                        //User notified
                        state = Biined_Notified_State(biin: self)
                    } else {
                        //User not notified
                        state = Biined_Not_Notified_State(biin: self)
                    }
                } else {
                    //Biin (not biined)
                    if objects![currentObjectIndex].isUserNotified {
                        //User notified
                        state = Biin_Notified_State(biin: self)
                    } else {
                        //User not notified
                        state = Biin_Not_Notified_State(biin: self)
                    }
                }
            }
        }
        
        
        /*
        //TODO: set biin state depending on showcase.
        //1. Check if showcases is not empty
        if let showcasesList = showcases {
            
            //2. Set current showcase
            if showcases!.count > 0 {
                //a. There are many showcases in biin
                assingCurrectShowcase()
            } else {
                //b. There is only one showcase in biin
                currentShowcaseIndex = 0
            }
            
            if didUserBiinedSomethingInShowcase() {
                if showcases![currentShowcaseIndex].isUserNotified {
                    //State id 2
                    self.state = Biined_Not_Notified_State(biin: self)
                }else {
                    //State id 1
                    self.state = Biined_Notified_State(biin: self)
                }
            } else {
                if showcases![currentShowcaseIndex].isUserNotified {
                    //State id 4
                    self.state = Biin_Notified_State(biin: self)
                }else {
                    //State id 3
                    self.state = Biin_Not_Notified_State(biin: self)
                }
            }
        }
        */
    }
    
    func assingCurrectShowcase(){
        //TODO: get the correct showcase depending on the time
        currentShowcaseIndex = 0
    }
    
    func didUserBiinedSomethingInShowcase()->Bool{
        
        /*
        for element in showcases![currentShowcaseIndex].elements {
            if element.userBiined {
                return true
            }
        }
        */
        return false
    }
    
    func assingCurrectObject(){
        //TODO: get the correct object depending on the time and properties.
        var isCurrentObjectSet = false
        
        if objects!.count > 0 {
        
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
            let hour = components.hour
            let minutes = components.minute
            let currentTime:Float = Float(hour) + (Float(minutes) * 0.01)
            
            var isAvailableToday = false
            
            var dayNumber = getDayOfWeek()
            for var i = 0; i < objects?.count; i++ {
                
//                println("Day:\(getDayOfWeek())")
//                println("CUrrent object:\(objects![i].identifier!) index;\(i)")
//                println("Start time:\(objects![i].startTime)")
//                println("End time: \(objects![i].endTime)")
                
                if currentTime >= objects![i].startTime {
                    if currentTime <= objects![i].endTime {

                        switch dayNumber {
                        case 1://Sunday
                            if objects![i].onSunday {
                                isAvailableToday = true
                            }
                            break
                        case 2://Monday
                            if objects![i].onMonday {
                                isAvailableToday = true
                            }
                            break
                        case 3://Tuesday
                            if objects![i].onTuesday {
                                isAvailableToday = true
                            }
                            break
                        case 4://Wednesday
                            if objects![i].onWednesday {
                                isAvailableToday = true
                            }
                            break
                        case 5://Thurday
                            if objects![i].onThursday {
                                isAvailableToday = true
                            }
                            break
                        case 6://Friday
                            if objects![i].onFriday {
                                isAvailableToday = true
                            }
                            break
                        case 7://Saturday
                            if objects![i].onSaturday {
                                isAvailableToday = true
                            }
                            break
                        default:
                            isAvailableToday = false
                            break
                        }

                        
                        if isAvailableToday {
                            currentObjectIndex = i
                            isCurrentObjectSet = true
//                            println("Day:\(getDayOfWeek())")
//                            println("CUrrent object:\(objects![i].identifier!) index;\(currentObjectIndex)")
//                            println("Start time:\(objects![currentObjectIndex].startTime)")
//                            println("End time: \(objects![currentObjectIndex].endTime)")

                        } else {
                            currentObjectIndex = 0
                            isCurrentObjectSet = true
//                            println("Day:\(getDayOfWeek())")
//                            println("CUrrent object index;\(currentObjectIndex)")
//                            println("Start time:\(objects![currentObjectIndex].startTime)")
//                            println("End time: \(objects![currentObjectIndex].endTime)")
                        }
                    }
                }
            }
        }
        
        if !isCurrentObjectSet {
            println("Setting defaul!")
            currentObjectIndex = 0
            println("CUrrent object index;\(currentObjectIndex)")
            println("Start time:\(objects![currentObjectIndex].startTime)")
            println("End time: \(objects![currentObjectIndex].endTime)")
        }
    }
    
    func getDayOfWeek()->Int {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var today = NSDate().bnShortDateFormat()
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return 0
        }
    }
    
    func didUserBiinedSomethingInBiinObjects()->Bool {
        
        for object in self.objects! {
         
            switch object.objectType {
            case .ELEMENT:
                break
            case .SHOWCASE:
                break
            default:
                break
            }
        }
        
        /*
        for element in showcases![currentShowcaseIndex].elements {
            if element.userBiined {
                return true
            }
        }
        */
        
        return false
    }
    
    func context(){
        state!.action()
    }
    
    func updateBiinType(){
        switch minor! {
        case 1:
            biinType = BNBiinType.EXTERNO
        case 2:
            biinType = BNBiinType.INTERNO
        case 3:
            biinType = BNBiinType.PRODUCT
        default:
            break
        }
    }
}

enum BNBiinType {
    case NONE       //0
    case EXTERNO    //1
    case INTERNO    //2
    case PRODUCT    //3
    
}

enum BNBiinProximityType {
    case NA   //0
    case INM    //1
    case NEAR   //2
}