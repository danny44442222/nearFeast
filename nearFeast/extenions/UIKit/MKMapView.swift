//
//  MKMapView.swift
//  SocialMedia
//
//  Created by Mac on 17/05/2023.
//

import Foundation
import MapKit

extension MKMapView {
    
    func setMapView(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let spain = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
         self.region = MKCoordinateRegion(center: coordinate, span: spain)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        self.setRegion(self.region , animated: true)
        self.addAnnotation(pin)
    }
}
