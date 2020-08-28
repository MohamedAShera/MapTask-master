//
//  LocationView.swift
//  OtoCapTask
//
//  Created by mohamed on 5/6/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
class LocationView: BaseView<LocationPresenter, BaseItem> {
    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var drawPath: UIButton!
    private var clientMarker: GMSMarker!
    private let locationManager = CLLocationManager()
    var coordinates: [CLLocationCoordinate2D] = []
    var animationPolyline = GMSPolyline()
  
    var polygonPath = GMSPolyline()
 
    override func bindind() {
        
        presenter = LocationPresenter(locationManager: LocationController(self))
        presenter.locationCoordinate.observeNext { response in
            if response?.latitude != 0 {
                self.setupMapAndMarker(response!)
            }
        }
        drawPath.isEnabled = false
        drawPath.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        presenter.address.bidirectionalBind(to: addressTextField.reactive.text)
        
        googleMaps.delegate = self
        googleMaps.isMyLocationEnabled = true

    }
    
    
    @IBAction func getLocation(_ sender: Any) {
        presenter.getCurrentLocation()
    }
    @IBAction func draw(_ sender: Any) {
        createPolygon()
        
    }
  
    func createMarker(point: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        marker.map = googleMaps
    }
    
    func createPolygon(){
        
        let path = GMSMutablePath()
        for coordinate in coordinates{
            path.add(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        path.add(CLLocationCoordinate2D(latitude: coordinates[0].latitude, longitude: coordinates[0].longitude))
        polygonPath = GMSPolyline(path: path)
        polygonPath.strokeColor = UIColor.red
        polygonPath.strokeWidth = 2.0
        polygonPath.map = googleMaps
    }
    
    
}

extension LocationView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        setupMapAndMarker( coordinate)
        presenter.locationCoordinate.value = coordinate
        presenter.getLocationAddress()
        let destination = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        
        coordinates.append(destination)
        createMarker(point: coordinate)
        drawPath.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.6980392157, blue: 0.4980392157, alpha: 1)
        drawPath.isEnabled = true
        
    }
    
    private func setupMapAndMarker(_ coordinates: CLLocationCoordinate2D) {
        if clientMarker == nil {
            clientMarker = GMSMarker()
            clientMarker.map = googleMaps
            clientMarker.isDraggable = true
            clientMarker.tracksInfoWindowChanges = true
        }
        
        clientMarker.position = coordinates
        clientMarker.map = googleMaps
        
        let camera = GMSCameraPosition.camera(withLatitude: clientMarker.position.latitude,
                                              longitude: clientMarker.position.longitude,
                                              zoom: 14, bearing: 270, viewingAngle: 45)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        googleMaps.animate(to: camera)
        CATransaction.commit()
    }
    
}
