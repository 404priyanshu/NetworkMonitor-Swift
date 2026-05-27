import Foundation

public enum ByteFormat {
    public static func rate(_ bytesPerSecond: Double) -> String {
        format(bytes: bytesPerSecond, suffix: "/s")
    }

    public static func bytes(_ bytes: UInt64) -> String {
        format(bytes: Double(bytes), suffix: "")
    }

    public static func diskFree(_ diskSpace: DiskSpace) -> String {
        "\(bytes(diskSpace.freeBytes)) free"
    }

    public static func diskTotal(_ diskSpace: DiskSpace) -> String {
        bytes(diskSpace.totalBytes)
    }

    private static func format(bytes: Double, suffix: String) -> String {
        let units = ["B", "KB", "MB", "GB", "TB", "PB"]
        var value = max(0, bytes)
        var unitIndex = 0

        while value >= 1024, unitIndex < units.count - 1 {
            value /= 1024
            unitIndex += 1
        }

        let formattedValue: String
        if unitIndex == 0 {
            formattedValue = "\(Int(value.rounded()))"
        } else if value < 10 {
            formattedValue = String(format: "%.1f", locale: Locale(identifier: "en_US_POSIX"), value)
        } else {
            formattedValue = String(format: "%.0f", locale: Locale(identifier: "en_US_POSIX"), value)
        }

        return "\(formattedValue) \(units[unitIndex])\(suffix)"
    }
}
