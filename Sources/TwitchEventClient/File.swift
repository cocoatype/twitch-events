import Foundation
import TwitchEvents

@main
final class Client {
    static func main() async throws -> Void {
        let chat = TwitchEvents(token: CommandLine.arguments[1], name: "cocoatype")
        do {
            Task.detached {
                for try await redemption in chat.events(ofType: ChannelPointsRewardRedemption.self) {
                    print("Thanks for the \(redemption.reward.title), \(redemption.userName)!")
                }
            }

            for try await _ in chat.events {
                print("old event!")
            }
        } catch {
            print(String(describing: error))
            exit(1)
        }
    }
}
