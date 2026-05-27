import Foundation

#if canImport(Darwin)
import Darwin
#endif

public enum NetworkCounterProviderError: Error, LocalizedError {
    case unavailable

    public var errorDescription: String? {
        "Network counters are unavailable."
    }
}

public protocol NetworkCounterProviding {
    func readCounters() throws -> NetworkCountersSnapshot
}

public final class SystemNetworkCounterProvider: NetworkCounterProviding {
    public init() {}

    public func readCounters() throws -> NetworkCountersSnapshot {
        #if canImport(Darwin)
        var interfaceAddresses: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&interfaceAddresses) == 0, let firstAddress = interfaceAddresses else {
            throw NetworkCounterProviderError.unavailable
        }

        defer {
            freeifaddrs(interfaceAddresses)
        }

        var countersByName: [String: NetworkInterfaceCounter] = [:]
        var cursor: UnsafeMutablePointer<ifaddrs>? = firstAddress

        while let currentPointer = cursor {
            let current = currentPointer.pointee
            defer {
                cursor = current.ifa_next
            }

            guard
                let address = current.ifa_addr,
                address.pointee.sa_family == UInt8(AF_LINK),
                let rawData = current.ifa_data
            else {
                continue
            }

            let flags = Int32(current.ifa_flags)
            let isUp = (flags & IFF_UP) != 0
            let isRunning = (flags & IFF_RUNNING) != 0
            let isLoopback = (flags & IFF_LOOPBACK) != 0

            guard isUp, isRunning, !isLoopback else {
                continue
            }

            let data = rawData.assumingMemoryBound(to: if_data.self).pointee
            let name = String(cString: current.ifa_name)

            countersByName[name] = NetworkInterfaceCounter(
                name: name,
                receivedBytes: UInt64(data.ifi_ibytes),
                sentBytes: UInt64(data.ifi_obytes)
            )
        }

        return NetworkCountersSnapshot(
            counters: Array(countersByName.values).sorted { $0.name < $1.name },
            capturedAt: Date()
        )
        #else
        throw NetworkCounterProviderError.unavailable
        #endif
    }
}
