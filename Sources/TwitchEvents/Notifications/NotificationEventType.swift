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
