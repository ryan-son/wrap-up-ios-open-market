//
//  AppDelegate.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/08/24.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            print("Started up with scene based lifecycle")
        } else {
            print("Started up with app based lifecycle")
            window = UIWindow(frame: UIScreen.main.bounds)

            let viewController = MarketItemsViewController()
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
