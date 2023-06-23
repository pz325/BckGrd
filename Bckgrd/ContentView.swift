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
        }
        .padding()
    }
    
    
    func setBackground(imageFilePath: String) {
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
            sleep(10) // Simulating a 10-second timeout
            
            DispatchQueue.main.async {
                sendNotification()
                isTimerRunning = false
            }
        }
    }
    
    func sendNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "The timer you started has finished."
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: nil)
        
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
