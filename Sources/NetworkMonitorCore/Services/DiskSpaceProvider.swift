import Foundation

public enum DiskSpaceProviderError: Error, LocalizedError {
    case unavailable

    public var errorDescription: String? {
        "Disk space is unavailable."
    }
}

public protocol DiskSpaceProviding {
    func readDiskSpace() throws -> DiskSpace
}

public final class HomeVolumeDiskSpaceProvider: DiskSpaceProviding {
    private let volumeURL: URL
    private let fileManager: FileManager

    public init(
        volumeURL: URL = FileManager.default.homeDirectoryForCurrentUser,
        fileManager: FileManager = .default
    ) {
        self.volumeURL = volumeURL
        self.fileManager = fileManager
    }

    public func readDiskSpace() throws -> DiskSpace {
        do {
            let values = try volumeURL.resourceValues(forKeys: [
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeAvailableCapacityKey,
                .volumeTotalCapacityKey
            ])

            let freeBytes = values.volumeAvailableCapacityForImportantUsage
                ?? values.volumeAvailableCapacity.map(Int64.init)
            let totalBytes = values.volumeTotalCapacity.map(Int64.init)

            if let freeBytes, let totalBytes, freeBytes >= 0, totalBytes > 0 {
                return DiskSpace(freeBytes: UInt64(freeBytes), totalBytes: UInt64(totalBytes))
            }
        } catch {
            return try readDiskSpaceFromFileSystemAttributes()
        }

        return try readDiskSpaceFromFileSystemAttributes()
    }

    private func readDiskSpaceFromFileSystemAttributes() throws -> DiskSpace {
        let attributes = try fileManager.attributesOfFileSystem(forPath: volumeURL.path)

        guard
            let freeNumber = attributes[.systemFreeSize] as? NSNumber,
            let totalNumber = attributes[.systemSize] as? NSNumber,
            totalNumber.uint64Value > 0
        else {
            throw DiskSpaceProviderError.unavailable
        }

        return DiskSpace(
            freeBytes: freeNumber.uint64Value,
            totalBytes: totalNumber.uint64Value
        )
    }
}
