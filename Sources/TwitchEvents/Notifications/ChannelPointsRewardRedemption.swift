public struct ChannelPointsRewardRedemption: Decodable {
    public let userName: String
    public let reward: Reward

    public struct Reward: Decodable {
        public let title: String
    }

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case reward
    }
}
