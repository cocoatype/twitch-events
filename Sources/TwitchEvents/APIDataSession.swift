import AsyncAlgorithms
import Foundation

final class APIDataSession: NSObject, URLSessionWebSocketDelegate {
    init(token: String, name: String) {
        let task = URLSession.shared.webSocketTask(with: Self.url)
        self.task = task
        super.init()
        self.task.delegate = self
        self.task.resume()
    }

    // MARK: Messages

    let messages = AsyncThrowingChannel<EncodedMessage, Error>()

    private func readMessage(from task: URLSessionWebSocketTask) {
        Task {
            do {
                let message = try await task.receive()
                switch message {
                case .data(let data):
                    throw APIError.receivedDataMessage(data)
                case .string(let string):
                    for line in string.split(whereSeparator: { $0.isNewline }) {
                        guard let data = line.data(using: .utf8) else { continue }
                        do {
                            try await messages.send(JSONDecoder().decode(EncodedMessage.self, from: data))
                        } catch {
                            print("unknown message: \(line)")
                        }
                    }
                @unknown default:
                    throw APIError.receivedUnknownMessage
                }
                readMessage(from: task)
            } catch {
                await messages.fail(error)
            }
        }
    }

    // MARK: URL Session Task Delegate

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        readMessage(from: webSocketTask)
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        messages.finish()
    }

    // MARK: Boilerplate

    private static let url: URL! = {
        guard let url = URL(string: "wss://eventsub-beta.wss.twitch.tv/ws") else {
            fatalError("Invalid URL for Twitch chat websockets")
        }
        return url
    }()

    private let task: URLSessionWebSocketTask
}

extension Data {
    var hex: String {
        map { String(format: "%02x", $0) }.joined()
    }
}
