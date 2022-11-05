enum EncodedMessage: Decodable {
    case welcome(WelcomeMessage)
    case keepalive(KeepaliveMessage)
    case notification(NotificationMessage)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let metadata = try container.decode(Metadata.self, forKey: .metadata)

        switch metadata.messageType {
        case .welcome:
            self = try .welcome(WelcomeMessage(from: decoder))
        case .keepalive:
            self = try .keepalive(KeepaliveMessage(from: decoder))
        case .notification:
            self = try .notification(NotificationMessage(from: decoder))
        }
    }

    enum CodingKeys: CodingKey {
        case metadata
    }
}
