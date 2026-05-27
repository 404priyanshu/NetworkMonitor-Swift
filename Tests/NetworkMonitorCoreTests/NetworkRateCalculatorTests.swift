import XCTest
@testable import NetworkMonitorCore

final class NetworkRateCalculatorTests: XCTestCase {
    func testFirstSnapshotReturnsZeroRates() {
        var calculator = NetworkRateCalculator()
        let rates = calculator.rates(from: snapshot(rx: 1_000, tx: 2_000, seconds: 0))

        XCTAssertEqual(rates, .zero)
    }

    func testComputesUploadAndDownloadRatesAcrossInterfaces() {
        var calculator = NetworkRateCalculator()

        _ = calculator.rates(from: NetworkCountersSnapshot(counters: [
            NetworkInterfaceCounter(name: "en0", receivedBytes: 1_000, sentBytes: 2_000),
            NetworkInterfaceCounter(name: "en1", receivedBytes: 5_000, sentBytes: 7_000)
        ], capturedAt: Date(timeIntervalSince1970: 0)))

        let rates = calculator.rates(from: NetworkCountersSnapshot(counters: [
            NetworkInterfaceCounter(name: "en0", receivedBytes: 3_000, sentBytes: 2_500),
            NetworkInterfaceCounter(name: "en1", receivedBytes: 6_000, sentBytes: 11_500)
        ], capturedAt: Date(timeIntervalSince1970: 2)))

        XCTAssertEqual(rates.downloadBytesPerSecond, 1_500)
        XCTAssertEqual(rates.uploadBytesPerSecond, 2_500)
    }

    func testIgnoresCountersThatReset() {
        var calculator = NetworkRateCalculator()

        _ = calculator.rates(from: snapshot(rx: 10_000, tx: 20_000, seconds: 0))
        let rates = calculator.rates(from: snapshot(rx: 1_000, tx: 2_000, seconds: 1))

        XCTAssertEqual(rates, .zero)
    }

    func testIgnoresNewInterfacesUntilTheyHavePreviousCounters() {
        var calculator = NetworkRateCalculator()

        _ = calculator.rates(from: NetworkCountersSnapshot(counters: [
            NetworkInterfaceCounter(name: "en0", receivedBytes: 1_000, sentBytes: 2_000)
        ], capturedAt: Date(timeIntervalSince1970: 0)))

        let rates = calculator.rates(from: NetworkCountersSnapshot(counters: [
            NetworkInterfaceCounter(name: "en0", receivedBytes: 2_000, sentBytes: 4_000),
            NetworkInterfaceCounter(name: "en1", receivedBytes: 20_000, sentBytes: 40_000)
        ], capturedAt: Date(timeIntervalSince1970: 1)))

        XCTAssertEqual(rates.downloadBytesPerSecond, 1_000)
        XCTAssertEqual(rates.uploadBytesPerSecond, 2_000)
    }

    private func snapshot(rx: UInt64, tx: UInt64, seconds: TimeInterval) -> NetworkCountersSnapshot {
        NetworkCountersSnapshot(
            counters: [
                NetworkInterfaceCounter(name: "en0", receivedBytes: rx, sentBytes: tx)
            ],
            capturedAt: Date(timeIntervalSince1970: seconds)
        )
    }
}
