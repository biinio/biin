//  BNPositionManager.swift
//  Biin
//  Created by Esteban Padilla on 6/3/14.
//  Copyright (c) 2014 Biin. All rights reserved.

import Foundation
import CoreLocation

class BNPositionManager:NSObject, CLLocationManagerDelegate, BNDataManagerDelegate
{
    var locationManager:CLLocationManager?// = CLLocationManager()
    var errorManager:BNErrorManager
    
    var delegateDM:BNPositionManagerDelegate?
    var delegateView:BNPositionManagerDelegate?
    
    //objective c implementation
    var firstBeacon:CLBeacon?
    var firstBeaconUUID:String?
    
    var counter = 0
    var counterLimmit = 60
    
    var firstBeaconProximity = BNProximity.None
    var counterProximity = 0
    var counterProximityLimit = 60
    
    var myBeacons = Array<CLBeacon>()
    var myBeaconsPrevious = Array<CLBeacon>()
    
    var biins = Array<BNBiin>()
    var rangedRegions:NSMutableDictionary = NSMutableDictionary();
    
    init(errorManager:BNErrorManager){
        
        self.errorManager = errorManager

        super.init()

        self.startLocationService()
    }
    
    func startLocationService()
    {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
        }
        
        self.locationManager!.delegate = self
        self.locationManager!.pausesLocationUpdatesAutomatically = true
        self.locationManager!.activityType = CLActivityType.OtherNavigation
        self.locationManager!.distanceFilter = kCLLocationAccuracyNearestTenMeters
        self.locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        
        //TODO: Remove all monitoring regions
        
    }
    
    
    //CLLocationManagerDelegate - Responding to Location Events
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]) {
        self.delegateView?.manager?(self, printText:"LocationManager update should not be working")
//        var location:CLLocation = locations[0] as CLLocation
//        println("updade location latitude: \(location.coordinate.latitude)")
//        println("updade location longitude: \(location.coordinate.latitude)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError) {
        var text = "Error: " + error.description
        self.delegateView?.manager?(self, printText: text)
    }
    
    
    //CLLocationManagerDelegate - Responding to Region Events
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        var text = "Monitoring: " + region.identifier
        self.delegateView?.manager?(self, printText: text)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion) {
        var text = "Enter region: " + region.identifier
        self.delegateView?.manager?(self, printText: text)
        self.delegateDM!.manager!(self, startEnterRegionProcessWithIdentifier: region.identifier)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion) {
        var text = "Exit region: " + region.identifier
        self.delegateView?.manager?(self, printText: text)
        self.delegateDM!.manager!(self, startExitRegionProcessWithIdentifier: region.identifier)
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        
        switch state {
        case .Inside:
            println("Region state: \(state.hashValue) for region: \(region!.identifier)")
//            self.delegateDM!.manager!(self, startEnterRegionProcessWithIdentifier:region!.identifier)
            break
        case .Outside:
            
            break
        case .Unknown:
            
            break
        default:
            
            break
        }
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        var text = "Error: " + error.description
        self.delegateView?.manager?(self, printText: text)
    }
    
    //CLLocationManagerDelegate - Responding to Ranging Events
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject], inRegion region: CLBeaconRegion!)
    {
        //Sets detected beacon to proper region
        self.rangedRegions[region] = beacons
        
        //Clean local beacon
        self.myBeacons.removeAll(keepCapacity: false)
        
        //Get all beacon from regions
        for (key:AnyObject, value:AnyObject) in self.rangedRegions {
            self.myBeacons += value as Array<CLBeacon>
        }
        
        self.myBeacons = sorted(self.myBeacons){ $0.rssi > $1.rssi }
        
        if !self.myBeacons.isEmpty {
            
            
            if !checkArraysEquality(self.myBeacons, array2:self.myBeaconsPrevious) {
                
                self.counter++
                
                if self.counter == self.counterLimmit {
                    self.counter = 0
                    self.myBeaconsPrevious = self.myBeacons
                    
                    /*
                    println("Biin Order-------------------------------------")
                    for b:CLBeacon in self.myBeacons {
                        println(b.proximityUUID.UUIDString)
                    }
                    */
                    
                    self.orderBiins(self.myBeacons)
                    
                    //TEMP: update table view
//                    if self.delegateView is BNPositionManagerDelegate {
                        self.delegateView?.manager!(self, updateMainViewController: self.biins)
//                    }
                }
            }
            
            //Check how close is first beacon to device.
            if didProximityChanged(self.myBeacons[0].rssi) {
                //TODO: implement proximity changes on first beacon.
            }
            
        } else {
            self.firstBeacon = nil
            self.firstBeaconUUID = nil
            self.counterProximity = 0
            self.counter = 0
        }
    }
    
    //The method checks is the tow Arrays are order the same way.
    func checkArraysEquality(array1:Array<CLBeacon>, array2:Array<CLBeacon>) -> Bool{
        if array1.isEmpty || array2.isEmpty || array1.count != array2.count {
            return false
        } else {
            for var i = 0; i < array1.count; i++ {
                if array1[i].proximityUUID.UUIDString != array2[i].proximityUUID.UUIDString {
                    return false
                }
            }
        }
        return true
    }

    //TODO: Remove this method if not needed.
    //The method checks is first beacon on list has change.
    func didFirstBeaconChanged(uuid:String) -> Bool {
        var returnValue = false
        
        if self.firstBeacon == nil {
            self.firstBeaconUUID = uuid
            returnValue = true
        } else if self.firstBeaconUUID != uuid {
            self.counter++
            if self.counter == self.counterLimmit {
                self.firstBeaconUUID = uuid
                self.counter = 0
                returnValue = true
            }
        } else {
            self.counter = 0
        }
        
        return returnValue
    }
    
    //This method sets the proximity on first beacon on list and return 
    //bool is proximity on first beacon has change.
    func didProximityChanged(proximity:Int) ->Bool {
        var returnValue = false
        var currentProximity = BNProximity.None
        
        if proximity <= -85 {
            currentProximity = BNProximity.Far
        } else if proximity <= -80 {
            currentProximity = BNProximity.Near
        } else if proximity <= -70 {
            currentProximity = BNProximity.Inmediate
        } else if proximity <= -60 {
            currentProximity = BNProximity.Over
        }
        
        if currentProximity != self.firstBeaconProximity {
            if self.counterProximity == self.counterProximityLimit {
                self.firstBeaconProximity = currentProximity
                self.counterProximity = 0
                returnValue = true
            } else {
                self.counterProximity++
            }
        }
        
        return returnValue
    }
    
    //This method order the biin list according to beacons detected on field.
    func orderBiins(beacons:Array<CLBeacon>) {

        //Create an Array to temporary backup biins.
        var biinBackup:Array<BNBiin> = Array<BNBiin>()

        //Remove and backup biins from local list.
        for beacon in beacons {
            for var i = 0; i < self.biins.count; i++ {
//                if beacon.proximityUUID.UUIDString == self.biins[i].proximityUUID!.UUIDString {
//                    biinBackup.append(self.biins[i])
//                    self.biins.removeAtIndex(i)
//                }
            }
        }
        
        //Put back backup biin on local list.
        if !biinBackup.isEmpty {
            for var i = 0; i < biinBackup.count; i++ {
                self.biins.insert(biinBackup[i], atIndex: i)
            }
        }
        
        //clear biinBackup
        biinBackup.removeAll(keepCapacity: false)
    }
    
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        //TODO: send error when failing ranging on a region.
    }
    
    //CLLocationManagerDelegate - Responding to Authorization Changes
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    //CLLocationManagerDelegate - Responding to Visit Events
    func locationManager(manager: CLLocationManager!, didVisit visit: CLVisit!) {
        
    }
    
    //Methods to conform on BNPositionManager
    func manager(manager:BNDataManager!, startRegionsMonitoring regions:Array<BNRegion>) {
        
        for region in regions {
            
            println("Monitoring region: \(region.identifier!)")
            
            if region.latitude == nil || region.longitude == nil {
                return
            }
            
            var radiuos:CLLocationDistance = CLLocationDistance(region.radious!)
            var lat:CLLocationDegrees? = CLLocationDegrees(region.latitude!)
            var long:CLLocationDegrees? = CLLocationDegrees(region.longitude!)
            var coord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, long!)
            var clRegion:CLCircularRegion = CLCircularRegion(center: coord, radius: radiuos, identifier: region.identifier!)
            self.locationManager!.startMonitoringForRegion(clRegion)
            self.locationManager!.requestStateForRegion(clRegion)
            
            self.delegateView?.manager!(self, setPinOnMapWithLat: region.latitude!, long: region.longitude!, radious: region.radious!, title: region.identifier!, subtitle: region.identifier!)
        }
    }
    
    func manager(manager:BNDataManager!, stopRegionsMonitoring regions:Array<BNRegion>) {

        for region in regions {
            
            if region.latitude == nil || region.longitude == nil {
                return
            }
            
            var radiuos:CLLocationDistance = CLLocationDistance(region.radious!)
            var lat:CLLocationDegrees? = CLLocationDegrees(region.latitude!)
            var long:CLLocationDegrees? = CLLocationDegrees(region.longitude!)
            var coord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, long!)
            var clRegion:CLCircularRegion = CLCircularRegion(center: coord, radius: radiuos, identifier: region.identifier!)
            self.locationManager!.stopMonitoringForRegion(clRegion)
            self.locationManager!.requestStateForRegion(clRegion)
            
        }
    }
    
    

    //BNDataManagerDelegate Methods
    func manager(manager:BNDataManager, startSiteMonitoring site:BNSite) {
        
    }
    

    func manager(manager:BNDataManager, stopSiteMonitoring site:BNSite) {
        
    }
    
    
    //Old methods use to monitor biins. now the app monitors sites by uuid and idestifier, Remove this methods later startBiinMonitoring and stopBiinMonitoring
    func manager(manager:BNDataManager!, startBiinMonitoring biin:BNBiin) {
        /*
        println("Start biin monitoring: \(biin.identifier) with uuid \(biin.proximityUUID!.UUIDString)")
    
        if !self.biins.hasBiin(biin) {
            self.stopMonitoringBeaconRegions()
            
            self.biins.append(biin)
            self.myBeacons = Array<CLBeacon>()
            self.rangedRegions = NSMutableDictionary()
            
            for obj in self.biins {
                var major:CLBeaconMajorValue = UInt16(obj.major!)
                var minor:CLBeaconMajorValue = UInt16(obj.minor!)
                var region:CLBeaconRegion = CLBeaconRegion(proximityUUID: obj.proximityUUID!, major:major, minor:minor, identifier: obj.identifier!)
                self.rangedRegions[region] = NSArray()
            }
            
            self.startMonitoringBeaconRegions()
        }
        */
    }
    
    func manager(manager:BNDataManager!, stopBiinMonitoring biin:BNBiin) {
        /*
        self.stopMonitoringBeaconRegions()
        
        for var i = 0; i < self.biins.count; i++ {
            if self.biins[i] == biin {
                self.biins.removeAtIndex(i)
                return
            }
        }
        
        self.myBeacons = Array<CLBeacon>()
        self.rangedRegions = NSMutableDictionary()
        
        for obj in self.biins {
            var major:CLBeaconMajorValue = UInt16(obj.major!)
            var minor:CLBeaconMinorValue = UInt16(obj.minor!)
            var region:CLBeaconRegion = CLBeaconRegion(proximityUUID: obj.proximityUUID!, major: major, minor: minor, identifier: obj.identifier!)
            self.rangedRegions[region] = NSArray()
        }
        
        self.startMonitoringBeaconRegions()
        */
    }
    
    func startMonitoringBeaconRegions() {
        for (key:AnyObject, value:AnyObject) in self.rangedRegions {
            self.locationManager!.startRangingBeaconsInRegion(key as CLBeaconRegion)
        }
    }
    
    func stopMonitoringBeaconRegions() {
        for (key:AnyObject, value:AnyObject) in self.rangedRegions {
            self.locationManager!.stopRangingBeaconsInRegion(key as CLBeaconRegion)
        }
    }
    
    //Methods related to Beacons
}


func == (biin1:CLBeacon, biin2:CLBeacon) -> Bool {
    return biin1.proximityUUID.UUIDString == biin2.proximityUUID.UUIDString
}

func != (biin1:CLBeacon, biin2:CLBeacon) -> Bool {
    return biin1.proximityUUID.UUIDString != biin2.proximityUUID.UUIDString
}

func == (biin1:BNBiin, biin2:BNBiin) -> Bool {
    return biin1.identifier == biin2.identifier
}

 func != (biin1:BNBiin, biin2:BNBiin) -> Bool {
    return biin1.identifier != biin2.identifier
}

@objc protocol BNPositionManagerDelegate:NSObjectProtocol
{
    optional func manager(manager:BNPositionManager!, startEnterRegionProcessWithIdentifier identifier:String)
    optional func manager(manager:BNPositionManager!, startExitRegionProcessWithIdentifier identifier:String)
    optional func manager(manager:BNPositionManager!, markBiinAsDetectedWithUUID uuid:String)
    
    //temporal methods
    optional func manager(manager:BNPositionManager!, updateMainViewController biins:Array<BNBiin>)
    optional func manager(manager:BNPositionManager!,  setPinOnMapWithLat lat:Float, long:Float, radious:Int , title:String, subtitle:String)
    optional func manager(manager:BNPositionManager!,  printText text:String)
}

enum BNProximity
{
    case Over
    case Inmediate
    case Near
    case Far
    case None
}

extension Array {
     func hasBiin(child:BNBiin) -> Bool {
        for obj in self {
            if child == obj as BNBiin {
                return true
            }
        }
        return false
    }
}