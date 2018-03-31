//
//  ViewController.swift
//  IndoorGeolocation
//
//  Created by Ruben Garcia on 3/31/18.
//  Copyright © 2018 Ruben Garcia. All rights reserved.
//

import UIKit
import CoreLocation


// Create LocationManager object
// Set a reason as to why we're asking for that in the info.plist
// Request authorization on the device
// ClRegion - All the beacon's Data
// If the user authorized, then we're going to start ranging for the beacon we've set up
// Read the proximity property on the beacon as it's ranged and change the screen colour based on that

class ViewController: UIViewController {
    var locaticonManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Request authorization on the device
        locaticonManager.delegate = self
        locaticonManager.requestAlwaysAuthorization()
    }
    
    func rangeBeacons() {
        let uuid = UUID(uuidString: "Beacon uuid")
        let major: CLBeaconMajorValue = 31745
        let minor: CLBeaconMinorValue = 64019
        let identifier = "fm.combo.livingRoomBeacon"
        
        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: identifier)
        locaticonManager.startRangingBeacons(in: region)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // User has authorized the application - range those beacons!
            rangeBeacons()
        }
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard let discoveredBeaconProximity = beacons.first?.proximity else {print("Couldn't find the beacon!"); return}
        let backgroundColour: UIColor = {
            switch discoveredBeaconProximity {
                case .immediate: return UIColor.green
                case .near: return UIColor.orange
                case .far: return UIColor.red
                case .unknown: return UIColor.black
            }
        }()
        view.backgroundColor = backgroundColour
    }
}
