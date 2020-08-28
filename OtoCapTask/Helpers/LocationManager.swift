//
//  LocationManager.swift
//  OtoCapTask
//
//  Created by mohamed on 5/6/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftLocation

typealias UserLocation = (_ location: CLLocationCoordinate2D) -> Void
typealias UserLocationWithAddress = (_ location: CLLocationCoordinate2D, _ address: String) -> Void

protocol LocationServiceProtocol {
    func getUserLocation(_ location: @escaping UserLocation)
    func getLocationAddress(_ location: CLLocationCoordinate2D, address: @escaping UserLocationWithAddress )
}

class LocationController: LocationServiceProtocol {
    
    private let geocoder = GMSGeocoder()
    private var viewController: UIViewController
    
    init(_ currentViewController: UIViewController) {
        self.viewController = currentViewController
    }
    
    func getUserLocation( _ userLocation:@escaping UserLocation) {
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .city) { result in
            switch result {
            case .failure(let error):
                debugPrint("Received error: \(error)")
            case .success(let location):
                DispatchQueue.main.async {
                    userLocation(location.coordinate)
                }
            }
        }
    }
    func getLocationAddress(_ location: CLLocationCoordinate2D, address userLocation:@escaping UserLocationWithAddress) {
        geocoder.reverseGeocodeCoordinate(location) {response, _ in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                userLocation(location, lines.joined(separator: "\n"))
            }
        }
    }
    
}
