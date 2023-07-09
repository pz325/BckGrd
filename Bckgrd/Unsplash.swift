//
//  Unsplash.swift
//  Bckgrd
//
//  Created by Ping Zou on 24/06/2023.
//

import Foundation

struct Unsplash {
    static let url: String = "https://api.unsplash.com/"
    static let accessKey: String = "rgh1m8W94nh9D-FTbfJhE-gAnidjwK3qAOniiO2mrf0"
    static let secretKey: String = "HY4g-_gKSuC1aBYMBOBzTtki0byB50lAAf9dwyUIlvA"
    static let version:String = "v1"
}

struct UnsplashResponse: Codable {
    let urls: UnsplashURLs
}

struct UnsplashURLs: Codable {
    let regular: String
}

func getRandomImageUrl(completion: @escaping (String) -> Void) {
    // Make API request to Unsplash to get a random photo
    let urlString = "https://api.unsplash.com/photos/random?query=wallpaper&orientation=landscape&client_id=\(Unsplash.accessKey)"
    guard let url = URL(string: urlString) else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(Unsplash.version, forHTTPHeaderField: "Accept-Version")
    
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let result = try JSONDecoder().decode(UnsplashResponse.self, from: data)
            
            let imageUrlString = result.urls.regular
            logMessage(imageUrlString)
            
            // completion callback
            completion(imageUrlString)
        } catch {
            print(error)
        }
    }
    
    // start the task
    task.resume()
}

func downloadRandomImage(imageUrlString: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: imageUrlString) else {
        return
    }
    
    let task = URLSession.shared.downloadTask(with: url) { tempFileUrl, response, error in
        guard let imageTempFileUrl = tempFileUrl else {
            return
        }
        
        do {
            // Save the image to local drive
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for url in fileURLs {
                try? FileManager.default.removeItem(at: url)
            }
            
            let destinationURL = documentsDirectory.appendingPathComponent("wallpaper\(UUID().uuidString).jpg")
            logMessage(destinationURL.absoluteString)
            let imageData = try Data(contentsOf: imageTempFileUrl)
            try imageData.write(to: destinationURL)
            
            // completion callback
            completion(destinationURL.path)
        } catch {
            print(error)
        }
    }
    
    // start the task
    task.resume()
}
