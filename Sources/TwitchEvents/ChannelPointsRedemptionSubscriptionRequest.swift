struct ChannelPointsRedemptionSubscriptionRequest: SubscriptionRequest {
    let condition: Condition
    let transport: Transport
    let version = "1"
    let type = "channel.channel_points_custom_reward_redemption.add"

    init(sessionID: String, broadcasterID: String) {
        self.condition = Condition(broadcasterUserID: broadcasterID)
        self.transport = Transport(sessionID: sessionID)
    }

    struct Condition: Encodable {
        let broadcasterUserID: String

        enum CodingKeys: String, CodingKey {
            case broadcasterUserID = "broadcaster_user_id"
        }
    }

    struct Transport: Encodable {
        let method = "websocket"
        let sessionID: String

        enum CodingKeys: String, CodingKey {
            case method
            case sessionID = "session_id"
        }
    }
}
