//
//  Service.swift
//  uber_clone
//
//  Created by Muslim on 08/09/23.
//

import UIKit
import Firebase
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver_location")
let REF_TRIPS = DB_REF.child("trips")

struct Service {
        
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping (User) -> Void) {
        
        let geoFire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        geoFire.query(at: location, withRadius: 50).observe(.keyMoved) { uid, location in
            fetchUserData(uid: uid) { user in
                var driver = user
                driver.location = location
                completion(driver)
            }
        }
    }
    
    func uploadTrip(pickupCoordinate: CLLocationCoordinate2D,
                    destinationCoordinate: CLLocationCoordinate2D,
                    completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let pickupArray = [pickupCoordinate.latitude, pickupCoordinate.longitude]
        let destinationArray = [destinationCoordinate.latitude, destinationCoordinate.longitude]
        
        let values = [
            "pickupCoordinates": pickupArray,
            "destinationCoordinates": destinationArray,
            "state": TripState.requested.rawValue
        ] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func observeTrips(completion: @escaping(Trip) -> Void) {
        
        REF_TRIPS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            
            let trip = Trip(passengerUID: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    func observeCurrentTrip(completion: @escaping (Trip) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_TRIPS.child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            
            let trip = Trip(passengerUID: uid, dictionary: dictionary)
            completion(trip)
        }
        
        
    }
    
    func acceptTrip(_ trip: Trip, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "driverUID": uid,
            "state": TripState.accepted.rawValue
        ] as [String: Any]
        
        REF_TRIPS.child(trip.passengerUID).updateChildValues(values, withCompletionBlock: completion)
    }
    
}
