struct NotificationMessage: Message {
    let metadata: Metadata
    let event: NotificationEvent

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.metadata = try container.decode(Metadata.self, forKey: .metadata)
        self.event = try NotificationEvent(from: decoder)
    }

    enum CodingKeys: CodingKey {
        case metadata
        case event
    }
}
