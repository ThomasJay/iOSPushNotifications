//
//  AppDelegate.swift
//  APushApp
//
//  Created by Tom Jay on 3/27/16.
//  Copyright © 2016 TJ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func registerForAllNotifications() {
        
        // Set notifications for this application
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
    }

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register this app for notifications
        registerForAllNotifications()

        
        // Check for launch Options, this could be from Local or Remote Notifications that was used to Open the app!
        if let options = launchOptions as? [String : AnyObject] {

            
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                
                if let userInfo = notification.userInfo {
                    
                    let foo = userInfo["foo"] as! String
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        
                        self.showAlert("App Started from Local Notification", alert: "\(notification.alertBody!) foo=\(foo)", badgeCount: 0)
                    }
                    
                }
                
                
            }
            

            
            // Remote Push Notifications
            if let userInfo = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject] {
                
                
                if let aps = userInfo["aps"] {
                    
                    let badgeCount = aps["badge"] as! Int
                    
                    application.applicationIconBadgeNumber = badgeCount
                    
                    let alert = aps["alert"] as! String
                    
                    var message = alert
                    
                    if let messageId = userInfo["messageId"] {
                        
                        message = "\(alert) messageId=\(messageId)"
                    }
                    
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                        
                        self.showAlert("App Started from Push Notification", alert: message, badgeCount: badgeCount)
                        
                    }
                    
                    
                }
                
                
                
                
            }

        }
        
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

    // Called if successful registeration for APNS.
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //send this device token to server
        //print(deviceToken)
        
        
        let rawTokenString = NSString(format: "%@", deviceToken)
        print("didRegisterForRemoteNotificationsWithDeviceToken rawTokenString = \(rawTokenString)")

        var cleanedString = rawTokenString.stringByReplacingOccurrencesOfString("<", withString: "")
        cleanedString = cleanedString.stringByReplacingOccurrencesOfString(">", withString: "")
        print("didRegisterForRemoteNotificationsWithDeviceToken APN Tester Free Device Token String = \(cleanedString)")

        let serverReadyPushNotificationString = cleanedString.stringByReplacingOccurrencesOfString(" ", withString: "")
        print("didRegisterForRemoteNotificationsWithDeviceToken Server Device Token String = \(serverReadyPushNotificationString)")


    }
    
    // Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
        
        if let aps = userInfo["aps"] {
            
            let badgeCount = aps["badge"] as! Int
            
            application.applicationIconBadgeNumber = badgeCount
            
            let alert = aps["alert"] as! String
            
            var message = alert
            
            if let messageId = userInfo["messageId"] {
                
                message = "\(alert) messageId=\(messageId)"
            }
            
            print("didReceiveRemoteNotification alert message=\(alert) Badge Count=\(badgeCount)")
            
            // Show Alert to user
            showAlert("Push Notification In Foreground", alert: message, badgeCount: badgeCount)
            
            
        }

    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        print("didReceiveLocalNotification: \(notification)")
        
        
        
        
        if let userInfo = notification.userInfo {
            
            let foo = userInfo["foo"] as! String
            print("didReceiveLocalNotification: foo=\(foo)")
            
            showAlert("Local Notification In Foreground", alert: "\(notification.alertBody!) foo=\(foo)", badgeCount: 0)
            
        }
    }
    

    
    func showAlert(title: String, alert: String, badgeCount: Int) {
        
        var message = "\(alert)"
        
        if badgeCount > 0 {
            message = "\(alert) badgeCount=\(badgeCount)"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        alertController.addAction(okAction)
        
        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        
    }



}

