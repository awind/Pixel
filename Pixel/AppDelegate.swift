//
//  AppDelegate.swift
//  Pixel
//
//  Created by SongFei on 15/12/3.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import Armchair
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarController: UITabBarController?
        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainVC = UINavigationController(rootViewController: MainViewController())
        let welcomeVC = GuideViewController()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let _ = userDefaults.valueForKey("first") {
            window?.rootViewController = mainVC
        } else {
            window?.rootViewController = welcomeVC
        }
        Armchair.userDidSignificantEvent(true)
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

let Pages = "1071979318"

extension AppDelegate {

    override class func initialize() {
        AppDelegate.setupArmchair()
    }
    
    class func setupArmchair() {
        // Normally, all the setup would be here.
        // But, because we are presenting a few different setups in the example,
        // The config will be in the view controllers
        //	 Armchair.appID("408981381") // Pages
        //
        // It is always best to load Armchair as early as possible
        // because it needs to receive application life-cycle notifications
        //
        // NOTE: The appID call always has to go before any other Armchair calls
        
        Armchair.appID(Pages)
        Armchair.opensInStoreKit(false)
        Armchair.significantEventsUntilPrompt(5)
    }
}


