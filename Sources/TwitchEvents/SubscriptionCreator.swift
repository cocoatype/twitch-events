import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
            let result = try await URLSession.shared.backportedData(for: urlRequest)
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

extension URLSession {
    func backportedData(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        #if canImport(FoundationNetworking)
        return try await withCheckedThrowingContinuation { continuation in
            dataTask(with: urlRequest) { data, response, error in
                guard let data, let response else {
                    if let error {
                        return continuation.resume(throwing: error)
                    } else {
                        return continuation.resume(throwing: URLError(.unknown))
                    }
                }

                return continuation.resume(returning: (data, response))
            }.resume()
        }
        // put in backport
        #else
        return try await data(for: urlRequest)
        #endif        
    }
}
