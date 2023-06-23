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
                "Update",
                action: {self.setBackground(imageFilePath: imageFilePath)}
            )
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
