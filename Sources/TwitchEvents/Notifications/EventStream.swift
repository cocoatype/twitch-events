class EventStream<EventType> {
    private lazy var underlyingValues: (AsyncStream<EventType>, AsyncStream<EventType>.Continuation?) = {
        var streamContinuation: AsyncStream<EventType>.Continuation?
        let stream = AsyncStream { continuation in
            streamContinuation = continuation
        }
        return (stream, streamContinuation)
    }()

    var sender: (Any) -> Void {
        guard let continuation = underlyingValues.1 else { return { _ in } }
        return { value in
            guard let typedValue = value as? EventType else { return }
            continuation.yield(typedValue)
        }
    }

    var events: AsyncStream<EventType> {
        return underlyingValues.0
    }
}
