import Foundation

public struct NetworkRates: Equatable, Sendable {
    public static let zero = NetworkRates(downloadBytesPerSecond: 0, uploadBytesPerSecond: 0)

    public let downloadBytesPerSecond: Double
    public let uploadBytesPerSecond: Double

    public init(downloadBytesPerSecond: Double, uploadBytesPerSecond: Double) {
        self.downloadBytesPerSecond = max(0, downloadBytesPerSecond)
        self.uploadBytesPerSecond = max(0, uploadBytesPerSecond)
    }
}

public struct DiskSpace: Equatable, Sendable {
    public static let zero = DiskSpace(freeBytes: 0, totalBytes: 0)

    public let freeBytes: UInt64
    public let totalBytes: UInt64

    public init(freeBytes: UInt64, totalBytes: UInt64) {
        self.freeBytes = freeBytes
        self.totalBytes = totalBytes
    }
}

public struct SystemStatus: Equatable, Sendable {
    public static let empty = SystemStatus(
        networkRates: .zero,
        diskSpace: .zero,
        updatedAt: nil
    )

    public let networkRates: NetworkRates
    public let diskSpace: DiskSpace
    public let updatedAt: Date?

    public init(networkRates: NetworkRates, diskSpace: DiskSpace, updatedAt: Date?) {
        self.networkRates = networkRates
        self.diskSpace = diskSpace
        self.updatedAt = updatedAt
    }
}
