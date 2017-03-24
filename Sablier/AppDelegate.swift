//
//  AppDelegate.swift
//  Sablier
//
//  Created by etudiant-09 on 23/03/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       /*
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        */
        
// RGU TEST
        
        UNUserNotificationCenter.current().delegate = 
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }}
        )
        
        
        let notifCenter = UNUserNotificationCenter.current()
        let notifAction1 = UNNotificationAction(identifier: "Action1", title: "restart", options: UNNotificationActionOptions.destructive)
        let notifAction2 = UNNotificationAction(identifier: "Action2", title: "change CountDown", options: [])
        //let notifOption = UNNotificationCategoryOptions.
        
        let notifCat = UNNotificationCategory(identifier: "maCategorieAMoi", actions: [notifAction1, notifAction2], intentIdentifiers: [], options: [.customDismissAction])
        /*
            var notifCatSet = Set<UNNotificationCategory>()
         notifCatSet.insert(notifCat)*/
        
        notifCenter.setNotificationCategories([notifCat])
 
        /*
        let action = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "notif_sabiler_iOS_10", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
 */
// RGU FIN TEST
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
//        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

