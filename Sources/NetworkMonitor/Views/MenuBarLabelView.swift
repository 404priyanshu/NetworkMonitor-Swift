import NetworkMonitorCore
import SwiftUI

struct MenuBarLabelView: View {
    let status: SystemStatus

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "arrow.down")
            Text(ByteFormat.rate(status.networkRates.downloadBytesPerSecond))
            Image(systemName: "arrow.up")
            Text(ByteFormat.rate(status.networkRates.uploadBytesPerSecond))
        }
    }
}
