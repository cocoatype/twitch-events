struct EventDecoder: Decoder {
    let rootDecoder: Decoder
    init(rootDecoder: Decoder) {
        self.rootDecoder = rootDecoder
    }

    var codingPath: [CodingKey] { return [CodingKeys.payload] }

    var userInfo: [CodingUserInfoKey : Any] { [:] }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = try rootDecoder.container(keyedBy: CodingKeys.self)
        let payloadContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
        let eventContainer = try payloadContainer.nestedContainer(keyedBy: type, forKey: .event)
        return eventContainer
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "oops"))
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "oops"))
    }

    enum CodingKeys: String, CodingKey {
        case payload
        case event
    }
}
