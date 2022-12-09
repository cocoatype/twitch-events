import Foundation
import TwitchEvents

@main
final class Client {
    static func main() async throws -> Void {
        let chat = TwitchEvents(token: CommandLine.arguments[1], name: "cocoatype")
        Task.detached {
            for try await redemption in chat.events(ofType: ChannelPointsRewardRedemption.self) {
                print("Thanks for the \(redemption.reward.title), \(redemption.userName)!")
            }
        }
    }
}
