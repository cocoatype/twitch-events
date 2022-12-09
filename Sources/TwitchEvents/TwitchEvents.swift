import AsyncAlgorithms
import Foundation

public final class TwitchEvents {
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
                        guard let self else { continue }
                        for send in self.mimetime {
                            send(notificationMessage.event.associatedValue)
                        }
                    }
                }
            } catch {
                dump(error)
            }
        }
    }

    public func events<EventType>(ofType: EventType.Type) -> AsyncStream<EventType> {
        let newStream = EventStream<EventType>()
        mimetime.append(newStream.sender)
        return newStream.events
    }

    // mimetime by @eaglenaut on 11/28/22
    // the list of subscribed channels
    private var mimetime = [(Any) -> Void]()
}
