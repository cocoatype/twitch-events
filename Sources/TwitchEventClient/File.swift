import Foundation
import TwitchEvents

@main
final class Client {
    static func main() async throws -> Void {
        let chat = TwitchEvents(token: CommandLine.arguments[1], name: "cocoatype")
        do {
            for try await _ in chat.events {
//                print("\(message): \(message.text)")
            }
        } catch {
            print(String(describing: error))
            exit(1)
        }
    }
}
