//
//  Notification.swift
//  Bckgrd
//
//  Created by Ping Zou on 23/06/2023.
//

import Foundation
import UserNotifications

func sendNotification(title:String, body:String) {
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
    
    center.add(request) { error in
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
