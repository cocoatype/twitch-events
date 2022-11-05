import Foundation

enum SubscriptionCreator {
    static func createSubscription(token: String, clientID: String, request: SubscriptionRequest) async throws {
        var urlRequest = URLRequest(url: Self.url)
        urlRequest.allHTTPHeaderFields = [
            "Authorization": "Bearer \(token)",
            "Client-Id": clientID,
            "Content-Type": "application/json"
        ]
        urlRequest.httpBody = try JSONEncoder().encode(request)
        urlRequest.httpMethod = "POST"

        do {
            let result = try await URLSession.shared.data(for: urlRequest)
            dump(result)
        } catch {
            dump(error)
        }
    }

    private static let url: URL! = {
        guard let url = URL(string: "https://api.twitch.tv/helix/eventsub/subscriptions") else {
            fatalError("Invalid URL for Twitch chat websockets")
        }
        return url
    }()
}
