//
//  ContentView.swift
//  Bckgrd
//
//  Created by Ping Zou on 21/06/2023.
//

import SwiftUI

import UserNotifications

struct ContentView: View {
    @State private var imageFilePath: String = "/Users/menrfa/Downloads/FzFDzP8XsA4kNAQ.jpeg"
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                imageFilePath,
                text: $imageFilePath)
                
            
            Button(
                "Change background",
                action: {self.setBackground(imageFilePath: imageFilePath)}
            )
            
            Button("Send Notification") {
                requestNotificationPermission()
                scheduleNotification()
            }
            
            Button("Start Timer") {
                startTimerWithNotification()
            }
            
            Button("Set random background"){
                getRandomImageUrl {
                    imageUrl in downloadRandomImage(imageUrlString: imageUrl) {
                        imageFilePath in setBackground(imageFilePath: imageFilePath)
                    }
                }
            }
        }
        .padding()
        .onAppear {
                    NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil) { _ in
                        print("Lid opened")
                    }
                    NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { _ in
                        print("Lid closed")
                        getRandomImageUrl {
                            imageUrl in downloadRandomImage(imageUrlString: imageUrl) {
                                imageFilePath in setBackground(imageFilePath: imageFilePath)
                            }
                        }
                    }
                }
    }
    
    func setBackground(imageFilePath: String) {
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
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "今天天气挺好的"
        content.body = "一起睡觉吧"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
    func startTimerWithNotification() {
        Utilities.startTimer(timeout: 5) {
            sendNotification(title: "Timer Finished", body: "5 seconds have passed")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

