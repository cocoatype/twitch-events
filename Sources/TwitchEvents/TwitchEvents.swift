import AsyncAlgorithms
import Foundation

public final class TwitchEvents {
    public let events = AsyncThrowingChannel<NotificationEvent, Error>()

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
                        await self.events.send(notificationMessage.event)
                        for channel in self.mimetime {
                            if channel.canSend(notificationMessage.event.associatedValue) {
                                await channel.send(notificationMessage.event.associatedValue)
                            }
                        }
                    }
                }
            } catch {
                dump(error)
            }
        }
    }

    public func events<EventType>(ofType: EventType.Type) -> AsyncThrowingChannel<EventType, Error> {
        let newChannel = AsyncThrowingChannel<EventType, Error>()
        mimetime.append(newChannel)
        return newChannel
    }

    // mimetime by @eaglenaut on 11/28/22
    // the list of subscribed channels
    private var mimetime = [Channel]()
}

protocol Channel {
    func canSend(_ element: Any) -> Bool
    func send(_ element: Any) async
}

extension AsyncThrowingChannel: Channel {
    func canSend(_ element: Any) -> Bool {
        return (element as? Element) != nil
    }

    func send(_ element: Any) async {
        guard let typedElement = element as? Element else { return }
        await send(typedElement)
    }
}
