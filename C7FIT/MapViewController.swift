//
//  MapViewController.swift
//  C7FIT
//
//  Created by Michael Lee on 2/15/17.
//  Copyright © 2017 Brandon Lee. All rights reserved.
//

import UIKit
import MapKit
import HealthKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    
    // MARK: - Properties
    
    var mapViewApp = MapView()
    lazy var locationManager = CLLocationManager()
    var seconds = 0.0
    var distance = 0.0
    var pace = ""
    lazy var locations = [CLLocation()]
    lazy var timer = Timer()
    
    var lastRun = runData()
    
    class runData {
        var time = 0.0
        var distance = 0.0
        var pace = ""
        var locations = [Location()]
    }
    
    struct Location {
        var timestamp = Date()
        var latitude = CLLocationDegrees()
        var longtitude = CLLocationDegrees()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .orange
        self.edgesForExtendedLayout = []
        
        mapViewApp.startButton.addTarget(self, action: #selector(startTrackRun), for: .touchUpInside)
        mapViewApp.stopButton.addTarget(self, action: #selector(stopTrackRun), for: .touchUpInside)
        
        self.view.addSubview(mapViewApp)
        setupConstraints()
        self.view.setNeedsUpdateConstraints()
        
        
        setupLocationTracking()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Layout
    
    func setupConstraints() {
        mapViewApp.translatesAutoresizingMaskIntoConstraints = false
        let topView = mapViewApp.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomView = mapViewApp.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leftView = mapViewApp.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightView = mapViewApp.rightAnchor.constraint(equalTo: view.rightAnchor)
        NSLayoutConstraint.activate([topView, bottomView, leftView, rightView])
    }
    
    // MARK: - Tracking run
    
    // MARK: Start/Stop Buttons
    func startTrackRun(){
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepingCapacity: false)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
        setupLocationTracking()
    }
    
    func stopTrackRun(){
        //open up run in detail view here
        
        //ask user if they want to save run
        saveRun()
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: Save run
    func saveRun() {
        let tempRun = runData()
        var savedLocations = [Location()]
        
        for location in locations {
            var tempLocation = Location()
            tempLocation.timestamp = location.timestamp
            tempLocation.latitude = location.coordinate.latitude
            tempLocation.longtitude = location.coordinate.longitude
            savedLocations.append(tempLocation)
        }
        
        tempRun.distance = distance
        tempRun.time = seconds
        tempRun.pace = pace
        tempRun.locations = savedLocations
        
        lastRun = tempRun
    }
    
    // MARK: location tracking
    func setupLocationTracking() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                if self.locations.count > 0 {
                    distance += location.distance(from: self.locations.last!)
                }
            }
            
            self.locations.append(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    // MARK: Timer
    func eachSecond(timer: Timer) {
        seconds = seconds + 1
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        mapViewApp.secondsQuantity.text = "Time: " + secondsQuantity.description
        
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        mapViewApp.distanceQuantity.text = "Distance: " + distanceQuantity.description
        
        //convert to mph
        let paceUnit = HKUnit.meter().unitDivided(by: HKUnit.second())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: distance / seconds)
        mapViewApp.paceQuantity.text = "Pace: " + paceQuantity.description
        pace = paceQuantity.description
    }

}
