import Foundation

public enum APIError: Error {
    case receivedDataMessage(Data)
    case receivedUnknownMessage
}
