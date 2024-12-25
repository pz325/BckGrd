import Foundation
import SwiftUI
import UserNotifications

func logMessage(_ message: String, functionName: String = #function) {
    print("\(functionName): \(message)")
}

class Utilities {
    static func startTimer(timeout: TimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: timeout)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    static func setBackground(imageFilePath: String) {
        print("Setting background to \(imageFilePath)")
        do {
            let imageURL = URL(fileURLWithPath: imageFilePath)
            if let screen = NSScreen.main {
                try NSWorkspace.shared.setDesktopImageURL(imageURL, for: screen, options: [:])
            }
        } catch {
            print(error)
        }
    }

    static func scheduleNotification() {
        Utilities.startTimer(timeout: 5){
            Utilities.sendNotification(title: "今天天气挺好的", body: "一起睡觉吧")
        }
    }
    
    static func sendScheduledNotification(title:String, body:String, dateComponents:DateComponents) {
        logMessage("Sending scheduled notification \(title) \(body)")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled successfully")
                    }
                }
            }
        }
    }
    
    static func scheduleRepeatNotification(title: String, body: String, timeInterval: TimeInterval) {
        logMessage("Sending repeat notification \(title) \(body)")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Repeat notification scheduled successfully")
                    }
                }
            }
        }
    }
    
    
    static func sendNotification(title:String, body:String) {
        logMessage("Sending notification \(title) \(body)")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let center = UNUserNotificationCenter.current()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification sent successfully")
                    }
                }
            }
        }
    }
    
    static func setRandomBackground() {
        UnsplashUtilities.getRandomImageUrl {
            imageUrl in UnsplashUtilities.downloadRandomImage(imageUrlString: imageUrl) {
                imageFilePath in Utilities.setBackground(imageFilePath: imageFilePath)
            }
        }
    }

    @objc static func dispatchDailyQuote() {
        DailyQuote.fetch { quote in
            Utilities.sendNotification(title: "每日金句", body: quote!)
        }
    }
    
    static func dispatchDailyQuoteAtNoon() {
        let dateComponents = DateComponents(hour: 12, minute: 0)
        DailyQuote.fetch { quote in
            Utilities.sendScheduledNotification(title: "每日金句", body: quote!, dateComponents: dateComponents)
        }
    }
    
    static func dispatchDailyQuoteNotificationRepeatedly() {
        let threeHoursInSeconds: TimeInterval = 10800 // 3 hours
        let timer = Timer.scheduledTimer(timeInterval: threeHoursInSeconds, target: self, selector: #selector(dispatchDailyQuote), userInfo: nil, repeats: true)

        // Add timer to main run loop
        RunLoop.main.add(timer, forMode: .common)
    }
}
