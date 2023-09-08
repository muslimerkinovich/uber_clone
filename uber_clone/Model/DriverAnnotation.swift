//
//  DriverAnnotion.swift
//  uber_clone
//
//  Created by Muslim on 09/09/23.
//

import Foundation
import MapKit

class DriverAnnotation: NSObject, MKAnnotation {
    
    static let identifier = String(describing: DriverAnnotation.self)
    
    dynamic var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(coordinate: CLLocationCoordinate2D, uid: String) {
        self.coordinate = coordinate
        self.uid = uid
    }
    
    func updateDriverPosition(withCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.5) {
            self.coordinate = coordinate
        }
    }
}
