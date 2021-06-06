//
//  AppDelegate.swift
//  Lec17DogApp
//
//  Created by badyi on 05.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainAssembly.createMainModule()
        window?.makeKeyAndVisible()
        return true
    }

}

