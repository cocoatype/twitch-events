public enum NotificationEvent: Decodable {
    case channelPointsRewardRedemption(ChannelPointsRewardRedemption)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let metadataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .metadata)
        let eventType = try metadataContainer.decode(NotificationEventType.self, forKey: .subscriptionType)
        let eventDecoder = EventDecoder(rootDecoder: decoder)

        switch eventType {
        case .channelPointsCustomRewardRedemptionAdd:
            self = try .channelPointsRewardRedemption(ChannelPointsRewardRedemption(from: eventDecoder))
        default:
            fatalError("no")
        }
    }

    enum CodingKeys: String, CodingKey {
        case metadata
        case subscriptionType = "subscription_type"
        case event
        case payload
    }

    var associatedValue: Any {
        switch self {
        case .channelPointsRewardRedemption(let redemption):
            return redemption
        }
    }
}
