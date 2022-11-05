import AsyncAlgorithms
import Foundation

public final class TwitchEvents {
    public let events = AsyncThrowingChannel<Event, Error>()

    public init(token: String, name: String) {
        let dataSession = APIDataSession(token: token, name: name)
        Task.detached {
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
                        print("Thanks for the \(notificationMessage.payload.event.reward.title), \(notificationMessage.payload.event.userName)!")
                    }
                }
            } catch {
                dump(error)
            }
        }
    }
}
