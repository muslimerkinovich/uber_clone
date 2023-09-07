//
//  AppDelegate.swift
//  uber_clone
//
//  Created by Muslim on 06/09/23.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
         
        window = UIWindow()
        
        let vc = HomeVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

}

