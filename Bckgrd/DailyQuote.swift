import Foundation

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
}

struct QuoteResponse: Codable {
    var id: Int
    var title: String
}
