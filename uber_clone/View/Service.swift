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
    
}
