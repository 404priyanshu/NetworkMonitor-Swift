import XCTest
@testable import NetworkMonitorCore

final class ByteFormatTests: XCTestCase {
    func testFormatsRatesWithBinaryUnits() {
        XCTAssertEqual(ByteFormat.rate(0), "0 B/s")
        XCTAssertEqual(ByteFormat.rate(512), "512 B/s")
        XCTAssertEqual(ByteFormat.rate(1024), "1.0 KB/s")
        XCTAssertEqual(ByteFormat.rate(1_572_864), "1.5 MB/s")
        XCTAssertEqual(ByteFormat.rate(12 * 1024 * 1024), "12 MB/s")
    }

    func testFormatsDiskSpace() {
        let diskSpace = DiskSpace(
            freeBytes: 128 * 1024 * 1024 * 1024,
            totalBytes: 512 * 1024 * 1024 * 1024
        )

        XCTAssertEqual(ByteFormat.diskFree(diskSpace), "128 GB free")
        XCTAssertEqual(ByteFormat.diskTotal(diskSpace), "512 GB")
    }
}
