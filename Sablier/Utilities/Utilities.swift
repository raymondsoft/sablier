//
//  Utilities.swift
//  sablier
//
//  Created by nicolas on 20/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

 import Foundation
 import UIKit
 import UserNotifications
 
class Utilities {
    
    // -MARK: ALL iOS Notification
    
    static func createNotification(
        at delay    : TimeInterval,
        title       : String,
        body        : String,
        badgeNumber : NSNumber  = 0,
        soundName   : String?   = nil)
    {
        if #available(iOS 10.0, *) {
            createNotificationIos10(at: delay, title: title, body: body, badgeNumber: badgeNumber, soundName: soundName)
        }
        else if #available(iOS 4.0, *) {
            scheduleLocalNotification(delay: delay, body: body, title: title, soundName: soundName)
        }
        else {
            print("Pas de bol !")
        }
    }
    
    
    static func removeNotifications() {
        if #available(iOS 10.0, *) {
            cancelLocalNotificationsIos10()
        } else if #available(iOS 4.0 , *) {
            cancelLocalNotifications()
        }
        else {
            print("pas de bol !")
        }
    }
    
    // -MARK: POST iOS 10
    
    static func test() {
        let notifCenter = UNUserNotificationCenter.current()
        let notifAction1 = UNNotificationAction(identifier: "Action1", title: "restart", options: UNNotificationActionOptions.destructive)
        let notifAction2 = UNNotificationAction(identifier: "Action2", title: "change CountDown", options: .foreground)
        //let notifOption = UNNotificationCategoryOptions.
        
        let notifCat = UNNotificationCategory(identifier: "action1", actions: [notifAction1, notifAction2], intentIdentifiers: ["rstrt", "chgCtdn"], options: .customDismissAction)
        var notifCatSet = Set<UNNotificationCategory>()
        notifCatSet.insert(notifCat)
        
        notifCenter.setNotificationCategories(notifCatSet)
    }
    
    @available(iOS 10.0, *)
    static func createNotificationIos10(
        at delay    : TimeInterval,
        title       : String,
        body        : String,
        badgeNumber : NSNumber  = 0,
        soundName   : String?   = nil)
    {
        let notifContent = UNMutableNotificationContent()
        notifContent.title = title
        notifContent.badge = badgeNumber
        notifContent.body = body
        notifContent.categoryIdentifier = "maCategorieAMoi"
        
        // Add Sound to notifContent
        let notifSound : UNNotificationSound
        if let sound = soundName {
            notifSound = UNNotificationSound(named: sound)
        }
        else {
           notifSound = UNNotificationSound.default()
        }
        notifContent.sound = notifSound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: "notif_sabiler_iOS_10", content: notifContent, trigger: trigger)
        let notifCenter = UNUserNotificationCenter.current()
        

        notifCenter.add(request, withCompletionHandler: nil)
        
    }
    
    
    static func cancelLocalNotificationsIos10() {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.removeAllPendingNotificationRequests()
    }
    
    // https://swifting.io/blog/2016/08/22/23-notifications-in-ios-10/
    @available(iOS 10.0, *)
    static func scheduleLocalNotificationIos10(delay: TimeInterval, body: String, title: String?, soundName: String?) {
        let content = UNMutableNotificationContent()
        content.body = body
        
        if title != nil {
            content.title = title!
        }
        
        content.subtitle = "Subtitle"
        content.launchImageName = "croix"
        /*
         let attachment = try? UNNotificationAttachment(identifier: "myimage",
         url: url,
         options: [:])
         if let attachment = attachment {
         content.attachments.append(attachment)
         }*/
    }
    
    
    
    // -MARK: PRE iOS 10
    
    @available(iOS, deprecated: 10.0)
    static func registerForNotifications() {
        let application = UIApplication.shared
        
        let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    
    @available(iOS, deprecated: 10.0)
    static func scheduleLocalNotification(delay: TimeInterval, body: String, title: String?, soundName: String?) {
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date.init(timeIntervalSinceNow: delay)
        
        localNotification.alertBody = body
        localNotification.applicationIconBadgeNumber = 1
        
        if soundName != nil {
            localNotification.soundName = soundName
        }
        else {
            localNotification.soundName = UILocalNotificationDefaultSoundName
        }
        
        if title != nil {
            if #available(iOS 8.2, *) {
                localNotification.alertTitle = title
            } else {
                // Fallback on earlier versions
            }
        }
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    @available(iOS, deprecated: 10.0)
    static func cancelLocalNotifications() {
        let app = UIApplication.shared
        let notifications = app.scheduledLocalNotifications
        
        if notifications != nil {
            app.cancelAllLocalNotifications()
        }
    }
}









//
//  Utilities.swift
//  sablier
//
//  Created by nicolas on 20/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//



/*
import Foundation
import UIKit
import UserNotifications

class Parameters {
    static let nomDuCapitaine = "toto"
    static let TESTVERSION = true
    static let cornerRadius: CGFloat = 8
}


class Utilities {
    
    static func logDebug(_ message: String) {
        if Parameters.TESTVERSION {
            NSLog(message)
        }
    }
    
    static func logError(_ message: String) {
        if Parameters.TESTVERSION {
            NSLog("💔ERROR💔" + message)
        }
    }
    
    static func sayHello() {
        print("hello")
    }
    
    static func animateView (_ myView : UIView, duration : Double, delay : Double) {
        let x0 = myView.frame.origin.x
        let y0 = myView.frame.origin.y
        let w0 = myView.frame.size.width
        let h0 = myView.frame.size.height
        
        
        UIView.animate(withDuration: TimeInterval(duration), delay: delay, options: [], animations: {
            
            // frame de la vue A LA FIN de l'animation
            myView.frame = CGRect(x: x0+100, y: y0, width: w0, height: h0);
        }     , completion: nil)
    }
    
    static func appearFromRight (_ theview: UIView, duree: Float, delay : Float, completionHandler:(()->Void)? ) {
        let x1 = theview.frame.origin.x
        let y1 = theview.frame.origin.y
        let w1 = theview.frame.size.width
        let h1 = theview.frame.size.height
        
        // modifie la view AVANT l'animation. La vue est décalée à droite
        theview.frame = CGRect(x: realScreenWidth(), y: y1, width: w1, height: h1)
        theview.isHidden = false
        
        UIView.animate(withDuration: TimeInterval(duree), delay: 0, options: [], animations: {
            theview.frame = CGRect(x: x1, y: y1, width: w1, height: h1);
        }, completion: {(Bool) in
            
            if completionHandler != nil {
                completionHandler!()
            }
            
        })
    }
    
    //renvoie la largeur effective compte tenu de l'orientation (et non pas la largeur du device)
    static func realScreenWidth() -> CGFloat {
        return CGFloat(UIScreen.main.bounds.size.width)
    }
    
    
    //renvoie la hauteur effective compte tenu de l'orientation (et non pas la hauteur du device)
    static func realScreenHeight() -> CGFloat {
        return CGFloat(UIScreen.main.bounds.size.height)
    }
    
    static func isLandscape() -> Bool {
        let orientation =  UIApplication.shared.statusBarOrientation
        
        return ((orientation == UIInterfaceOrientation.landscapeLeft ) || (orientation == UIInterfaceOrientation.landscapeRight))
    }
    
    // https://swifting.io/blog/2016/08/22/23-notifications-in-ios-10/
    @available(iOS 10.0, *)
    static func scheduleLocalNotificationIos10(delay: TimeInterval, body: String, title: String?, soundName: String?) {
        let content = UNMutableNotificationContent()
        content.body = body
        
        if title != nil {
            content.title = title!
        }
        
        content.subtitle = "Subtitle"
        content.launchImageName = "croix"
        /*
         let attachment = try? UNNotificationAttachment(identifier: "myimage",
         url: url,
         options: [:])
         if let attachment = attachment {
         content.attachments.append(attachment)
         }*/
    }
    
    
    static func registerForNotifications() {
        let application = UIApplication.shared
        
        let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    static func scheduleLocalNotification(delay: TimeInterval, body: String, title: String?, soundName: String?) {
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date.init(timeIntervalSinceNow: delay)
        
        localNotification.alertBody = body
        localNotification.applicationIconBadgeNumber = 0
        
        if soundName != nil {
            localNotification.soundName = soundName
        }
        
        if title != nil {
            if #available(iOS 8.2, *) {
                localNotification.alertTitle = title
            } else {
                // Fallback on earlier versions
            }
        }
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    static func cancelLocalNotifications() {
        let app = UIApplication.shared
        let notifications = app.scheduledLocalNotifications
        
        if notifications != nil {
            app.cancelAllLocalNotifications()
        }
    }
}

*/

