struct WelcomeMessage: Message {
    let metadata: Metadata
    let payload: Payload

    var id: String { payload.session.id }

    struct Payload: Decodable {
        let session: Session

        struct Session: Decodable {
            let id: String
        }
    }
}
