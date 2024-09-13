//
//  BckgrdApp.swift
//  Bckgrd
//
//  Created by Ping Zou on 21/06/2023.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        requestNotificationPermission()
        DailyQuote.scheduleDailyNotification()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let menu = NSMenu()
        
        let showWindowItem = NSMenuItem(title: "Change", action: #selector(setRandomBackground), keyEquivalent: "c")
        menu.addItem(showWindowItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Exit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "Status Icon")
        }
    }
    
    @objc func setRandomBackground() {
        Utilities.setRandomBackground()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted: \(granted)")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}

@main
struct BckgrdApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
