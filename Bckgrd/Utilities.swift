import Foundation
import SwiftUI
import UserNotifications

func logMessage(_ message: String, functionName: String = #function) {
    print("\(functionName): \(message)")
}

struct Utilities {
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

    static func sendNotification(title:String, body:String) {
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
    
    static func setRandomBackground() {
        UnsplashUtilities.getRandomImageUrl {
            imageUrl in UnsplashUtilities.downloadRandomImage(imageUrlString: imageUrl) {
                imageFilePath in Utilities.setBackground(imageFilePath: imageFilePath)
            }
        }
    }
}
