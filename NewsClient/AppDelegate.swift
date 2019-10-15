//
//  AppDelegate.swift
//  NewsClient
//
//  Created by Taras Didukh on 12.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ((window?.rootViewController as? UINavigationController)?.topViewController as? NewsController)?.newsService = NewsService(network: Network())
        
        return true
    }
}

