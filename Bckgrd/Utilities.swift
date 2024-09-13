import Foundation
import SwiftUI

struct Utilities {
    static func startTimer(timeout: TimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: timeout)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}