import Foundation
import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "dailyQuote" {
            DailyQuote.fetch { quote in
                if let quote = quote {
                    let content = UNMutableNotificationContent()
                    content.title = "每日金句"
                    content.body = quote
                    
                    let request = UNNotificationRequest(identifier: "fetchedQuote", content: content, trigger: nil)
                    UNUserNotificationCenter.current().add(request)
                }
            }
        }
        completionHandler()
    }
}