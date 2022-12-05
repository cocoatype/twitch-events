import Foundation

extension Data {
    var hex: String {
        map { String(format: "%02x", $0) }.joined()
    }
}
