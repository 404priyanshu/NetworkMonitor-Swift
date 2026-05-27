import AppKit
import NetworkMonitorCore
import SwiftUI

struct MenuBarContentView: View {
    @ObservedObject var sampler: StatusSampler

    var body: some View {
        Text("Down: \(ByteFormat.rate(sampler.status.networkRates.downloadBytesPerSecond))")
        Text("Up: \(ByteFormat.rate(sampler.status.networkRates.uploadBytesPerSecond))")
        Divider()
        Text("Disk free: \(ByteFormat.diskFree(sampler.status.diskSpace))")
        Text("Disk total: \(ByteFormat.diskTotal(sampler.status.diskSpace))")
        Divider()
        Text("Updated: \(StatusDateFormat.time(sampler.status.updatedAt))")
        Text("Status: \(statusText)")
        Divider()
        Button("Refresh Now") {
            sampler.refresh()
        }
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }

    private var statusText: String {
        if let errorMessage = sampler.errorMessage {
            return errorMessage
        }

        return sampler.isRunning ? "OK" : "Paused"
    }
}
