import Foundation

public struct NetworkInterfaceCounter: Equatable, Sendable {
    public let name: String
    public let receivedBytes: UInt64
    public let sentBytes: UInt64

    public init(name: String, receivedBytes: UInt64, sentBytes: UInt64) {
        self.name = name
        self.receivedBytes = receivedBytes
        self.sentBytes = sentBytes
    }
}

public struct NetworkCountersSnapshot: Equatable, Sendable {
    public let counters: [NetworkInterfaceCounter]
    public let capturedAt: Date

    public init(counters: [NetworkInterfaceCounter], capturedAt: Date = Date()) {
        self.counters = counters
        self.capturedAt = capturedAt
    }
}

public struct NetworkRateCalculator: Sendable {
    private var previousSnapshot: NetworkCountersSnapshot?

    public init() {}

    public mutating func rates(from snapshot: NetworkCountersSnapshot) -> NetworkRates {
        defer {
            previousSnapshot = snapshot
        }

        guard let previousSnapshot else {
            return .zero
        }

        let interval = snapshot.capturedAt.timeIntervalSince(previousSnapshot.capturedAt)
        guard interval > 0 else {
            return .zero
        }

        let previousByName = Dictionary(uniqueKeysWithValues: previousSnapshot.counters.map { ($0.name, $0) })
        var receivedDelta: UInt64 = 0
        var sentDelta: UInt64 = 0

        for current in snapshot.counters {
            guard let previous = previousByName[current.name] else {
                continue
            }

            if current.receivedBytes >= previous.receivedBytes {
                receivedDelta += current.receivedBytes - previous.receivedBytes
            }

            if current.sentBytes >= previous.sentBytes {
                sentDelta += current.sentBytes - previous.sentBytes
            }
        }

        return NetworkRates(
            downloadBytesPerSecond: Double(receivedDelta) / interval,
            uploadBytesPerSecond: Double(sentDelta) / interval
        )
    }
}
