struct NotificationMessage: Message {
    let metadata: Metadata
    let payload: Payload

    struct Payload: Decodable {
        let event: Event

        struct Event: Decodable {
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
    }
}
