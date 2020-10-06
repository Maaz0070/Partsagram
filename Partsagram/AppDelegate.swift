//
//  AppDelegate.swift
//  Partsagram
//
//  Created by Maaz Adil on 9/28/20.
//  Copyright © 2020 Maaz Adil. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:
                ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Partsagram"
                configuration.server = "https://desolate-savannah-03786.herokuapp.com/parse"
                
            })
        )
        
        if PFUser.current() != nil { //check to see if parse suer is logged in
            let main = UIStoryboard(name: "Main", bundle: nil)
            let feedNavigationController = main.instantiateViewController(withIdentifier: "FeedNavigationController") // have a instant of FeedNavigationContoller
            window?.rootViewController = feedNavigationController //one window per application that controls anything else. Has rootViewCtonroller the one being displayed
            
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

