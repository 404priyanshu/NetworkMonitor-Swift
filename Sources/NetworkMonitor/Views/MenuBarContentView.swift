import AppKit
import NetworkMonitorCore
import SwiftUI

struct MenuBarContentView: View {
    @ObservedObject var sampler: StatusSampler

    var body: some View {
        Label("Network Monitor", systemImage: "waveform.path.ecg")
            .font(.headline)

        Divider()

        Label(
            "Download  \(ByteFormat.rate(sampler.status.networkRates.downloadBytesPerSecond))",
            systemImage: "arrow.down.circle.fill"
        )
        Label(
            "Upload  \(ByteFormat.rate(sampler.status.networkRates.uploadBytesPerSecond))",
            systemImage: "arrow.up.circle.fill"
        )

        Divider()

        Label("Disk Free  \(ByteFormat.diskFree(sampler.status.diskSpace))", systemImage: "internaldrive")
        Label("Disk Total  \(ByteFormat.diskTotal(sampler.status.diskSpace))", systemImage: "internaldrive.fill")

        Divider()

        Label("Updated  \(StatusDateFormat.time(sampler.status.updatedAt))", systemImage: "clock")
        Label(statusText, systemImage: statusIconName)

        Divider()

        Button {
            sampler.refresh()
        } label: {
            Label("Refresh Now", systemImage: "arrow.clockwise")
        }

        Button {
            NSApplication.shared.terminate(nil)
        } label: {
            Label("Quit", systemImage: "power")
        }
    }

    private var statusText: String {
        if let errorMessage = sampler.errorMessage {
            return errorMessage
        }

        return sampler.isRunning ? "OK" : "Paused"
    }

    private var statusIconName: String {
        if sampler.errorMessage != nil {
            return "exclamationmark.triangle.fill"
        }

        return sampler.isRunning ? "checkmark.circle.fill" : "pause.circle.fill"
    }
}
