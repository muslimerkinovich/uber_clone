//
//  Service.swift
//  uber_clone
//
//  Created by Muslim on 08/09/23.
//

import UIKit
import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
    
    let currentUid = Auth.auth().currentUser!.uid
    
    static let shared = Service()
    
    func fetchUserData(completion: @escaping (User) -> Void) {
         
        REF_USERS.child(currentUid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
        
    }
    
}
