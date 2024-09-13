import Foundation
import UserNotifications

struct DailyQuote {
    static func fetch(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://soul-soup.fe.workers.dev/")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            // Print raw response as String
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw response:")
                print(rawResponse)
            }
            
            do {
                let quoteResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
                completion(quoteResponse.title)
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    static func scheduleDailyNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Daily Quote"
                content.body = "Your daily quote is ready!"
                
                var dateComponents = DateComponents()
                dateComponents.hour = 12
                dateComponents.minute = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "dailyQuote", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
    }
}

struct QuoteResponse: Codable {
    var id: Int
    var title: String
}
