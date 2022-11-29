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

enum NotificationEvent: Decodable {
    case channelPointsRewardRedemption(ChannelPointsRewardRedemption)

    init(from decoder: Decoder) throws {
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
}

enum NotificationEventType: String, Codable, CaseIterable {
  case channelUpdate = "channel.update"
  case channelFollow = "channel.follow"
  case channelSubscribe = "channel.subscribe"
  case channelSubscriptionEnd = "channel.subscription.end"
  case channelSubscriptionGift = "channel.subscription.gift"
  case channelSubscriptionMessage = "channel.subscription.message"
  case channelCheer = "channel.cheer"
  case channelRaid = "channel.raid"
  case channelBan = "channel.ban"
  case channelUnban = "channel.unban"
  case channelModeratorAdd = "channel.moderator.add"
  case channelModeratorRemove = "channel.moderator.remove"
  case channelPointsCustomRewardAdd = "channel.channel_points_custom_reward.add"
  case channelPointsCustomRewardUpdate = "channel.channel_points_custom_reward.update"
  case channelPointsCustomRewardRemove = "channel.channel_points_custom_reward.remove"
  case channelPointsCustomRewardRedemptionAdd = "channel.channel_points_custom_reward_redemption.add"
  case channelPointsCustomRewardRedemptionUpdate = "channel.channel_points_custom_reward_redemption.update"
  case channelPollBegin = "channel.poll.begin"
  case channelPollProgress = "channel.poll.progress"
  case channelPollEnd = "channel.poll.end"
  case channelPredictionBegin = "channel.prediction.begin"
  case channelPredictionProgress = "channel.prediction.progress"
  case channelPredictionLock = "channel.prediction.lock"
  case channelPredictionEnd = "channel.prediction.end"
  case channelCharityCampaignDonate = "channel.charity_campaign.donate"
  case dropEntitlementGrant = "drop.entitlement.grant"
  case extensionBitsTransactionCreate = "extension.bits_transaction.create"
  case goalBegin = "channel.goal.begin"
  case goalProgress = "channel.goal.progress"
  case goalEnd = "channel.goal.end"
  case hypeTrainBegin = "channel.hype_train.begin"
  case hypeTrainProgress = "channel.hype_train.progress"
  case hypeTrainEnd = "channel.hype_train.end"
  case streamOnline = "stream.online"
  case streamOffline = "stream.offline"
  case userAuthorizationGrant = "user.authorization.grant"
  case userAuthorizationRevoke = "user.authorization.revoke"
  case userUpdate = "user.update"
}

extension NotificationEventType {
  /// The subscription type version
  var version: String {
    switch self {
    case .channelCharityCampaignDonate:
      return "beta"
    default:
      return "1"
    }
  }
}

struct ChannelPointsRewardRedemption: Decodable {
    let userName: String
    let reward: Reward

    struct Reward: Decodable {
        let title: String
    }

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case reward
    }
}

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
