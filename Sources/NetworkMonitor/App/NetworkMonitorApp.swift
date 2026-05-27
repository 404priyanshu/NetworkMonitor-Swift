import AppKit
import NetworkMonitorCore
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

@main
struct NetworkMonitorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var sampler = StatusSampler()

    var body: some Scene {
        MenuBarExtra {
            MenuBarContentView(sampler: sampler)
        } label: {
            MenuBarLabelView(status: sampler.status)
                .onAppear {
                    sampler.start()
                }
        }
        .menuBarExtraStyle(.menu)
    }
}
