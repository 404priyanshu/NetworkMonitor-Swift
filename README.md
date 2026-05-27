# NetworkMonitor

A lightweight macOS menu bar app that shows current network upload/download rates and basic system status.

## Requirements

- macOS 13 or newer
- Swift 6.0 or newer

## Run

From the project root:

```bash
./script/build_and_run.sh
```

The script builds the Swift package, creates `dist/NetworkMonitor.app`, and launches the app as a menu bar app.

## Test

```bash
swift test
```

## Build Only

```bash
swift build
```

## Project Structure

- `Sources/NetworkMonitor`: macOS app and menu bar UI
- `Sources/NetworkMonitorCore`: network, disk, formatting, and sampling logic
- `Tests/NetworkMonitorCoreTests`: unit tests for core behavior
- `script/build_and_run.sh`: local build and launch helper
