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
    var dailyQuoteTimer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        requestNotificationPermission()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let menu = NSMenu()
        
        let showWindowItem = NSMenuItem(title: "Change", action: #selector(setRandomBackground), keyEquivalent: "c")
        menu.addItem(showWindowItem)
        
        let tongleTimerItem = NSMenuItem(title: "Repeat Daily Quote", action: #selector(toggleDailyQuoteTimer), keyEquivalent: "t")
        tongleTimerItem.state = .off
        menu.addItem(tongleTimerItem)
        
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
    
    @objc func toggleDailyQuoteTimer(_ sender: NSMenuItem) {
        sender.state = sender.state == .on ? .off : .on
        if dailyQuoteTimer == nil {
            startDailyQuoteTimer()
        } else {
            stopDailyQuoteTimer()
        }
    }
    
    @objc func startDailyQuoteTimer() {
        dailyQuoteTimer = Utilities.dispatchDailyQuoteNotificationRepeatedly()
    }
    
    @objc func stopDailyQuoteTimer() {
        dailyQuoteTimer?.invalidate()
        dailyQuoteTimer = nil
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
