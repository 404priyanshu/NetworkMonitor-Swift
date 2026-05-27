import Foundation

public enum StatusDateFormat {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()

    public static func time(_ date: Date?) -> String {
        guard let date else {
            return "Waiting"
        }

        return formatter.string(from: date)
    }
}
