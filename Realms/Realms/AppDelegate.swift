//
//  AppDelegate.swift
//  Realms
//
//  Created by ThinhNX on 6/21/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navication = UINavigationController(rootViewController: homeViewController)
        self.window?.rootViewController = navication
    
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
       
    }

    func applicationDidEnterBackground(application: UIApplication) {
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
       
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }


}

