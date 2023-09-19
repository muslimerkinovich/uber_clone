//
//  Trip.swift
//  uber_clone
//
//  Created by Muslim on 19/09/23.
//

import CoreLocation

struct Trip {
    
    var pickupCoordinates: CLLocationCoordinate2D!
    var destinationCoordinates: CLLocationCoordinate2D!
    let passengerUID: String
    var driverUID: String?
    var state: TripState!
    
    init(passengerUID: String, dictionary: [String: Any]) {
        self.passengerUID = passengerUID
        
        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray {
            guard let lat = pickupCoordinates[0] as? CLLocationDegrees else { return }
            guard let long = pickupCoordinates[1] as? CLLocationDegrees else { return }
            
            self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray {
            guard let lat = destinationCoordinates[0] as? CLLocationDegrees else { return }
            guard let long = destinationCoordinates[1] as? CLLocationDegrees else { return }
            
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        if let rawValue = dictionary["state"] as? Int {
            self.state = TripState(rawValue: rawValue)
        }
    }
}

enum TripState: Int {
    case requested
    case accepted
    case inProgress
    case complet
}
