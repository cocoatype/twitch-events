enum MessageType: String, Decodable {
    case keepalive = "session_keepalive"
    case welcome = "session_welcome"
    case notification
}
