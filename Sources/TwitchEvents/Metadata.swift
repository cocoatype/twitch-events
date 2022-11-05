struct Metadata: Decodable {
    let messageType: MessageType

    enum CodingKeys: String, CodingKey {
        case messageType = "message_type"
    }
}
