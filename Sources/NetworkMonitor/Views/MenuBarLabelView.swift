import NetworkMonitorCore
import SwiftUI

struct MenuBarLabelView: View {
    let status: SystemStatus

    var body: some View {
        HStack(spacing: 5) {
            RatePill(
                systemImage: "arrow.down",
                rate: ByteFormat.rate(status.networkRates.downloadBytesPerSecond)
            )

            Divider()
                .frame(height: 11)

            RatePill(
                systemImage: "arrow.up",
                rate: ByteFormat.rate(status.networkRates.uploadBytesPerSecond)
            )
        }
        .font(.system(size: 11, weight: .medium, design: .rounded))
        .monospacedDigit()
    }
}

private struct RatePill: View {
    let systemImage: String
    let rate: String

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: systemImage)
                .font(.system(size: 9, weight: .bold))
                .symbolRenderingMode(.hierarchical)

            Text(rate)
                .lineLimit(1)
        }
    }
}
