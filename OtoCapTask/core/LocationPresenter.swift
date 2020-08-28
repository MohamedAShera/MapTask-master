//
//  LocationPresenter.swift
//  OtoCapTask
//
//  Created by mohamed on 5/6/20.
//  Copyright © 2020 mohamed. All rights reserved.
//


import UIKit
import GoogleMaps
import Bond

class LocationPresenter: BasePresenter {
    
  
    var locationCoordinate: Observable<CLLocationCoordinate2D?> = Observable(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var address: Observable<String?> = Observable("")

    var locationManager: LocationServiceProtocol
    
    
    init( locationManager: LocationServiceProtocol) {
   
        self.locationManager = locationManager
    }
    
    override func hydrate() {
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        locationManager.getUserLocation { [unowned self] in
            self.locationCoordinate.value = $0
            self.getLocationAddress()
        }
    }
    func getLocationAddress() {
        locationManager.getLocationAddress(locationCoordinate.value ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)) { location, address in
            self.address.value = address
            self.locationCoordinate.value = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
         
        }
    }

    
}
