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
    @State private var isTimerRunning = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                imageFilePath,
                text: $imageFilePath)
            
            Button(
                "Update",
                action: {self.setBackground(imageFilePath: imageFilePath)}
            )
            
            Button("Send Notification") {
                requestNotificationPermission()
                scheduleNotification()
            }
            
            Button("Start Timer") {
                startTimer()
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
        content.title = "New Message"
        content.body = "You have received a new message."
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
    
    
    func startTimer() {
        isTimerRunning = true
        
        DispatchQueue.global(qos: .background).async {
            sleep(5) // Simulating a 10-second timeout
            
            DispatchQueue.main.async {
                sendNotification(title: "hi", body: "content")
                isTimerRunning = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
