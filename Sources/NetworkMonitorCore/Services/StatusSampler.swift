import Combine
import Foundation

@MainActor
public final class StatusSampler: ObservableObject {
    @Published public private(set) var status: SystemStatus = .empty
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var isRunning = false

    private let networkCounterProvider: NetworkCounterProviding
    private let diskSpaceProvider: DiskSpaceProviding
    private var rateCalculator = NetworkRateCalculator()
    private var timer: Timer?

    public init(
        networkCounterProvider: NetworkCounterProviding = SystemNetworkCounterProvider(),
        diskSpaceProvider: DiskSpaceProviding = HomeVolumeDiskSpaceProvider()
    ) {
        self.networkCounterProvider = networkCounterProvider
        self.diskSpaceProvider = diskSpaceProvider
    }

    deinit {
        MainActor.assumeIsolated {
            timer?.invalidate()
        }
    }

    public func start() {
        guard timer == nil else {
            return
        }

        isRunning = true
        refresh()

        let refreshTimer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.refresh()
            }
        }
        refreshTimer.tolerance = 0.2
        RunLoop.main.add(refreshTimer, forMode: .common)
        timer = refreshTimer
    }

    public func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    public func refresh() {
        let previousStatus = status
        var latestRates = previousStatus.networkRates
        var latestDiskSpace = previousStatus.diskSpace
        var failures: [String] = []

        do {
            latestRates = rateCalculator.rates(from: try networkCounterProvider.readCounters())
        } catch {
            latestRates = .zero
            failures.append("Network")
        }

        do {
            latestDiskSpace = try diskSpaceProvider.readDiskSpace()
        } catch {
            latestDiskSpace = .zero
            failures.append("Disk")
        }

        status = SystemStatus(
            networkRates: latestRates,
            diskSpace: latestDiskSpace,
            updatedAt: Date()
        )
        errorMessage = failures.isEmpty ? nil : "\(failures.joined(separator: ", ")) unavailable"
    }
}
