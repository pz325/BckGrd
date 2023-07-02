//
//  ContentView.swift
//  Bckgrd
//
//  Created by Ping Zou on 21/06/2023.
//

import SwiftUI

import UserNotifications

class StatusMenuController: NSObject, NSMenuDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var statusMenu: NSMenu!
    
    override init() {
        super.init()
        
        statusMenu = NSMenu()
        statusMenu.delegate = self
        
        statusMenu.addItem(NSMenuItem(title: "Button 1", action: #selector(button1Clicked), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem(title: "Button 2", action: #selector(button2Clicked), keyEquivalent: ""))
        statusMenu.addItem(NSMenuItem.separator())
        statusMenu.addItem(NSMenuItem(title: "Quit", action: #selector(quitClicked), keyEquivalent: "q"))
        
        statusItem.menu = statusMenu
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "app", accessibilityDescription: nil)
        }
    }
    
    @objc func button1Clicked() {
        print("Button 1 clicked")
    }
    
    @objc func button2Clicked() {
        print("Button 2 clicked")
    }
    
    @objc func quitClicked() {
        NSApplication.shared.terminate(self)
    }
}


struct ContentView: View {
    @State private var imageFilePath: String = "/Users/menrfa/Downloads/FzFDzP8XsA4kNAQ.jpeg"
    @State private var isTimerRunning = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                imageFilePath,
                text: $imageFilePath)
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

