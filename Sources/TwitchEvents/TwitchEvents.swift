import AsyncAlgorithms
import Foundation

public final class TwitchEvents {
    public let events = AsyncThrowingChannel<Event, Error>()

    public init(token: String, name: String) {
        let dataSession = APIDataSession(token: token, name: name)
        Task.detached { [weak self] in
            do {
                for try await message in dataSession.messages {
                    switch message {
                    case .welcome(let welcomeMessage):
                        try await SubscriptionCreator.createSubscription(
                            token: token,
                            clientID: ProcessInfo.processInfo.environment["TWITCHEVENTS_CLIENT_ID"] ?? "",
                            request: ChannelPointsRedemptionSubscriptionRequest(sessionID: welcomeMessage.id, broadcasterID: "21575002"))
                        print("got welcome with ID: \(welcomeMessage.id)")
                    case .keepalive:
                        print("got keepalive")
                    case .notification(let notificationMessage):
                        self?.handleNotificationMessage(notificationMessage)
                    }
                }
            } catch {
                dump(error)
            }
        }
    }

    private func handleNotificationMessage(_ message: NotificationMessage) {
        switch message.event {
        case .channelPointsRewardRedemption(let redemption):
            print("Thanks for the \(redemption.reward.title), \(redemption.userName)!")
        }
    }
}
