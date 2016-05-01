//
//  ViewController.swift
//  APushApp
//
//  Created by Tom Jay on 3/27/16.
//  Copyright © 2016 TJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func clearBadgeCountButtonPressed(sender: AnyObject) {
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    
    @IBAction func fireLocalNotificationButtonPressed(sender: UIButton) {
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        
        notification.alertBody = "Local Notification Test"
        notification.fireDate = NSDate(timeIntervalSinceNow: 10) // 10 seconds
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["foo": "bar" ]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

