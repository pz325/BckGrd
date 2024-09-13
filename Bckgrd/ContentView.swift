//
//  ContentView.swift
//  Bckgrd
//
//  Created by Ping Zou on 21/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var imageFilePath: String = "/Users/menrfa/Downloads/FzFDzP8XsA4kNAQ.jpeg"
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                imageFilePath,
                text: $imageFilePath)
                
            
            Button(
                "改变桌面背景",
                action: {Utilities.setBackground(imageFilePath: imageFilePath)}
            )
            
            Button("每日金句") {
                Utilities.dispatchDailyQuote()
            }
            
            Button("Start Timer") {
                startTimerWithNotification()
            }
            
            Button("随机改变桌面背景"){
                Utilities.setRandomBackground()
            }
        }
        .padding()
        .onAppear {
                    NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: nil) { _ in
                        print("Lid opened")
                    }
                    NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: nil) { _ in
                        print("Lid closed")
                        UnsplashUtilities.getRandomImageUrl {
                            imageUrl in UnsplashUtilities.downloadRandomImage(imageUrlString: imageUrl) {
                                imageFilePath in Utilities.setBackground(imageFilePath: imageFilePath)
                            }
                        }
                    }
                }
    }
    
    func startTimerWithNotification() {
        Utilities.startTimer(timeout: 5) {
            Utilities.sendNotification(title: "Timer Finished", body: "5 seconds have passed")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

